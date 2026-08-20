const fs = require('fs');

const lines = fs.readFileSync('all_paras_clean.txt', 'utf8').split('\n');

const paras = lines.map(line => {
  const pipeIdx = line.indexOf(' | ');
  const idx = parseInt(line.slice(0, pipeIdx));
  const text = line.slice(pipeIdx + 3);
  return { idx, text };
});

// Let's identify all song start blocks.
// Let's look for all lines where text starts with a number that is not a verse in the middle of a song.
// Notice in the document, song headers have empty lines before them or are clearly major titles.
// Let's write a parser that scans through and finds all songs.

const songList = [];

for (let i = 0; i < paras.length; i++) {
  const t = paras[i].text.trim();
  if (!t) continue;
  
  // Match digits at start
  const m = t.match(/^(\d{1,3})(?:[\s\.\t]+)(.*)$/);
  if (m) {
    const num = parseInt(m[1]);
    const rest = m[2].trim();
    
    // Check if this is a verse number (1., 2., 3., 4., 5., 6.) inside a song or a song title
    // Let's check previous paragraph or surrounding context
    const isLikelyVerse = /^[1-6]\.\s+/.test(t) && songList.length > 0;
    
    // Let's print all song-like headers (num > 6, or if num <= 6, not formatted like '1. ' inside verse)
    // Actually let's record all numbered lines with context
  }
}

// Let's list all candidate song headers by finding all numbered lines where the number is a song title:
const candidates = [];
for (let i = 0; i < paras.length; i++) {
  const t = paras[i].text.trim();
  if (!t) continue;
  
  // Song titles:
  // Usually start with number followed by space or dot, and have multiple lines of song following before next numbered header.
  const m = t.match(/^(\d{1,3})(?:[\s\.\t]+)(.*)$/);
  if (m) {
    candidates.push({ idx: paras[i].idx, num: parseInt(m[1]), raw: t, rest: m[2] });
  }
}

fs.writeFileSync('all_candidates.json', JSON.stringify(candidates, null, 2), 'utf8');
console.log('Saved all_candidates.json, count:', candidates.length);
