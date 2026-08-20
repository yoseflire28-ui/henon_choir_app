const fs = require('fs');

const richParas = JSON.parse(fs.readFileSync('numbered_lines.json', 'utf8'));
const allParas = fs.readFileSync('all_paragraphs.txt', 'utf8').split('\n');

// Let's print out lines where num is between 1 and 120, along with context
let currentSongExpected = 1;
const candidateSongs = [];

// Let's find patterns in the doc
for (let item of richParas) {
  if (item.num === currentSongExpected) {
    console.log(`Match for ${currentSongExpected}: [${item.pIdx}] ${item.text}`);
    candidateSongs.push({ songNum: currentSongExpected, pIdx: item.pIdx, text: item.text });
    currentSongExpected++;
  }
}

console.log(`Found sequentially up to: ${currentSongExpected - 1}`);
