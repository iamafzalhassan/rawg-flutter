import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_skeleton.dart';

class GameCardSkeleton extends StatelessWidget {
  const GameCardSkeleton({super.key});

  static const double _dateFactor = 0.4;
  static const double _nameFactor = 0.7;
  static const double _skeletonBadgeWidth = 56;
  static const double _skeletonPlatformsWidth = AppSpacing.iconXs * 3 + AppSpacing.xs * 2;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)), color: AppPalette.black1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
          child: RawgSkeleton(height: AppSpacing.gameCardImageHeight, radius: AppRadius.none, width: double.infinity),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FractionallySizedBox(
                widthFactor: _nameFactor,
                child: RawgSkeleton.text(textStyle: AppFont.style()),
              ),
              FractionallySizedBox(
                widthFactor: _dateFactor,
                child: RawgSkeleton.text(textStyle: AppFont.style(fontSize: 11)),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              RawgSkeleton(height: AppSpacing.ratingBadgeHeight, width: _skeletonBadgeWidth),
              Spacer(),
              RawgSkeleton(height: AppSpacing.iconXs, width: _skeletonPlatformsWidth),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
      ],
    ),
  );
}
