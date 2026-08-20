const fs = require('fs');

// Read the clean 113 songs generated from the document
const doc = fs.readFileSync('scratch_docx/word/document.xml', 'utf8');

const pRegex = /<w:p(?:\s[^>]*)?>([\s\S]*?)<\/w:p>/g;
const paragraphs = [];
let pMatch;
let pIdx = 0;

while ((pMatch = pRegex.exec(doc)) !== null) {
  const pXml = pMatch[1];
  const rRegex = /<w:r(?:\s[^>]*)?>([\s\S]*?)<\/w:r>/g;
  let rMatch;
  let text = '';
  
  while ((rMatch = rRegex.exec(pXml)) !== null) {
    const rXml = rMatch[1];
    const tRegex = /<w:t(?:\s[^>]*)?>([\s\S]*?)<\/w:t>/g;
    let tMatch;
    while ((tMatch = tRegex.exec(rXml)) !== null) {
      text += tMatch[1];
    }
  }
  
  paragraphs.push({ idx: pIdx, text: text.trim() });
  pIdx++;
}

const songStarts = [
  { docNum: 1, pIdx: 2 },
  { docNum: 2, pIdx: 27 },
  { docNum: 3, pIdx: 54 },
  { docNum: 4, pIdx: 94 },
  { docNum: 5, pIdx: 124 },
  { docNum: 6, pIdx: 152 },
  { docNum: 7, pIdx: 176 },
  { docNum: 8, pIdx: 218 },
  { docNum: 9, pIdx: 253 },
  { docNum: 10, pIdx: 288 },
  { docNum: 11, pIdx: 324 },
  { docNum: 12, pIdx: 361 },
  { docNum: 13, pIdx: 395 },
  { docNum: 14, pIdx: 427 },
  { docNum: 15, pIdx: 459 },
  { docNum: 16, pIdx: 481 },
  { docNum: 17, pIdx: 520 },
  { docNum: 18, pIdx: 543 },
  { docNum: 19, pIdx: 565 },
  { docNum: 20, pIdx: 590 },
  { docNum: 21, pIdx: 615 },
  { docNum: 22, pIdx: 640 },
  { docNum: 23, pIdx: 664 },
  { docNum: 24, pIdx: 687 },
  { docNum: 25, pIdx: 709 },
  { docNum: 26, pIdx: 734 },
  { docNum: 27, pIdx: 755 },
  { docNum: 28, pIdx: 780 },
  { docNum: 29, pIdx: 803 },
  { docNum: 30, pIdx: 826 },
  { docNum: 31, pIdx: 852 },
  { docNum: 32, pIdx: 915 },
  { docNum: 33, pIdx: 937 },
  { docNum: 34, pIdx: 960 },
  { docNum: 35, pIdx: 985 },
  { docNum: 36, pIdx: 1029 },
  { docNum: 37, pIdx: 1052 },
  { docNum: 38, pIdx: 1077 },
  { docNum: 39, pIdx: 1098 },
  { docNum: 40, pIdx: 1124 },
  { docNum: 41, pIdx: 1147 },
  { docNum: 42, pIdx: 1170 },
  { docNum: 43, pIdx: 1193 },
  { docNum: 44, pIdx: 1247 },
  { docNum: 45, pIdx: 1270 },
  { docNum: 46, pIdx: 1295 },
  { docNum: 47, pIdx: 1318 },
  { docNum: 48, pIdx: 1341 },
  { docNum: 49, pIdx: 1365 },
  { docNum: 50, pIdx: 1388 },
  { docNum: 51, pIdx: 1429 },
  { docNum: 52, pIdx: 1454 },
  { docNum: 53, pIdx: 1477 },
  { docNum: 54, pIdx: 1501 },
  { docNum: 55, pIdx: 1524 },
  { docNum: 56, pIdx: 1547 },
  { docNum: 57, pIdx: 1569 },
  { docNum: 58, pIdx: 1595 },
  { docNum: 59, pIdx: 1618 },
  { docNum: 60, pIdx: 1642 },
  { docNum: 61, pIdx: 1665 },
  { docNum: 63, pIdx: 1688 },
  { docNum: 64, pIdx: 1710 },
  { docNum: 65, pIdx: 1734 },
  { docNum: 66, pIdx: 1757 },
  { docNum: 67, pIdx: 1801 },
  { docNum: 68, pIdx: 1826 },
  { docNum: 69, pIdx: 1871 },
  { docNum: 70, pIdx: 1895 },
  { docNum: 71, pIdx: 1919 },
  { docNum: 72, pIdx: 1943 },
  { docNum: 73, pIdx: 1967 },
  { docNum: 74, pIdx: 1991 },
  { docNum: 75, pIdx: 2016 },
  { docNum: 76, pIdx: 2041 },
  { docNum: 77, pIdx: 2063 },
  { docNum: 78, pIdx: 2087 },
  { docNum: 79, pIdx: 2109 },
  { docNum: 80, pIdx: 2133 },
  { docNum: 81, pIdx: 2157 },
  { docNum: 82, pIdx: 2190 },
  { docNum: 83, pIdx: 2224 },
  { docNum: 84, pIdx: 2259 },
  { docNum: 85, pIdx: 2286 },
  { docNum: 86, pIdx: 2310 },
  { docNum: 87, pIdx: 2333 },
  { docNum: 88, pIdx: 2355 },
  { docNum: 89, pIdx: 2379 },
  { docNum: 90, pIdx: 2403 },
  { docNum: 91, pIdx: 2425 },
  { docNum: 92, pIdx: 2448 },
  { docNum: 93, pIdx: 2472 },
  { docNum: 94, pIdx: 2494 },
  { docNum: 95, pIdx: 2521 },
  { docNum: 96, pIdx: 2545 },
  { docNum: 97, pIdx: 2571 },
  { docNum: 98, pIdx: 2595 },
  { docNum: 99, pIdx: 2619 },
  { docNum: 100, pIdx: 2644 },
  { docNum: 101, pIdx: 2701 },
  { docNum: 102, pIdx: 2737 },
  { docNum: 103, pIdx: 2759 },
  { docNum: 104, pIdx: 2782 },
  { docNum: 105, pIdx: 2805 },
  { docNum: 106, pIdx: 2828 },
  { docNum: 107, pIdx: 2851 },
  { docNum: 108, pIdx: 2874 },
  { docNum: 109, pIdx: 2898 },
  { docNum: 110, pIdx: 2925 },
  { docNum: 111, pIdx: 2974 },
  { docNum: 112, pIdx: 3002 },
  { docNum: 113, pIdx: 3038 },
  { docNum: 114, pIdx: 3065 }
];

const songBlocks = [];

for (let i = 0; i < songStarts.length; i++) {
  const current = songStarts[i];
  const next = songStarts[i + 1];
  const startIdx = current.pIdx;
  const endIdx = next ? next.pIdx : paragraphs.length;

  const lines = [];
  for (let p = startIdx; p < endIdx; p++) {
    lines.push(paragraphs[p].text);
  }

  const songNum = i + 1;
  const headerLine = lines[0].replace(/^\d+[\.\s\t]+/, '').trim();
  const lyricsLines = lines.join('\n').replace(/\n{3,}/g, '\n\n').trim();

  songBlocks.push(`=== SONG ${songNum} ===\n${songNum}. ${headerLine}\n${lyricsLines}`);
}

const fullText = songBlocks.join('\n\n');
fs.writeFileSync('mezmur_text.txt', fullText, 'utf8');
console.log(`Generated mezmur_text.txt for ${songStarts.length} songs`);
