const fs = require('fs');

const lines = fs.readFileSync('all_paras_clean.txt', 'utf8').split('\n');

const paras = lines.map(line => {
  const pipeIdx = line.indexOf(' | ');
  const idx = parseInt(line.slice(0, pipeIdx));
  const text = line.slice(pipeIdx + 3);
  return { idx, text };
});

// Let's find all songs by scanning paragraph by paragraph
// Let's print any paragraph where text starts with digits and is likely a song title
const list = [];
for (let i = 0; i < paras.length; i++) {
  const p = paras[i];
  if (!p.text) continue;
  
  // Song headers in this document generally start with digits not followed by '.' (or followed by space/tab)
  // or start at the top of a song block.
  const m = p.text.match(/^(\d{1,3})([\.\s\t].*)$/);
  if (m) {
    const num = parseInt(m[1]);
    list.push({ idx: p.idx, num, text: p.text });
  }
}

// Print all items where num is between 1 and 115
fs.writeFileSync('all_numbered_in_order.txt', list.map(x => `[${x.idx}] #${x.num}: ${x.text}`).join('\n'), 'utf8');
console.log('Saved all_numbered_in_order.txt, total:', list.length);
