import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/song_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/song_tile.dart';

/// Displays the full catalogue of songs with a real-time search bar.
class AllSongsScreen extends StatelessWidget {
  const AllSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AllSongsContent();
  }
}

class _AllSongsContent extends StatefulWidget {
  const _AllSongsContent();

  @override
  State<_AllSongsContent> createState() => _AllSongsContentState();
}

class _AllSongsContentState extends State<_AllSongsContent> {
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
          AppConstants.navAllSongs,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: AppConstants.fontXl,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spacingMd,
              0,
              AppConstants.spacingMd,
              AppConstants.spacingMd,
            ),
            child: SearchBarWidget(
              hintText: 'Search songs...',
              onChanged: (q) =>
                  context.read<SongProvider>().searchSongs(q),
              onClear: () =>
                  context.read<SongProvider>().clearSearch(),
            ),
          ),
        ),
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

          if (songProvider.hasError) {
            return _buildError(context, songProvider.errorMessage);
          }

          final songs = songProvider.filteredSongs;

          if (songs.isEmpty) {
            return _buildEmptySearch(context);
          }

          return Column(
            children: [
              // Result count strip
              Container(
                width: double.infinity,
                color: isDark
                    ? AppConstants.darkBackground
                    : AppConstants.lightBackground,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                child: Text(
                  '${songs.length} song${songs.length == 1 ? '' : 's'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppConstants.darkTextSecondary
                        : AppConstants.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Song list
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacingSm,
                    bottom: AppConstants.spacingXl,
                  ),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return SongTile(
                      song: songs[index],
                      index: index + 1,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptySearch(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 72,
            color: AppConstants.accentCrimson.withValues(alpha: 0.35),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Try searching by title, composer, or category',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: AppConstants.accentCrimson,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Failed to load songs',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppConstants.spacingLg),
          ElevatedButton.icon(
            onPressed: () => context.read<SongProvider>().loadSongs(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.accentCrimson,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusFull),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
