import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_loader.dart';

class RawgButton extends StatelessWidget {
  const RawgButton({super.key, this.isLoading = false, required this.label, this.icon, this.backgroundColor, this.textColor, required this.onPressed});

  final bool isLoading;

  final String label;
  final String? icon;

  final Color? backgroundColor;
  final Color? textColor;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: AppSpacing.buttonHeight,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppPalette.gray6,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      child: isLoading
          ? RawgLoader(color: textColor ?? AppPalette.white, radius: AppSpacing.loaderLg)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[Image.asset(icon!, width: AppSpacing.iconMd), const SizedBox(width: AppSpacing.sm)],
                Text(
                  label,
                  style: AppFont.style(color: textColor ?? AppPalette.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
    ),
  );
}
