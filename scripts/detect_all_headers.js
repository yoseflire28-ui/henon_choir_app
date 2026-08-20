const fs = require('fs');

const lines = fs.readFileSync('all_paras_clean.txt', 'utf8').split('\n');

const paras = lines.map(line => {
  const pipeIdx = line.indexOf(' | ');
  if (pipeIdx === -1) return { idx: -1, text: '' };
  const idx = parseInt(line.slice(0, pipeIdx));
  const text = line.slice(pipeIdx + 3);
  return { idx, text };
});

// Let's find all lines in the document that look like song beginnings:
// In this document, every song starts with a number (1 to 114) followed by the title or space.
// Notice in the document, verses within a song are usually "1. ", "2. ", "3. ", "4. ", etc. (single digit + dot + space).
// Some song headers might be "1  የጌታ...", "2 በተከበበች...", ..., "10 ኤልሮዕ", etc.
// Let's find all numbered lines and examine them carefully:

const allNumbered = [];
for (let p of paras) {
  if (!p.text) continue;
  const m = p.text.match(/^(\d{1,3})([\.\s\t].*)$/);
  if (m) {
    allNumbered.push({
      pIdx: p.idx,
      num: parseInt(m[1]),
      text: p.text
    });
  }
}

console.log('Total numbered paragraphs in document:', allNumbered.length);

// Let's find each song from 1 to 113.
// Let's write a smarter locator that inspects every numbered line.
// If num > lastSongNum (and within plausible step), or if it's the start of a new song block.
let lastSongNum = 0;
const songHeaders = [];

for (let i = 0; i < allNumbered.length; i++) {
  const item = allNumbered[i];
  
  // A song header has item.num > lastSongNum (or next expected number)
  // And it is NOT a verse number inside the current song (e.g. verse 1, 2, 3, 4, 5, 6)
  if (item.num === lastSongNum + 1 || (item.num > lastSongNum && item.num <= lastSongNum + 3)) {
    // Check if this is a verse of the current song:
    // E.g. if lastSongNum is 1, and item.num is 2: is item.text "2. አቤት ሰይጣን..." (verse 2) or "2 በተከበበች..." (song 2)?
    // Verses usually have dot right after number and are within the body of the previous song.
    // Let's check formatting:
    const isVersePattern = /^\d+\.\s+/.test(item.text);
    
    // For small numbers (1..6), verses typically match /^\d+\.\s+/
    // But song 1 is "1  የጌታ...", song 2 is "2 በተከበበች...", song 3 is "3 ወዳጅ ነህ...", song 4 is "4 እኔስ በየሱሴ...", song 5 is "5 ምንም በሌለበት..."
    // Let's check if item is a verse:
    if (item.num <= 6 && isVersePattern && lastSongNum >= 1 && (item.pIdx - (songHeaders[songHeaders.length-1]?.pIdx || 0)) < 30) {
      // It's a verse!
      continue;
    }
    
    songHeaders.push(item);
    lastSongNum = item.num;
  }
}

console.log('Found song headers count:', songHeaders.length);
songHeaders.forEach((s, idx) => {
  console.log(`${idx + 1}. Doc #${s.num} [p #${s.pIdx}]: ${s.text.slice(0, 60)}`);
});
