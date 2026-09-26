import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rawg/core/constants/asset_constants.dart';
import 'package:rawg/core/constants/sort_option_constants.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/core/utils/show_sheet.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_loader.dart';
import 'package:rawg/features/common/presentation/widgets/selection_sheet.dart';
import 'package:rawg/features/dashboard/presentation/cubits/dashboard_cubit.dart';

class SortChip extends StatelessWidget {
  const SortChip({super.key, required this.isLoading, required this.value});

  final bool isLoading;

  final String value;

  Widget _buildSheet(BuildContext context) {
    final cubit = context.watch<DashboardCubit>();
    return SelectionSheet(
      options: [
        for (final item in SortOptionConstants.platforms)
          (
            label: item.name,
            onTap: () {
              cubit.selectPlatform(item);
              Navigator.pop(context);
            },
            isSelected: cubit.state.platform?.id == item.id,
          ),
      ],
      title: 'dashboard.platforms'.tr(),
    );
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: Material(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      color: AppPalette.gray6,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
        onTap: isLoading ? null : () => showSheet(context, Builder(builder: _buildSheet)),
        child: Container(
          height: AppSpacing.minTouchTarget,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFont.style(fontSize: 15)),
              const SizedBox(width: AppSpacing.xs),
              if (isLoading) const RawgLoader(radius: AppSpacing.loaderSm) else ExcludeSemantics(child: Image.asset(AssetConstants.chevronIcon, width: AppSpacing.iconSm)),
            ],
          ),
        ),
      ),
    ),
  );
}
