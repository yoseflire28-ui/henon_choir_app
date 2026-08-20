const fs = require('fs');

const doc = fs.readFileSync('scratch_docx/word/document.xml', 'utf8');

// Also let's check table structure vs paragraph structure
// Does document have tables?
const tblMatches = doc.match(/<w:tbl[\s\S]*?<\/w:tbl>/g);
console.log('Tables found:', tblMatches ? tblMatches.length : 0);

// Let's inspect how paragraphs are structured
// Some paragraphs might have runs with styles (bold, font size, etc.)
// Let's extract paragraphs with rich info (bold, size, text)
const pRegex = /<w:p(?:\s[^>]*)?>([\s\S]*?)<\/w:p>/g;
const richParas = [];
let pMatch;
let pIdx = 0;
while ((pMatch = pRegex.exec(doc)) !== null) {
  const pXml = pMatch[1];
  const rRegex = /<w:r(?:\s[^>]*)?>([\s\S]*?)<\/w:r>/g;
  let rMatch;
  let runs = [];
  while ((rMatch = rRegex.exec(pXml)) !== null) {
    const rXml = rMatch[1];
    const isBold = /<w:b(?:\s|\/|>)/.test(rXml);
    const szMatch = rXml.match(/<w:sz\s+w:val="(\d+)"/);
    const sz = szMatch ? parseInt(szMatch[1]) : null;
    const tRegex = /<w:t(?:\s[^>]*)?>([\s\S]*?)<\/w:t>/g;
    let tMatch;
    let text = '';
    while ((tMatch = tRegex.exec(rXml)) !== null) {
      text += tMatch[1];
    }
    if (text) {
      runs.push({ text, isBold, sz });
    }
  }
  const fullText = runs.map(r => r.text).join('').trim();
  richParas.push({
    pIdx,
    fullText,
    runs
  });
  pIdx++;
}

console.log('Total rich paragraphs:', richParas.length);

// Let's see all lines that start with numbers
const numberedLines = [];
richParas.forEach(p => {
  if (!p.fullText) return;
  // Match lines like '1 ', '1.', '1. ', '1  ', '12 ', '113 '
  const m = p.fullText.match(/^(\d{1,3})[\.\s\t]/);
  if (m) {
    numberedLines.push({
      pIdx: p.pIdx,
      num: parseInt(m[1]),
      text: p.fullText,
      runs: p.runs
    });
  }
});

console.log('Total numbered lines:', numberedLines.length);

// Save numbered lines to inspection file
fs.writeFileSync('numbered_lines.json', JSON.stringify(numberedLines, null, 2), 'utf8');
console.log('Saved numbered_lines.json');
