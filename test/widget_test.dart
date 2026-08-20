import 'package:flutter_test/flutter_test.dart';
import 'package:yehenon_choir_mezmur/models/song_model.dart';

void main() {
  test('Song model json deserialization and copyWith', () {
    const jsonMap = {
      'id': '1',
      'title': 'የጌታ ነኝ እኔስ የጌታ',
      'composer': 'Henon Choir',
      'category': 'Grace & Salvation',
      'isFeatured': true,
      'lyrics': 'የጌታ ነኝ እኔስ የጌታ\nየጌታ ነኝ እኔስ የጌታ'
    };

    final song = Song.fromJson(jsonMap);
    expect(song.id, '1');
    expect(song.title, 'የጌታ ነኝ እኔስ የጌታ');
    expect(song.isFeatured, isTrue);
    expect(song.lyricsSnippet, 'የጌታ ነኝ እኔስ የጌታ');

    final updated = song.copyWith(isFeatured: false);
    expect(updated.isFeatured, isFalse);
    expect(updated.id, '1');
  });

  test('Song listFromJson decodes multiple items', () {
    const jsonStr = '''[
      {
        "id": "1",
        "title": "የጌታ ነኝ",
        "composer": "Henon Choir",
        "category": "Old Song",
        "isFeatured": true,
        "lyrics": "የጌታ ነኝ..."
      },
      {
        "id": "2",
        "title": "በተከበበች",
        "composer": "Henon Choir",
        "category": "Praise",
        "isFeatured": false,
        "lyrics": "በተከበበች..."
      }
    ]''';

    final songs = Song.listFromJson(jsonStr);
    expect(songs.length, 2);
    expect(songs[0].title, 'የጌታ ነኝ');
    expect(songs[1].title, 'በተከበበች');
  });
}
