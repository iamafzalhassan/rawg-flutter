import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rawg/core/constants/asset_constants.dart';
import 'package:rawg/core/constants/route_constants.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/core/utils/loading_overlay.dart';
import 'package:rawg/core/utils/show_snack_bar.dart';
import 'package:rawg/features/dashboard/domain/entities/game.dart';
import 'package:rawg/features/dashboard/presentation/cubits/dashboard_cubit.dart';

class GameCard extends StatelessWidget {
  const GameCard(this.game, {super.key});

  final Game game;

  Future<void> _openOverview(BuildContext context) async {
    final id = game.id;
    if (id == null) return;
    final cubit = context.read<DashboardCubit>();
    LoadingOverlay.show(context);
    await cubit.getGameOverview(id);
    if (!context.mounted) return;
    LoadingOverlay.hide(context);
    if (cubit.state.selectedGame != null) {
      context.pushNamed(RouteConstants.gameOverview, extra: game);
    } else if (cubit.state.errorMessage != null) {
      showSnackBar(context, cubit.state.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: MergeSemantics(
      child: Semantics(
        button: true,
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          color: AppPalette.black1,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
            onTap: () => _openOverview(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => Container(color: AppPalette.gray5, child: Image.asset(AssetConstants.imageBrokenIcon)),
                    fit: BoxFit.cover,
                    height: AppSpacing.gameCardImageHeight,
                    imageUrl: AssetConstants.placeholderImageUrl,
                    memCacheWidth: (MediaQuery.sizeOf(context).width - AppSpacing.lg * 2 - AppSpacing.md).toInt(),
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFont.style()),
                      Text(
                        game.releaseDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.style(color: AppPalette.gray1, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)), color: AppPalette.gray6),
                        height: AppSpacing.ratingBadgeHeight,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(AssetConstants.plusIcon, width: AppSpacing.iconXs),
                            const SizedBox(width: AppSpacing.xs),
                            Text(NumberFormat.decimalPattern().format(game.ratingsCount), style: AppFont.style(color: AppPalette.gray1, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Image.asset(AssetConstants.psIcon, width: AppSpacing.iconXs),
                      const SizedBox(width: AppSpacing.xs),
                      Image.asset(AssetConstants.xboxIcon, width: AppSpacing.iconXs),
                      const SizedBox(width: AppSpacing.xs),
                      Image.asset(AssetConstants.windowsIcon, width: AppSpacing.iconXs),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
