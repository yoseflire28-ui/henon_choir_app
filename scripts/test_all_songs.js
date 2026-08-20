const fs = require('fs');

const lines = fs.readFileSync('all_paras_clean.txt', 'utf8').split('\n');

const paras = lines.map(line => {
  const pipeIdx = line.indexOf(' | ');
  const idx = parseInt(line.slice(0, pipeIdx));
  const text = line.slice(pipeIdx + 3);
  return { idx, text };
});

// Let's find all song headers from 1 to 113
// A song header has:
// - starts with integer N (where N matches the expected next song number, or matches a song pattern)
// - followed by space and Amharic text (not a dot like 1. or 2. unless it's a song number)
// Let's trace from song 1 to 113.

const songIndices = [];
let currentSongNum = 1;

for (let i = 0; i < paras.length; i++) {
  const text = paras[i].text.trim();
  if (!text) continue;
  
  // Test if text starts with currentSongNum
  // Pattern: "^" + currentSongNum + "([\\s\\t]+.*)?$"
  // Make sure it doesn't match verse number (e.g., if currentSongNum is 2, don't match "2. ")
  // BUT song 1 is "1  የጌታ..." or "1. ..."? Song 1 is "1  የጌታ...".
  // Let's check regex:
  const regexNoDot = new RegExp('^' + currentSongNum + '(\\s+[\\S\\s]*)$');
  const regexWithDot = new RegExp('^' + currentSongNum + '\\.\\s+');
  
  // Let's see if regexNoDot matches:
  if (regexNoDot.test(text)) {
    // Found song header!
    songIndices.push({
      songNum: currentSongNum,
      pIdx: paras[i].idx,
      header: text
    });
    currentSongNum++;
  }
}

console.log(`Found ${songIndices.length} songs using noDot match. Current song reached: ${currentSongNum}`);

// Let's see what numbers were missed if any
if (currentSongNum <= 113) {
  console.log(`Missed starting from song #${currentSongNum}`);
}

songIndices.forEach(s => {
  console.log(`Song ${s.songNum} [p #${s.pIdx}]: ${s.header.slice(0, 50)}`);
});
