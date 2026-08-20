import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/song_model.dart';
import '../providers/song_provider.dart';

/// Helper utility to format lyrics with proper vertical spacing between verses and choruses.
String formatLyrics(String rawLyrics) {
  return rawLyrics
      // Add double spacing before numbered verses (e.g., "1.", "2.", "3.")
      .replaceAll(RegExp(r'(\r?\n)(?=\d+\.)'), '\n\n')
      // Add spacing around repeated chorus placeholders (e.g., ".......")
      .replaceAll(RegExp(r'(\r?\n)(?=.*?\.{6,})'), '\n\n')
      // Add spacing before chorus/refrain indicators
      .replaceAll(RegExp(r'(\r?\n)(?=ምንም|ስለ|የሚለው|/*)'), '\n\n')
      .trim();
}

/// Full-screen song detail view with lyric display and font size controls.
class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  double _fontSize = AppConstants.defaultLyricFontSize;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SongProvider>().addToRecent(widget.song);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _increaseFontSize() {
    if (_fontSize < AppConstants.maxLyricFontSize) {
      setState(() => _fontSize += 2);
    }
  }

  void _decreaseFontSize() {
    if (_fontSize > AppConstants.minLyricFontSize) {
      setState(() => _fontSize -= 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<SongProvider>(
      builder: (context, songProvider, _) {
        final isFav = songProvider.isFavorite(widget.song.id);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: isDark
                ? AppConstants.darkSurface
                : AppConstants.lightSurface,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppConstants.fontMd,
                    color: isDark
                        ? AppConstants.darkTextPrimary
                        : AppConstants.lightTextPrimary,
                  ),
                ),
                Text(
                  '${widget.song.composer} • ${widget.song.category}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppConstants.fontXs,
                    color: isDark
                        ? AppConstants.darkTextSecondary
                        : AppConstants.lightTextSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              // Zoom Out action
              IconButton(
                icon: const Icon(Icons.zoom_out_rounded),
                onPressed: _fontSize > AppConstants.minLyricFontSize
                    ? _decreaseFontSize
                    : null,
                tooltip: 'Zoom Out',
              ),
              // Zoom In action
              IconButton(
                icon: const Icon(Icons.zoom_in_rounded),
                onPressed: _fontSize < AppConstants.maxLyricFontSize
                    ? _increaseFontSize
                    : null,
                tooltip: 'Zoom In',
              ),
              // Favourite toggle in app bar
              _AnimatedHeartButton(
                isFavorite: isFav,
                onTap: () => songProvider.toggleFavorite(widget.song.id),
              ),
              const SizedBox(width: AppConstants.spacingSm),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 160),
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        formatLyrics(widget.song.lyrics),
                        softWrap: true,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontFamily: 'NotoSansEthiopic',
                          fontSize: _fontSize,
                          height: 1.6,
                          color: isDark
                              ? AppConstants.darkTextPrimary
                              : AppConstants.lightTextPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Animated heart button used in the AppBar of [SongDetailScreen].
class _AnimatedHeartButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _AnimatedHeartButton({
    required this.isFavorite,
    required this.onTap,
  });

  @override
  State<_AnimatedHeartButton> createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<_AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.8,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    _ctrl.reverse().then((_) => _ctrl.forward());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
      child: IconButton(
        onPressed: _handleTap,
        icon: AnimatedSwitcher(
          duration: AppConstants.animFast,
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            widget.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            key: ValueKey(widget.isFavorite),
            color: widget.isFavorite
                ? AppConstants.accentCrimson
                : null,
          ),
        ),
      ),
    );
  }
}
