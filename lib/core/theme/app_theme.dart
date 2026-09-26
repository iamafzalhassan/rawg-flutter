import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';

abstract final class AppTheme {
  static final ThemeData dark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: AppPalette.black2, scrolledUnderElevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.gray6,
        elevation: 0,
        overlayColor: AppPalette.gray1,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        overlayColor: AppPalette.gray1,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
        side: const BorderSide(color: AppPalette.gray6, width: AppSpacing.xs),
        textStyle: AppFont.style(fontSize: 20),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(circularTrackColor: AppPalette.gray4, color: AppPalette.white),
    scaffoldBackgroundColor: AppPalette.black2,
  );
}
