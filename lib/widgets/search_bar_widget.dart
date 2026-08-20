import 'package:flutter/material.dart';
import '../core/constants.dart';

/// A styled search bar widget with live-update callback.
///
/// Wraps a [TextField] inside a pill-shaped container that inherits
/// its fill colour from [Theme.of(context).inputDecorationTheme].
class SearchBarWidget extends StatefulWidget {
  /// Callback invoked on every keystroke with the current query string.
  final ValueChanged<String> onChanged;

  /// Optional initial value for the text field.
  final String initialValue;

  /// Hint text shown when the field is empty.
  final String hintText;

  /// Whether to auto-focus the field on appearance.
  final bool autofocus;

  /// Optional callback invoked when the user clears the search.
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    this.initialValue = '',
    this.hintText = 'Search songs...',
    this.autofocus = false,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: AppConstants.animMedium,
      decoration: BoxDecoration(
        color: isDark
            ? AppConstants.darkSearchBar
            : AppConstants.lightSearchBar,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontSize: AppConstants.fontMd,
        ),
        cursorColor: AppConstants.accentCrimson,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: isDark
                ? AppConstants.darkTextSecondary
                : AppConstants.lightTextSecondary,
            fontSize: AppConstants.fontMd,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              Icons.search_rounded,
              size: 20,
              color: AppConstants.accentCrimson,
            ),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 44, minHeight: 44),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: _handleClear,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppConstants.darkCardElevated
                        : AppConstants.lightDivider,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: isDark
                        ? AppConstants.darkTextSecondary
                        : AppConstants.lightTextSecondary,
                  ),
                ),
              );
            },
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: 14,
          ),
          filled: false,
        ),
      ),
    );
  }
}
