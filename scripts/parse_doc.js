const fs = require('fs');
const path = require('path');

const doc = fs.readFileSync('scratch_docx/word/document.xml', 'utf8');

// Parse all paragraphs and also check if tables exist
const pRegex = /<w:p(?:\s[^>]*)?>([\s\S]*?)<\/w:p>/g;
const paragraphs = [];
let m;
while ((m = pRegex.exec(doc)) !== null) {
  const pXml = m[1];
  const tRegex = /<w:t(?:\s[^>]*)?>([\s\S]*?)<\/w:t>/g;
  let pText = '';
  let tm;
  while ((tm = tRegex.exec(pXml)) !== null) {
    pText += tm[1];
  }
  paragraphs.push(pText.trim());
}

console.log('Total paragraphs parsed:', paragraphs.length);

// Let's dump all non-empty paragraphs with their index so we can inspect
const dump = paragraphs.map((p, idx) => ({ idx, text: p })).filter(x => x.text.length > 0);

console.log('Non-empty count:', dump.length);

// Let's write all paragraphs to a text file to easily inspect
fs.writeFileSync('all_paragraphs.txt', dump.map(x => `[${x.idx}] ${x.text}`).join('\n'), 'utf8');
console.log('Saved to all_paragraphs.txt');
