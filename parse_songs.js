const fs = require('fs');

function parseMezmurTxt(inputFile, outputFile) {
  const content = fs.readFileSync(inputFile, 'utf8');

  let rawSongs;
  if (content.includes('=== SONG')) {
    rawSongs = content.split(/\n(?==== SONG \d+ ===)/);
  } else {
    rawSongs = content.split(/\n(?=\d+[\.\s])/);
  }

  const songs = [];

  rawSongs.forEach((raw, index) => {
    let lines = raw.split('\n').map(l => l.trim()).filter(l => l.length > 0);
    if (lines.length === 0) return;

    if (lines[0].startsWith('=== SONG')) {
      lines = lines.slice(1);
    }
    if (lines.length === 0) return;

    const idx = index + 1;
    const title = lines[0].replace(/^\d+[\.\s]*/, '');

    const bodyLines = lines.slice(1);
    let chorus = "";
    const stanzas = [];
    let currentStanza = [];

    bodyLines.forEach(line => {
      if (/^\d+$/.test(line) || /^\d+\./.test(line)) {
        if (currentStanza.length > 0) {
          if (!chorus && stanzas.length === 0) {
            chorus = currentStanza.join('\n');
          } else {
            stanzas.push(currentStanza.join('\n'));
          }
          currentStanza = [];
        }
      } else {
        currentStanza.push(line);
      }
    });

    if (currentStanza.length > 0) {
      if (!chorus && stanzas.length === 0) {
        chorus = currentStanza.join('\n');
      } else {
        stanzas.push(currentStanza.join('\n'));
      }
    }

    const lyrics = (chorus + "\n\n" + stanzas.join('\n\n')).trim();

    songs.push({
      id: idx.toString(),
      number: idx,
      title: title,
      composer: "Henon Choir",
      category: "Mezmur",
      isFeatured: idx <= 4,
      chorus: chorus,
      stanzas: stanzas.length > 0 ? stanzas : [chorus],
      lyrics: lyrics
    });
  });

  fs.mkdirSync('assets/data', { recursive: true });
  fs.writeFileSync(outputFile, JSON.stringify(songs, null, 2), 'utf8');
  console.log(`Successfully exported ${songs.length} songs to ${outputFile}`);
}

parseMezmurTxt('mezmur_text.txt', 'assets/data/songs.json');
