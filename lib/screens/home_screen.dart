import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/song_model.dart';
import '../providers/song_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/song_tile.dart';
import 'song_detail_screen.dart';

/// Home tab — entry point with search bar, featured grid, and recent grid.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeContent();
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
            return _ErrorState(message: songProvider.errorMessage);
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── SliverAppBar Header ─────────────────────────────────────
              SliverAppBar(
                expandedHeight: 155,
                floating: true,
                pinned: true,
                snap: false,
                backgroundColor: const Color(0xFF060515),
                elevation: 0,
                scrolledUnderElevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    color: const Color(0xFF060515),
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.spacingMd,
                      0,
                      AppConstants.spacingMd,
                      AppConstants.spacingSm,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HENON CHOIR Brand header directly above search bar
                        Text(
                          'HENON CHOIR',
                          style: GoogleFonts.cinzelDecorative(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.0,
                            color: const Color(0xFFC52828),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSm),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(75),
                  child: Container(
                    color: const Color(0xFF060515),
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.spacingMd,
                      0,
                      AppConstants.spacingMd,
                      AppConstants.spacingMd,
                    ),
                    child: SearchBarWidget(
                      hintText: 'Search songs...',
                      onChanged: (q) {
                        setState(() => _isSearching = q.isNotEmpty);
                        context.read<SongProvider>().searchSongs(q);
                      },
                      onClear: () {
                        setState(() => _isSearching = false);
                        context.read<SongProvider>().clearSearch();
                      },
                    ),
                  ),
                ),
              ),

              // ── Search results or home content ────────────────────────
              if (_isSearching)
                _SearchResultsSliver(
                  songs: songProvider.filteredSongs,
                )
              else ...[
                // ── 2. Featured Section (2x2 Light Cards Grid) ──────────
                const _SectionHeaderSliver(title: '⭐ Featured'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                  ),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppConstants.spacingMd,
                      crossAxisSpacing: AppConstants.spacingMd,
                      childAspectRatio: 1.45,
                    ),
                    itemCount: songProvider.featuredSongs.length,
                    itemBuilder: (context, i) {
                      return _LightFeaturedCard(
                        song: songProvider.featuredSongs[i],
                        index: i + 1,
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingLg)),

                // ── 3. Recent Section (2x2 Dark Cards Grid) ─────────────
                const _SectionHeaderSliver(title: '🕐 Recent', showSeeAll: true),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                  ),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppConstants.spacingMd,
                      crossAxisSpacing: AppConstants.spacingMd,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: songProvider.recentSongs.length,
                    itemBuilder: (context, i) {
                      return _DarkRecentCard(
                        song: songProvider.recentSongs[i],
                        index: i + 1,
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppConstants.spacingXl)),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Renders inline search results as a SliverList.
class _SearchResultsSliver extends StatelessWidget {
  final List<Song> songs;
  const _SearchResultsSliver({required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const SliverFillRemaining(
        child: _EmptySearchState(),
      );
    }

    return SliverList.builder(
      itemCount: songs.length,
      itemBuilder: (context, i) {
        return SongTile(song: songs[i], index: i + 1);
      },
    );
  }
}

class _SectionHeaderSliver extends StatelessWidget {
  final String title;
  final bool showSeeAll;

  const _SectionHeaderSliver({
    required this.title,
    this.showSeeAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.spacingMd,
          AppConstants.spacingLg,
          AppConstants.spacingMd,
          AppConstants.spacingMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
            if (showSeeAll)
              TextButton(
                onPressed: () {
                  Provider.of<NavigationProvider>(context, listen: false)
                      .setTab(1);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppConstants.accentCrimson,
                    fontWeight: FontWeight.w700,
                    fontSize: AppConstants.fontMd,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Task 2: Featured 2x2 Light Cards Grid (#FFFFFF background, purple badge #EDE7F6)
class _LightFeaturedCard extends StatelessWidget {
  final Song song;
  final int index;

  const _LightFeaturedCard({required this.song, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongDetailScreen(song: song),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row: light purple circular badge (#EDE7F6) with index & red music note
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#$index',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.accentCrimson,
                    ),
                  ),
                ),
                const Icon(
                  Icons.music_note_rounded,
                  color: AppConstants.accentCrimson,
                  size: 18,
                ),
              ],
            ),
            // Middle row: Amharic title in bold dark text + trailing chevron
            Row(
              children: [
                Expanded(
                  child: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF1E1E2C),
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black45,
                  size: 18,
                ),
              ],
            ),
            // Subtitle: Light grey metadata text (Composer / Category)
            Text(
              '${song.composer} / ${song.category}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Task 2: Recent 2x2 Dark Cards Grid (Deep Dark Navy #0D0B26)
class _DarkRecentCard extends StatelessWidget {
  final Song song;
  final int index;

  const _DarkRecentCard({required this.song, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SongProvider>().addToRecent(song);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SongDetailScreen(song: song),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF3A2E70),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row: white circular badge containing song index number and white music note icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '#$index',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  Icons.music_note,
                  color: Colors.white70,
                  size: 18,
                ),
              ],
            ),
            // Body: Amharic title in white text
            Text(
              song.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            // Light composer metadata
            Text(
              '${song.composer} / ${song.category}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppConstants.accentCrimson.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'No songs found',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Try searching by title, number, or English (e.g. yegeta)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.spacingLg),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<SongProvider>().loadSongs(),
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
      ),
    );
  }
}
