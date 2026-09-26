import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rawg/core/constants/asset_constants.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_button.dart';
import 'package:rawg/features/dashboard/domain/entities/game.dart';
import 'package:rawg/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:rawg/features/dashboard/presentation/widgets/game_overview_value_card.dart';

class GameOverviewPage extends StatelessWidget {
  const GameOverviewPage(this.game, {super.key});

  final Game game;

  Widget _buildPair(Widget first, Widget second) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      first,
      const SizedBox(width: AppSpacing.xl),
      second,
    ],
  );

  Widget _buildStoreChip(String icon, String label) => Container(
    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)), color: AppPalette.gray6),
    height: AppSpacing.chipHeight,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon, width: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.xs),
        RichText(
          text: TextSpan(
            style: AppFont.style(color: AppPalette.gray1, fontSize: 12),
            text: label,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final overview = context.select((DashboardCubit cubit) => cubit.state.selectedGame!);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(fit: BoxFit.cover, height: size.height / AppSpacing.heroImageRatio, imageUrl: AssetConstants.placeholderImageUrl, width: size.width),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(game.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFont.style(fontSize: 30)),
                                Text('gameOverview.averagePlaytime'.tr(args: ['${game.playtime}']), style: AppFont.style()),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Image.asset(AssetConstants.psIcon, width: AppSpacing.iconMd),
                          const SizedBox(width: AppSpacing.md),
                          Image.asset(AssetConstants.xboxIcon, width: AppSpacing.iconMd),
                          const SizedBox(width: AppSpacing.md),
                          Image.asset(AssetConstants.windowsIcon, width: AppSpacing.iconMd),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildPair(
                        GameOverviewValueCard('gameOverview.platforms'.tr(), value: game.platformNames),
                        GameOverviewValueCard(
                          'gameOverview.metascores'.tr(),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppPalette.green1),
                              borderRadius: const BorderRadius.all(Radius.circular(AppRadius.xs)),
                            ),
                            height: AppSpacing.scoreBoxSize,
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            width: AppSpacing.scoreBoxSize,
                            child: Text(
                              '${overview.metacritic ?? 0}',
                              style: AppFont.style(color: AppPalette.green1, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildPair(GameOverviewValueCard('gameOverview.genre'.tr(), value: game.genreNames), GameOverviewValueCard('gameOverview.releaseDate'.tr(), value: game.releaseDate)),
                      const SizedBox(height: AppSpacing.md),
                      _buildPair(
                        GameOverviewValueCard('gameOverview.website'.tr(), value: (overview.website ?? '').replaceFirst(RegExp(r'https?://'), '')),
                        GameOverviewValueCard('gameOverview.publisher'.tr(), value: overview.publisherNames),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GameOverviewValueCard('gameOverview.about'.tr(), value: overview.shortDescription, width: size.width),
                      const SizedBox(height: AppSpacing.md),
                      Text('gameOverview.availableStores'.tr(), style: AppFont.style(color: AppPalette.gray2, fontSize: 12)),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          _buildStoreChip(AssetConstants.steamIcon, 'stores.steam'.tr()),
                          const SizedBox(width: AppSpacing.xs),
                          _buildStoreChip(AssetConstants.epicStoresIcon, 'stores.epicGames'.tr()),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      RawgButton(icon: AssetConstants.giftIcon, label: 'gameOverview.addToWishlist'.tr(), onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.sm,
            top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
            child: Tooltip(
              message: MaterialLocalizations.of(context).backButtonTooltip,
              child: MaterialButton(
                color: AppPalette.black.withValues(alpha: 0.5),
                height: AppSpacing.minTouchTarget,
                minWidth: AppSpacing.minTouchTarget,
                onPressed: () => context.pop(),
                padding: const EdgeInsets.all(AppSpacing.backButtonPadding),
                shape: const CircleBorder(),
                child: Image.asset(AssetConstants.leftArrowIcon, height: AppSpacing.iconMd, width: AppSpacing.iconMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
