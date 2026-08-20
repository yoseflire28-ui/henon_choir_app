const fs = require('fs');

const lines = fs.readFileSync('all_paras_clean.txt', 'utf8').split('\n');

const paras = lines.map(line => {
  const pipeIdx = line.indexOf(' | ');
  const idx = parseInt(line.slice(0, pipeIdx));
  const text = line.slice(pipeIdx + 3);
  return { idx, text };
});

// Let's trace song titles from 1 to 114
// Let's print out all headers found
const songCandidates = [];

for (let i = 0; i < paras.length; i++) {
  const p = paras[i];
  if (!p.text) continue;
  
  // Match lines like "1  ...", "2 ...", "113 ..."
  const m = p.text.match(/^(\d{1,3})(?:[\s\.\t]+)(.*)$/);
  if (m) {
    const num = parseInt(m[1]);
    songCandidates.push({
      pIdx: p.idx,
      num: num,
      line: p.text,
      rest: m[2].trim()
    });
  }
}

// Let's write a script to find song indices
// Let's check song numbers 1 to 114
console.log('Total number-starting lines:', songCandidates.length);

// Let's look for the main song headers:
// In this document, songs are 1, 2, 3... 113.
// Inside a song, verses are 1., 2., 3., 4.
// Let's verify each song's header line.
fs.writeFileSync('song_candidates.json', JSON.stringify(songCandidates, null, 2), 'utf8');
