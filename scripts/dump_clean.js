const fs = require('fs');

const doc = fs.readFileSync('scratch_docx/word/document.xml', 'utf8');

const pRegex = /<w:p(?:\s[^>]*)?>([\s\S]*?)<\/w:p>/g;
const paragraphs = [];
let pMatch;
let pIdx = 0;

while ((pMatch = pRegex.exec(doc)) !== null) {
  const pXml = pMatch[1];
  const rRegex = /<w:r(?:\s[^>]*)?>([\s\S]*?)<\/w:r>/g;
  let rMatch;
  let text = '';
  
  while ((rMatch = rRegex.exec(pXml)) !== null) {
    const rXml = rMatch[1];
    const tRegex = /<w:t(?:\s[^>]*)?>([\s\S]*?)<\/w:t>/g;
    let tMatch;
    while ((tMatch = tRegex.exec(rXml)) !== null) {
      text += tMatch[1];
    }
  }
  
  paragraphs.push({
    pIdx,
    text: text.trim()
  });
  pIdx++;
}

// Let's write a locator for songs 1 to 113
// We want to detect the starting paragraph index for each song 1..113
// Let's inspect where songs 1..113 are located.
console.log('Inspecting song list...');

for (let i = 0; i < paragraphs.length; i++) {
  const t = paragraphs[i].text;
  if (!t) continue;
  
  // Look for potential song headers
  // E.g. ^\d{1,3}\s+ or ^\d{1,3}$ or ^\d{1,3}\.
  const m = t.match(/^(\d{1,3})(?:[\s\.\t]+)(.*)$/);
  if (m) {
    const num = parseInt(m[1]);
    if (num <= 115) {
      // Check if this looks like a song start or a stanza number
      // Stanzas inside a song are usually 1., 2., 3., 4., 5., 6.
      // Song starts have numbers 1, 2, 3... 113.
      // Let's print all to analyze
      // console.log(`[p #${i}] num=${num}: ${t}`);
    }
  }
}

// Let's dump all paragraphs to a clean numbered list
fs.writeFileSync('all_paras_clean.txt', paragraphs.map(p => `${p.pIdx} | ${p.text}`).join('\n'), 'utf8');
console.log('Saved all_paras_clean.txt');
