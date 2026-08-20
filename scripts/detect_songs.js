const fs = require('fs');

const raw = fs.readFileSync('all_numbered_in_order.txt', 'utf8').split('\n');

// Let's inspect the lines.
// Notice that song headers are:
// 1 የጌታ ነኝ...
// 2 እኔማ...
// 3 እንዴት ተረፈች...
// etc.
// Within song 1: 1. አመጻ..., 2. አቤት...
// Within song 2: 1. ..., 2. ..., 3. ...
// Let's filter to lines where the number is strictly monotonically increasing or corresponds to song numbers.
let currentSong = 1;
const detectedSongs = [];

for (let line of raw) {
  if (!line) continue;
  const m = line.match(/^\[(\d+)\] #(\d+): (.*)$/);
  if (!m) continue;
  const pIdx = parseInt(m[1]);
  const num = parseInt(m[2]);
  const text = m[3];
  
  if (num === currentSong) {
    // If currentSong is 1, 2, 3...
    // Check if it looks like a song header (e.g. not a verse like "1. " or "2. " after we already started the song, or it's clearly a song title)
    detectedSongs.push({ songNum: num, pIdx, text });
    currentSong++;
  }
}

console.log('Detected songs up to:', currentSong - 1);
detectedSongs.forEach(s => {
  console.log(`Song ${s.songNum}: [${s.pIdx}] ${s.text.slice(0, 60)}`);
});
