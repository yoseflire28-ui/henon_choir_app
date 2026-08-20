import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/song_model.dart';

/// Possible states for the async song-loading operation.
enum SongLoadStatus { initial, loading, loaded, error }

/// Central state provider for the song list, search, and favourites.
class SongProvider extends ChangeNotifier {
  // ─── State ─────────────────────────────────────────────────────────────
  List<Song> _allSongs = [];
  List<Song> _filteredSongs = [];
  Set<String> _favoriteIds = {};
  String _searchQuery = '';
  SongLoadStatus _status = SongLoadStatus.initial;
  String _errorMessage = '';

  // ─── Getters ──────────────────────────────────────────────────────────
  List<Song> get allSongs => _allSongs;
  List<Song> get filteredSongs => _filteredSongs;
  List<Song> get featuredSongs =>
      _allSongs.where((s) => s.isFeatured).toList();
  List<Song> get favoriteSongs =>
      _allSongs.where((s) => _favoriteIds.contains(s.id)).toList();
  Set<String> get favoriteIds => _favoriteIds;
  String get searchQuery => _searchQuery;
  SongLoadStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == SongLoadStatus.loading;
  bool get hasError => _status == SongLoadStatus.error;

  List<String> _recentSongIds = [];

  bool isFavorite(String id) => _favoriteIds.contains(id);

  // ─── Recent songs (dynamically tracked opened songs history) ───────────
  List<Song> get recentSongs {
    final songMap = {for (final s in _allSongs) s.id: s};
    final recents = _recentSongIds
        .map((id) => songMap[id])
        .whereType<Song>()
        .toList();
    if (recents.isEmpty) {
      return _allSongs.where((s) => !s.isFeatured).take(10).toList();
    }
    return recents.take(10).toList();
  }

  // ─── Public API ───────────────────────────────────────────────────────

  /// Loads songs from the bundled JSON asset and restores persisted
  /// favourite IDs and recently opened songs from [SharedPreferences].
  Future<void> loadSongs() async {
    if (_status == SongLoadStatus.loading) return;
    _status = SongLoadStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      // Load JSON asset
      final jsonStr =
          await rootBundle.loadString(AppConstants.songsJsonPath);
      final songs = Song.listFromJson(jsonStr);

      // Load persisted favourites and recents
      final prefs = await SharedPreferences.getInstance();
      final savedFavs =
          prefs.getStringList(AppConstants.prefKeyFavorites) ?? [];
      final savedRecents =
          prefs.getStringList('recent_songs') ?? [];

      _allSongs = songs;
      _filteredSongs = List.from(songs);
      _favoriteIds = Set.from(savedFavs);
      _recentSongIds =
          savedRecents.where((id) => songs.any((s) => s.id == id)).toList();
      _status = SongLoadStatus.loaded;
    } catch (e) {
      _status = SongLoadStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Adds a song to the user's recently opened songs history list.
  Future<void> addToRecent(Song song) async {
    _recentSongIds.remove(song.id);
    _recentSongIds.insert(0, song.id);
    if (_recentSongIds.length > 20) {
      _recentSongIds = _recentSongIds.sublist(0, 20);
    }
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_songs', _recentSongIds);
    } catch (_) {}
  }

