import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import 'main_nav_screen.dart';

/// Pixel-perfect, edge-to-edge full-screen SplashScreen widget.
///
/// Displays [assets/images/splash_screen.webp] in an immersive edge-to-edge layout,
/// holds for 2.5 seconds, then safely restores system UI overlays and navigates
/// to [MainNavScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Enable immersive edge-to-edge sticky mode to hide system status/nav bars.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Launch 2.5 second navigation timer.
    _timer = Timer(const Duration(milliseconds: 2500), _navigateToMain);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _navigateToMain() async {
    if (!mounted) return;

    // Restore standard edge-to-edge system UI overlays before screen transition.
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (!mounted) return;

    // Transition to MainNavScreen with zero back-stack retention.
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkNavy,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppConstants.darkNavy,
        child: Image.asset(
          'assets/images/splash_screen.webp',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            // Fallback header view if asset load fails
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppConstants.accentCrimson.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppConstants.accentCrimson.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: AppConstants.accentCrimson,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                  const Text(
                    AppConstants.appDisplayName,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.accentCrimson,
                      letterSpacing: 4.0,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  const Text(
                    AppConstants.appNameAmharic,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
