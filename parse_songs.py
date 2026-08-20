import json
import re

def parse_mezmur_txt(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split text wherever a song block starts (e.g. '=== SONG <num> ===')
    if '=== SONG' in content:
        raw_songs = re.split(r'\n(?==== SONG \d+ ===)', content)
    else:
        raw_songs = re.split(r'\n(?=\d+[\.\s])', content)

    songs = []

    for idx, raw in enumerate(raw_songs, start=1):
        lines = [line.strip() for line in raw.strip().split('\n') if line.strip()]
        if not lines:
            continue

        # Remove header marker if present
        if lines[0].startswith('=== SONG'):
            lines = lines[1:]
        if not lines:
            continue

        # Extract title from the first line
        title = re.sub(r'^\d+[\.\s]*', '', lines[0])

        # Separate chorus (lines before verse numbers) and verses/stanzas
        body_lines = lines[1:]
        chorus = ""
        stanzas = []
        current_stanza = []

        for line in body_lines:
            # Check if line starts a new numbered verse (e.g., "1", "2", "3" or "1.", "2.")
            if re.match(r'^\d+$', line) or re.match(r'^\d+\.', line):
                if current_stanza:
                    if not chorus and len(stanzas) == 0:
                        chorus = "\n".join(current_stanza)
                    else:
                        stanzas.append("\n".join(current_stanza))
                    current_stanza = []
            else:
                current_stanza.append(line)

        if current_stanza:
            if not chorus and len(stanzas) == 0:
                chorus = "\n".join(current_stanza)
            else:
                stanzas.append("\n".join(current_stanza))

        lyrics = (chorus + "\n\n" + "\n\n".join(stanzas)).strip() if stanzas else chorus

        songs.append({
            "id": str(idx),
            "number": idx,
            "title": title,
            "composer": "Henon Choir",
            "category": "Mezmur",
            "isFeatured": idx <= 4,
            "chorus": chorus,
            "stanzas": stanzas if stanzas else [chorus],
            "lyrics": lyrics
        })

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(songs, f, ensure_ascii=False, indent=2)

    print(f"Successfully exported {len(songs)} songs to {output_file}")

if __name__ == "__main__":
    parse_mezmur_txt('mezmur_text.txt', 'assets/data/songs.json')
