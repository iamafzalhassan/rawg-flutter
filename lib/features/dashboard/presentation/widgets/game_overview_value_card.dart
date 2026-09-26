import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';

class GameOverviewValueCard extends StatelessWidget {
  const GameOverviewValueCard(this.label, {super.key, this.width, this.value, this.child});

  final double? width;

  final String label;
  final String? value;

  final Widget? child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppFont.style(color: AppPalette.gray2, fontSize: 12)),
      const SizedBox(height: AppSpacing.xxs),
      ?child,
      if (value != null)
        SizedBox(
          width: width ?? (MediaQuery.sizeOf(context).width - AppSpacing.lg * 2) / 2 - AppSpacing.xl / 2,
          child: Text(value!, style: AppFont.style(fontSize: 12)),
        ),
    ],
  );
}
