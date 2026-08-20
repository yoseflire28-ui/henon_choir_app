const fs = require('fs');

function convertTxtToSongsJson(inputFile, outputFile) {
  const content = fs.readFileSync(inputFile, 'utf8');

  // Split document by song blocks
  const rawBlocks = content.split(/\n(?==== SONG \d+ ===)/);
  const songs = [];

  rawBlocks.forEach((raw, index) => {
    let lines = raw.split('\n').map(l => l.trim()).filter(l => l.length > 0);
    if (lines.length === 0) return;

    if (lines[0].startsWith('=== SONG')) {
      lines = lines.slice(1);
    }
    if (lines.length === 0) return;

    const idx = index + 1;
    const titleLine = lines[0];
    const title = titleLine.replace(/^\d+\.\s*/, '');
    const lyrics = lines.length > 1 ? lines.slice(1).join('\n') : titleLine;

    const categories = ["Worship", "Praise", "Thanksgiving", "Prayer", "Old Song", "Spiritual", "Grace & Salvation"];
    let cat = "Praise";
    if (/አመሰግን|ምስጋና|ተመስገን|ውለታ|ክበር/i.test(lyrics)) cat = "Thanksgiving";
    else if (/ጸጋ|ምህረት|ይቅር|ደሙ|መስቀል/i.test(lyrics)) cat = "Grace & Salvation";
    else if (/ጸሎት|ማረኝ|አቤቱ|ድረስልኝ|አምላኬ/i.test(lyrics)) cat = "Prayer";
    else if (/ቅዱስ|ስገድ|አምልኮ|ክብር|ሃሌሉያ/i.test(lyrics)) cat = "Worship";
    else if (idx <= 15) cat = "Old Song";
    else cat = "Spiritual";

    songs.push({
      id: idx.toString(),
      number: idx,
      title: title,
      composer: "Henon Choir",
      category: cat,
      isFeatured: [1, 2, 3, 5, 8, 10, 15, 20, 25, 30, 50, 75, 100, 113].includes(idx),
      lyrics: lyrics
    });
  });

  fs.mkdirSync('assets/data', { recursive: true });
  fs.writeFileSync(outputFile, JSON.stringify(songs, null, 2), 'utf8');
  console.log(`Successfully converted ${songs.length} songs to ${outputFile}`);
}

convertTxtToSongsJson('mezmur_text.txt', 'assets/data/songs.json');
