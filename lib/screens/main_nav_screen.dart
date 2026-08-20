import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/navigation_provider.dart';
import 'home_screen.dart';
import 'all_songs_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

/// Root scaffold housing the persistent bottom navigation bar and the
/// four top-level tab destinations: Home, All Songs, Favourites, Settings.
class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  // Keep each screen alive across tab switches using an IndexedStack.
  static const List<Widget> _screens = [
    HomeScreen(),
    AllSongsScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void _onTabTap(int index) {
    final navProvider = context.read<NavigationProvider>();
    if (navProvider.currentIndex == index) return;
    HapticFeedback.lightImpact();
    navProvider.setTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = context.watch<NavigationProvider>().currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppConstants.darkDivider
                  : AppConstants.lightDivider,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTabTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: AppConstants.navHome,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              activeIcon: Icon(Icons.library_music_rounded),
              label: AppConstants.navAllSongs,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: AppConstants.navFavorites,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: AppConstants.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
