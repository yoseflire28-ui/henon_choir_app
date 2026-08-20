import 'dart:convert';

/// Immutable data model for a single choir song.
class Song {
  final String id;
  final String title;
  final String composer;
  final String category;
  final String lyrics;
  final bool isFeatured;

  const Song({
    required this.id,
    required this.title,
    required this.composer,
    required this.category,
    required this.lyrics,
    required this.isFeatured,
  });

  /// Creates a [Song] instance from a JSON [Map].
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      title: json['title'] as String,
      composer: json['composer'] as String,
      category: json['category'] as String,
      lyrics: json['lyrics'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  /// Converts this [Song] to a JSON [Map].
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'composer': composer,
        'category': category,
        'lyrics': lyrics,
        'isFeatured': isFeatured,
      };

  /// Decodes a JSON string into a list of [Song] objects.
  static List<Song> listFromJson(String jsonStr) {
    final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
    return decoded
        .map((e) => Song.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Returns a short snippet of the lyrics (first line or first 60 chars).
  String get lyricsSnippet {
    final firstLine = lyrics.split('\n').first;
    if (firstLine.length <= 60) return firstLine;
    return '${firstLine.substring(0, 57)}...';
  }

  /// Creates a copy of this [Song] with optional overrides.
  Song copyWith({
    String? id,
    String? title,
    String? composer,
    String? category,
    String? lyrics,
    bool? isFeatured,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      composer: composer ?? this.composer,
      category: category ?? this.category,
      lyrics: lyrics ?? this.lyrics,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Song(id: $id, title: $title)';
}
