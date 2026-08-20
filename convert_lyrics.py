import json
import re

def convert_txt_to_songs_json(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split document by song blocks marked with '=== SONG <num> ===' or song header
    raw_blocks = re.split(r'\n(?==== SONG \d+ ===)', content)
    songs = []

    for idx, raw in enumerate(raw_blocks, start=1):
        lines = [line.strip() for line in raw.strip().split('\n') if line.strip()]
        if not lines:
            continue
        
        # Remove '=== SONG <num> ===' marker if present
        if lines[0].startswith('=== SONG'):
            lines = lines[1:]
        
        if not lines:
            continue

        # First line is title
        title_line = lines[0]
        title = re.sub(r'^\d+\.\s*', '', title_line)
        lyrics = "\n".join(lines[1:]) if len(lines) > 1 else title_line

        songs.append({
            "id": str(idx),
            "number": idx,
            "title": title,
            "composer": "Henon Choir",
            "category": "Mezmur",
            "isFeatured": idx <= 4,
            "lyrics": lyrics
        })

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(songs, f, ensure_ascii=False, indent=2)

    print(f"Successfully converted {len(songs)} songs to {output_file}")

if __name__ == '__main__':
    convert_txt_to_songs_json('mezmur_text.txt', 'assets/data/songs.json')
