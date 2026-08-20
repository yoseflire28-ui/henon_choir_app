import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/song_provider.dart';
import 'providers/navigation_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialised before any async work.
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for a consistent mobile experience.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialise providers before running the app so that the first frame
  // already has the correct persisted values.
  final themeProvider = ThemeProvider();
  final songProvider = SongProvider();

  await themeProvider.init();
  await songProvider.loadSongs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<SongProvider>.value(value: songProvider),
        ChangeNotifierProvider<NavigationProvider>(create: (_) => NavigationProvider()),
      ],
      child: const YehenonChoirApp(),
    ),
  );
}

/// Root widget of the Yehenon Choir Mezmur Debter application.
class YehenonChoirApp extends StatelessWidget {
  const YehenonChoirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Yehenon Choir YeMezmur Debter',
          debugShowCheckedModeBanner: false,

          // Themes
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,

          // Scroll behaviour — keeps momentum on all platforms.
          scrollBehavior: const _AppScrollBehavior(),

          // Entry point
          home: const SplashScreen(),
        );
      },
    );
  }
}

/// Custom scroll behaviour that preserves overscroll glow on Android
/// while keeping bouncing scroll physics feel on iOS.
class _AppScrollBehavior extends ScrollBehavior {
  const _AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Use a stretch overscroll effect on Android for a premium feel.
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      child: child,
    );
  }
}
