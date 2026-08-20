const fs = require('fs');

const candidates = JSON.parse(fs.readFileSync('song_candidates.json', 'utf8'));
const lines = fs.readFileSync('all_paras_clean.txt', 'utf8').split('\n');

// Let's write an algorithm to find the 113 songs.
// Songs start with a number. Within a song, verses often start with 1., 2., 3., 4.
// Let's print out all potential song headers:
// When a number appears that is greater than or equal to current song number, or when song number increases monotonically.
let expectedSong = 1;
const songs = [];

for (let i = 0; i < candidates.length; i++) {
  const c = candidates[i];
  if (c.num === expectedSong) {
    // If it's expectedSong, could it be a verse 1 or 2?
    // Let's check: if expectedSong is 1, it's song 1.
    // If expectedSong is 2, is it verse 2 of song 1, or song 2?
    // Let's inspect context:
    console.log(`Candidate for Song ${expectedSong}: [p #${c.pIdx}] "${c.line}"`);
  }
}
