const fs = require('fs');

const doc = fs.readFileSync('scratch_docx/word/document.xml', 'utf8');

// Let's parse all paragraphs with runs and full text
const pRegex = /<w:p(?:\s[^>]*)?>([\s\S]*?)<\/w:p>/g;
const paragraphs = [];
let pMatch;
let pIdx = 0;

while ((pMatch = pRegex.exec(doc)) !== null) {
  const pXml = pMatch[1];
  const rRegex = /<w:r(?:\s[^>]*)?>([\s\S]*?)<\/w:r>/g;
  let rMatch;
  let text = '';
  let isBold = false;
  let fontSize = 0;
  
  while ((rMatch = rRegex.exec(pXml)) !== null) {
    const rXml = rMatch[1];
    if (/<w:b(?:\s|\/|>)/.test(rXml)) isBold = true;
    const szMatch = rXml.match(/<w:sz\s+w:val="(\d+)"/);
    if (szMatch) fontSize = Math.max(fontSize, parseInt(szMatch[1]));
    const tRegex = /<w:t(?:\s[^>]*)?>([\s\S]*?)<\/w:t>/g;
    let tMatch;
    while ((tMatch = tRegex.exec(rXml)) !== null) {
      text += tMatch[1];
    }
  }
  
  // Also check paragraph properties for page breaks or alignment
  const hasPageBreak = /<w:br\s+w:type="page"\s*\/>/.test(pXml);
  
  paragraphs.push({
    pIdx,
    text: text.trim(),
    isBold,
    fontSize,
    hasPageBreak
  });
  pIdx++;
}

console.log('Total paragraphs:', paragraphs.length);

// Let's look for song headers.
// Notice in the document, song titles / starts often look like:
// Number followed by title (e.g. "1  የጌታ ነኝ...", "2 እኔማ...", "3 ...", ..., "113 ...")
// Let's find all paragraphs matching /^\d+\s+[^\d]/ or /^\d+$/
const candidates = [];
paragraphs.forEach(p => {
  if (!p.text) return;
  // Match number at start
  const m = p.text.match(/^(\d{1,3})\s+(.*)$/);
  const mAlone = p.text.match(/^(\d{1,3})$/);
  const mDot = p.text.match(/^(\d{1,3})\.\s*(.*)$/);
  
  if (m) {
    candidates.push({ pIdx: p.pIdx, num: parseInt(m[1]), type: 'space', text: p.text, rest: m[2] });
  } else if (mAlone) {
    candidates.push({ pIdx: p.pIdx, num: parseInt(mAlone[1]), type: 'alone', text: p.text, rest: '' });
  } else if (mDot) {
    candidates.push({ pIdx: p.pIdx, num: parseInt(mDot[1]), type: 'dot', text: p.text, rest: mDot[2] });
  }
});

console.log('Total candidates found:', candidates.length);

// Let's inspect where songs 1, 2, 3, 4, 5... 113 are located.
// Save candidates to JSON
fs.writeFileSync('candidates.json', JSON.stringify(candidates, null, 2), 'utf8');

// Let's print candidate lines that have type 'space' or 'alone'
console.log('--- Non-dot candidates: ---');
candidates.filter(c => c.type !== 'dot').forEach(c => {
  console.log(`[p #${c.pIdx}] #${c.num} (${c.type}): ${c.text.slice(0, 60)}`);
});