  /// Toggles the favourite state for a song with the given [id].
  /// Persists the updated set to [SharedPreferences].
  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppConstants.prefKeyFavorites,
      _favoriteIds.toList(),
    );
  }

  /// Filters the song list by [query] supporting:
  /// 1. Direct Song Number Match (matching song.id or index number)
  /// 2. Native Amharic Match (matching title, composer, category, lyrics)
  /// 3. Latin/English Phonetic Transliteration Match (e.g. "yegeta" -> "የጌታ")
  void searchSongs(String query) {
    _searchQuery = query.trim();
    if (_searchQuery.isEmpty) {
      _filteredSongs = List.from(_allSongs);
    } else {
      final lowerQuery = _searchQuery.toLowerCase();

      _filteredSongs = _allSongs.where((song) {
        // 1. Numeric Match (match ID or numeric index)
        if (song.id == lowerQuery || song.id.endsWith(lowerQuery)) {
          return true;
        }

        // 2. Native Amharic & standard text match
        if (song.title.toLowerCase().contains(lowerQuery) ||
            song.composer.toLowerCase().contains(lowerQuery) ||
            song.category.toLowerCase().contains(lowerQuery) ||
            song.lyrics.toLowerCase().contains(lowerQuery)) {
          return true;
        }

        // 3. Latin / English Phonetic Transliteration Match
        final titlePhonetic = _toLatinPhonetic(song.title);
        final composerPhonetic = _toLatinPhonetic(song.composer);
        final categoryPhonetic = _toLatinPhonetic(song.category);

        if (titlePhonetic.contains(lowerQuery) ||
            composerPhonetic.contains(lowerQuery) ||
            categoryPhonetic.contains(lowerQuery)) {
          return true;
        }

        return false;
      }).toList();
    }
    notifyListeners();
  }

  /// Clears the active search and resets to the full song list.
  void clearSearch() => searchSongs('');

  /// Converts Amharic Fidel script to Latin/English phonetic equivalents.
  String _toLatinPhonetic(String text) {
    if (text.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      buffer.write(_amharicToLatinMap[char] ?? char);
    }
    return buffer.toString().toLowerCase();
  }

  static const Map<String, String> _amharicToLatinMap = {
    // ሀ series
    'ሀ': 'ha', 'ሁ': 'hu', 'ሂ': 'hi', 'ሃ': 'ha', 'ሄ': 'he', 'ህ': 'h', 'ሆ': 'ho',
    // ለ series
    'ለ': 'le', 'ሉ': 'lu', 'ሊ': 'li', 'ላ': 'la', 'ሌ': 'le', 'ል': 'l', 'ሎ': 'lo',
    // ሐ series
    'ሐ': 'ha', 'ሑ': 'hu', 'ሒ': 'hi', 'ሓ': 'ha', 'ሔ': 'he', 'ሕ': 'h', 'ሖ': 'ho',
    // መ series
    'መ': 'me', 'ሙ': 'mu', 'ሚ': 'mi', 'ማ': 'ma', 'ሜ': 'me', 'ም': 'm', 'ሞ': 'mo',
    // ሠ series
    'ሠ': 'se', 'ሡ': 'su', 'ሢ': 'si', 'ሣ': 'sa', 'ሤ': 'se', 'ሥ': 's', 'ሦ': 'so',
    // ረ series
    'ረ': 're', 'ሩ': 'ru', 'ሪ': 'ri', 'ራ': 'ra', 'ሬ': 're', 'ር': 'r', 'ሮ': 'ro',
    // ሰ series
    'ሰ': 'se', 'ሱ': 'su', 'ሲ': 'si', 'ሳ': 'sa', 'ሴ': 'se', 'ስ': 's', 'ሶ': 'so',
    // ሸ series
    'ሸ': 'she', 'ሹ': 'shu', 'ሺ': 'shi', 'ሻ': 'sha', 'ሼ': 'she', 'ሽ': 'sh', 'ሾ': 'sho',
    // ቀ series
    'ቀ': 'ke', 'ቁ': 'ku', 'ቂ': 'ki', 'ቃ': 'ka', 'ቄ': 'ke', 'ቅ': 'k', 'ቆ': 'ko',
    // በ series
    'በ': 'be', 'ቡ': 'bu', 'ቢ': 'bi', 'ባ': 'ba', 'ቤ': 'be', 'ብ': 'b', 'ቦ': 'bo',
    // ተ series
    'ተ': 'te', 'ቱ': 'tu', 'ቲ': 'ti', 'ታ': 'ta', 'ቴ': 'te', 'ት': 't', 'ቶ': 'to',
    // ቸ series
    'ቸ': 'che', 'ቹ': 'chu', 'ቺ': 'chi', 'ቻ': 'cha', 'ቼ': 'che', 'ች': 'ch', 'ቾ': 'cho',
    // ኀ series
    'ኀ': 'ha', 'ኁ': 'hu', 'ኂ': 'hi', 'ኃ': 'ha', 'ኄ': 'he', 'ኅ': 'h', 'ኆ': 'ho',
    // ነ series
    'ነ': 'ne', 'ኑ': 'nu', 'ኒ': 'ni', 'ና': 'na', 'ኔ': 'ne', 'ን': 'n', 'ኖ': 'no',
    // ኘ series
    'ኘ': 'gne', 'ኙ': 'gnu', 'ኚ': 'gni', 'ኛ': 'gna', 'ኜ': 'gne', 'ኝ': 'gn', 'ኞ': 'gno',
    // አ series
    'አ': 'a', 'ኡ': 'u', 'ኢ': 'i', 'ኣ': 'a', 'ኤ': 'e', 'እ': 'e', 'ኦ': 'o',
    // ከ series
    'ከ': 'ke', 'ኩ': 'ku', 'ኪ': 'ki', 'ካ': 'ka', 'ኬ': 'ke', 'ክ': 'k', 'ኮ': 'ko',
    // ኸ series
    'ኸ': 'he', 'ኹ': 'hu', 'ኺ': 'hi', 'ኻ': 'ha', 'ኼ': 'he', 'ኽ': 'h', 'ኾ': 'ho',
    // ወ series
    'ወ': 'we', 'ዉ': 'wu', 'ዊ': 'wi', 'ዋ': 'wa', 'ዌ': 'we', 'ው': 'w', 'ዎ': 'wo',
    // ዐ series
    'ዐ': 'a', 'ዑ': 'u', 'ዒ': 'i', 'ዓ': 'a', 'ዔ': 'e', 'ዕ': 'e', 'ዖ': 'o',
    // ዘ series
    'ዘ': 'ze', 'ዙ': 'zu', 'ዚ': 'zi', 'ዛ': 'za', 'ዜ': 'ze', 'ዝ': 'z', 'ዞ': 'zo',
    // ዠ series
    'ዠ': 'zhe', 'ዡ': 'zhu', 'ዢ': 'zhi', 'ዣ': 'zha', 'ዤ': 'zhe', 'ዥ': 'zh', 'ዦ': 'zho',
    // የ series
    'የ': 'ye', 'ዩ': 'yu', 'ዪ': 'yi', 'ያ': 'ya', 'ዬ': 'ye', 'ይ': 'y', 'ዮ': 'yo',
    // ደ series
    'ደ': 'de', 'ዱ': 'du', 'ዲ': 'di', 'ዳ': 'da', 'ዴ': 'de', 'ድ': 'd', 'ዶ': 'do',
    // ጀ series
    'ጀ': 'je', 'ጁ': 'ju', 'ጂ': 'ji', 'ጃ': 'ja', 'ጄ': 'je', 'ጅ': 'j', 'ጆ': 'jo',
    // ገ series
    'ገ': 'ge', 'ጉ': 'gu', 'ጊ': 'gi', 'ጋ': 'ga', 'ጌ': 'ge', 'ግ': 'g', 'ጎ': 'go',
    // ጠ series
    'ጠ': 'te', 'ጡ': 'tu', 'ጢ': 'ti', 'ጣ': 'ta', 'ጤ': 'te', 'ጥ': 't', 'ጦ': 'to',
    // ጨ series
    'ጨ': 'che', 'ጩ': 'chu', 'ጪ': 'chi', 'ጫ': 'cha', 'ጬ': 'che', 'ጭ': 'ch', 'ጮ': 'cho',
    // ጰ series
    'ጰ': 'pe', 'ጱ': 'pu', 'ጲ': 'pi', 'ጳ': 'pa', 'ጴ': 'pe', 'ጵ': 'p', 'ጶ': 'po',
    // ጸ series
    'ጸ': 'tse', 'ጹ': 'tsu', 'ጺ': 'tsi', 'ጻ': 'tsa', 'ጼ': 'tse', 'ጽ': 'ts', 'ጾ': 'tso',
    // ፀ series
    'ፀ': 'tse', 'ፁ': 'tsu', 'ፂ': 'tsi', 'ፃ': 'tsa', 'ፄ': 'tse', 'ፅ': 'ts', 'ፆ': 'tso',
    // ፈ series
    'ፈ': 'fe', 'ፉ': 'fu', 'ፊ': 'fi', 'ፋ': 'fa', 'ፌ': 'fe', 'ፍ': 'f', 'ፎ': 'fo',
    // ፐ series
    'ፐ': 'pe', 'ፑ': 'pu', 'ፒ': 'pi', 'ፓ': 'pa', 'ፔ': 'pe', 'ፕ': 'p', 'ፖ': 'po',
  };

  // ─── JSON export helper (unused in UI but good for debugging) ─────────
  String exportFavoritesJson() {
    final favs = favoriteSongs;
    return jsonEncode(favs.map((s) => s.toJson()).toList());
  }
}
