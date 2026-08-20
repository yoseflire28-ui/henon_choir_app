const fs = require('fs');

const lines = fs.readFileSync('all_paras_clean.txt', 'utf8').split('\n');

const paras = lines.map(line => {
  const pipeIdx = line.indexOf(' | ');
  if (pipeIdx === -1) return { idx: -1, text: '' };
  const idx = parseInt(line.slice(0, pipeIdx));
  const text = line.slice(pipeIdx + 3);
  return { idx, text };
});

// Let's inspect the entire document and find all song start paragraphs.
// Every song in the document starts with:
// <number> [spaces/tabs] <song title or chorus>
// Let's distinguish between song headers and verse numbers:
// A verse number inside a song is formatted like "1. ", "2. ", "3. ", "4. ", "5. ", "6. " (i.e. with a dot right after the number).
// Song headers are formatted like "1 ", "2 ", "3 ", "4 ", ... "113 ", "114 " (number followed by space).
// Some song headers might be like "10  ...", "91  ...", etc.

const songStarts = [];

for (let i = 0; i < paras.length; i++) {
  const p = paras[i];
  const t = p.text.trim();
  if (!t) continue;
  
  // Match number at start followed by space (no dot) OR followed by Amharic text
  // e.g. "1  የጌታ...", "2 በተከበበች...", "10 ኤልሮዕ"
  const m = t.match(/^(\d{1,3})\s+(.*)$/);
  if (m) {
    const num = parseInt(m[1]);
    const rest = m[2].trim();
    
    // Some verses might be written as "1. " or mistakenly as "1  " if small number.
    // But notice: song numbers increase roughly 1, 2, 3, 4, 5...
    songStarts.push({
      pIdx: p.idx,
      num: num,
      raw: t,
      title: rest
    });
  }
}

console.log('Total space-separated numbered paragraphs:', songStarts.length);

// Let's filter out verse numbers that appear in the middle of a song:
// e.g. Song 90 had verses written as "1 ...", "2 ...", "3 ..." inside it
// Let's trace song by song:
const trueSongs = [];
let nextExpected = 1;

for (let i = 0; i < songStarts.length; i++) {
  const item = songStarts[i];
  
  // If item.num matches nextExpected or is close (e.g. author skipped 62 and wrote 63)
  if (item.num === nextExpected || item.num === nextExpected + 1 || (item.num > nextExpected && item.num <= nextExpected + 3)) {
    // Make sure it's not a 1, 2, 3 verse inside a recent song (unless nextExpected is 1, 2, 3)
    if (item.num < 10 && item.num < nextExpected) {
      continue;
    }
    trueSongs.push(item);
    nextExpected = item.num + 1;
  }
}

console.log('Detected true songs count:', trueSongs.length);
trueSongs.forEach((s, idx) => {
  console.log(`${idx + 1}. Doc #${s.num} [p #${s.pIdx}]: ${s.title.slice(0, 50)}`);
});
