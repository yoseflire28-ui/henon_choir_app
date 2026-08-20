import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/song_provider.dart';
import '../widgets/song_tile.dart';

/// Displays only songs the user has marked as favourites.
/// Shows an informative empty state when the list is empty.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppConstants.darkSurface
            : AppConstants.lightSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          AppConstants.navFavorites,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: AppConstants.fontXl,
          ),
        ),
        actions: [
          Consumer<SongProvider>(
            builder: (context, sp, child) {
              if (sp.favoriteSongs.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(right: AppConstants.spacingMd),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConstants.accentCrimson.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Text(
                      '${sp.favoriteSongs.length}',
                      style: const TextStyle(
                        color: AppConstants.accentCrimson,
                        fontWeight: FontWeight.w700,
                        fontSize: AppConstants.fontSm,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<SongProvider>(
        builder: (context, songProvider, _) {
          if (songProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.accentCrimson,
              ),
            );
          }

          final favorites = songProvider.favoriteSongs;

          if (favorites.isEmpty) {
            return const _EmptyFavoritesState();
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: AppConstants.spacingMd,
              bottom: AppConstants.spacingXl,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return SongTile(
                song: favorites[index],
                index: index + 1,
              );
            },
          );
        },
      ),
    );
  }
}

/// Shown when the user has no favourited songs yet.
class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.accentCrimson.withValues(alpha: 0.08),
                border: Border.all(
                  color: AppConstants.accentCrimson.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 48,
                color: AppConstants.accentCrimson.withValues(alpha: 0.5),
              ),
            ),

            const SizedBox(height: AppConstants.spacingLg),

            Text(
              'No Favorites Yet',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacingMd),

            Text(
              'Tap the ♡ heart icon on any song to save it here for quick access.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppConstants.darkTextSecondary
                    : AppConstants.lightTextSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacingXl),

            // Decorative hint row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_note_rounded,
                  size: 14,
                  color: AppConstants.accentCrimson.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  'Browse All Songs to get started',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppConstants.accentCrimson.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
