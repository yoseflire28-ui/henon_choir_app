import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/song_model.dart';
import '../providers/song_provider.dart';
import '../screens/song_detail_screen.dart';

/// A list-row tile representing a single [Song].
///
/// Displays an index badge, the song title, composer, a category chip,
/// and an animated heart-favourite button. Tapping the tile navigates
/// to [SongDetailScreen].
class SongTile extends StatelessWidget {
  final Song song;

  /// 1-based display index shown as a badge on the left.
  final int index;

  /// Whether to show a leading index badge. Defaults to true.
  final bool showIndex;

  const SongTile({
    super.key,
    required this.song,
    required this.index,
    this.showIndex = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<SongProvider>(
      builder: (context, songProvider, _) {
        final isFav = songProvider.isFavorite(song.id);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            onTap: () => _navigateToDetail(context),
            splashColor: AppConstants.accentCrimson.withValues(alpha: 0.08),
            highlightColor: AppConstants.accentCrimson.withValues(alpha: 0.04),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingXs,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingSm + 2,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppConstants.darkCardColor
                    : AppConstants.lightCardColor,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusLg),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  // ── Index Badge ──────────────────────────────────────
                  if (showIndex) ...[
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppConstants.accentCrimson.withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: Text(
                        '$index',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppConstants.accentCrimson,
                          fontWeight: FontWeight.w700,
                          fontSize: AppConstants.fontSm,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                  ],

                  // ── Title & Composer ─────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: AppConstants.fontMd,
                            color: isDark
                                ? AppConstants.darkTextPrimary
                                : AppConstants.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          song.lyricsSnippet,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppConstants.darkTextSecondary
                                : AppConstants.lightTextSecondary,
                            fontSize: AppConstants.fontXs + 1,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Category chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                AppConstants.accentCrimson.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusFull),
                          ),
                          child: Text(
                            song.category,
                            style: const TextStyle(
                              fontSize: AppConstants.fontXs,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.accentCrimson,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Favourite Button ─────────────────────────────────
                  _FavoriteButton(
                    isFavorite: isFav,
                    onTap: () => songProvider.toggleFavorite(song.id),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SongDetailScreen(song: song),
      ),
    );
  }
}

/// Animated heart icon button for toggling song favourites.
class _FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
  });

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.reverse().then((_) => _controller.forward());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingSm),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedSwitcher(
            duration: AppConstants.animFast,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              widget.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              key: ValueKey(widget.isFavorite),
              color: widget.isFavorite
                  ? AppConstants.accentCrimson
                  : AppConstants.lightTextSecondary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
