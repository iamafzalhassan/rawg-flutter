import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rawg/core/constants/asset_constants.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/core/utils/show_snack_bar.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_app_bar.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_button.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_loader.dart';
import 'package:rawg/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:rawg/features/dashboard/presentation/widgets/game_card.dart';
import 'package:rawg/features/dashboard/presentation/widgets/game_card_skeleton.dart';
import 'package:rawg/features/dashboard/presentation/widgets/sort_chip.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const int _skeletonCards = 6;

  static const SliverGridDelegateWithFixedCrossAxisCount _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: AppSpacing.md,
    mainAxisExtent: AppSpacing.gameCardHeight,
    mainAxisSpacing: AppSpacing.md,
  );

  Widget _buildGames(BuildContext context, DashboardState state) {
    if (state.isLoading) {
      return CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) => const GameCardSkeleton(), childCount: _skeletonCards),
            gridDelegate: _gridDelegate,
          ),
        ],
      );
    }
    if (state.shouldShowError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage!,
              style: AppFont.style(color: AppPalette.gray1, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            RawgButton(label: 'dashboard.retry'.tr(), onPressed: context.read<DashboardCubit>().getGames),
          ],
        ),
      );
    }
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) => GameCard(state.games[index]), childCount: state.games.length),
          gridDelegate: _gridDelegate,
        ),
        if (state.shouldShowLoadMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: RawgButton(label: 'dashboard.loadMore'.tr(), onPressed: () => context.read<DashboardCubit>().getGames(loadMore: true)),
            ),
          ),
        if (state.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: Center(child: RawgLoader()),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<DashboardCubit, DashboardState>(
    listener: (context, state) => showSnackBar(context, state.errorMessage!),
    listenWhen: (previous, current) => current.errorMessage != null && current.hasGames && previous.errorMessage != current.errorMessage,
    builder: (context, state) => Scaffold(
      appBar: const RawgAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: TextField(
                cursorColor: AppPalette.white,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(AppSpacing.lg),
                  fillColor: AppPalette.gray4,
                  filled: true,
                  hintStyle: AppFont.style(color: AppPalette.gray1, fontSize: 18),
                  hintText: 'dashboard.searchHint'.tr(),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Image.asset(AssetConstants.searchIcon, width: AppSpacing.iconMd),
                  ),
                ),
                onChanged: context.read<DashboardCubit>().onSearchChanged,
                style: AppFont.style(fontSize: 18),
              ),
            ),
            Semantics(header: true, child: Text('dashboard.title'.tr(), style: AppFont.style(fontSize: 30))),
            Text('dashboard.subtitle'.tr(), style: AppFont.style(fontSize: 15)),
            const SizedBox(height: AppSpacing.xxl),
            SortChip(isLoading: state.isFiltering, value: state.platform?.name ?? 'dashboard.platforms'.tr()),
            const SizedBox(height: AppSpacing.xxl),
            Expanded(child: _buildGames(context, state)),
          ],
        ),
      ),
    ),
  );
}
