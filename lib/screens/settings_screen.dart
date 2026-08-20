import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants.dart';
import '../providers/theme_provider.dart';

/// Settings tab — theme toggle, legal links, share, and version info.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          AppConstants.navSettings,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: AppConstants.fontXl,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        children: [
          const SizedBox(height: AppConstants.spacingSm),

          // ── Appearance Card ──────────────────────────────────────────
          _SettingsCard(
            children: [
              const _CardHeader(
                icon: Icons.palette_outlined,
                label: 'Appearance',
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return Material(
                    color: Colors.transparent,
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd,
                      ),
                      title: Text(
                        'Dark Mode',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        themeProvider.isDarkMode
                            ? 'Currently using dark theme'
                            : 'Currently using light theme',
                        style: theme.textTheme.bodyMedium,
                      ),
                      secondary: AnimatedSwitcher(
                        duration: AppConstants.animMedium,
                        child: Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          key: ValueKey(themeProvider.isDarkMode),
                          color: AppConstants.accentCrimson,
                        ),
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleTheme(),
                      activeThumbColor: AppConstants.accentCrimson,
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // ── Policies & More Card ─────────────────────────────────────
          _SettingsCard(
            children: [
              const _CardHeader(
                icon: Icons.info_outline_rounded,
                label: 'Policies & More',
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () => _showInfoDialog(
                  context,
                  title: 'Privacy Policy',
                  content:
                      'Yehenon Choir Mezmur Debter does not collect, '
                      'store, or share any personal data. All song data '
                      'is stored locally on your device. Your favourites '
                      'and preferences are saved only in your local app '
                      'storage and are never transmitted to external servers.',
                ),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.info_rounded,
                label: 'About',
                onTap: () => _showInfoDialog(
                  context,
                  title: 'About Henon Choir Songbook',
                  content:
                      'Henon Choir Songbook (የሄኖን መዘምራን የመዝሙር ደብተር) is a '
                      'digital songbook for the Yehenon Choir community. '
                      'Browse, search, and favourite Amharic worship songs '
                      'anytime, anywhere — even offline.\n\n'
                      'Developer :YOSEF LIRE FOLLAMBO FOR THE HENON CHOIR HMYC',
                ),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.share_rounded,
                label: 'Share App',
                onTap: () => _shareApp(context),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // ── App Info Card ────────────────────────────────────────────
          const _SettingsCard(
            children: [
              _CardHeader(
                icon: Icons.apps_rounded,
                label: 'App Info',
              ),
              _InfoRow(label: 'App Name', value: 'Henon Choir Songbook'),
              _Divider(),
              _InfoRow(label: 'Version', value: '1.0.1'),
              _Divider(),
              _InfoRow(label: 'Platform', value: 'iOS & Android'),
            ],
          ),

          const SizedBox(height: AppConstants.spacingXl),

          // ── Footer ───────────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.music_note_rounded,
                  color: AppConstants.accentCrimson,
                  size: 24,
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  AppConstants.appVersion,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppConstants.darkTextSecondary
                        : AppConstants.lightTextSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingXl),
        ],
      ),
    );
  }

  void _showInfoDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark
            ? AppConstants.darkCardColor
            : AppConstants.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: AppConstants.fontLg,
          ),
        ),
        content: Text(
          content,
          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppConstants.accentCrimson,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareApp(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(
        text:
            '🎵 Henon Choir Songbook — የሄኖን መዘምራን የመዝሙር ደብተር\n\n'
            'Discover and sing along with beautiful Amharic worship songs. '
            'Download the app today!',
      ),
    );
  }
}

// ─── Reusable setting sub-widgets ─────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppConstants.darkCardColor : AppConstants.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CardHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingMd,
        AppConstants.spacingMd,
        AppConstants.spacingMd,
        AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppConstants.accentCrimson),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppConstants.fontXs,
              fontWeight: FontWeight.w700,
              color: AppConstants.accentCrimson,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingMd,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.accentCrimson.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(icon, size: 18, color: AppConstants.accentCrimson),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppConstants.darkTextSecondary
                    : AppConstants.lightTextSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppConstants.darkTextSecondary
                      : AppConstants.lightTextSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      thickness: 1,
      indent: AppConstants.spacingMd,
      endIndent: AppConstants.spacingMd,
      color: isDark ? AppConstants.darkDivider : AppConstants.lightDivider,
    );
  }
}
