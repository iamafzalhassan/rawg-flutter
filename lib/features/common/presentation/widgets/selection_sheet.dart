import 'package:flutter/material.dart';
import 'package:rawg/core/constants/asset_constants.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';

typedef SelectionOption = ({String label, VoidCallback onTap, bool isSelected});

class SelectionSheet extends StatelessWidget {
  const SelectionSheet({super.key, required this.title, required this.options});

  final String title;

  final List<SelectionOption> options;

  Widget _buildOption(SelectionOption option, bool isLast) => Semantics(
    button: true,
    inMutuallyExclusiveGroup: true,
    selected: option.isSelected,
    child: InkWell(
      onTap: option.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
              child: Row(
                children: [
                  Expanded(
                    child: Text(option.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFont.style(fontSize: 18)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    decoration: BoxDecoration(
                      border: option.isSelected ? null : Border.all(color: AppPalette.gray2),
                      color: option.isSelected ? AppPalette.green1 : null,
                      shape: BoxShape.circle,
                    ),
                    height: AppSpacing.iconMd,
                    padding: const EdgeInsets.all(AppSpacing.xxs),
                    width: AppSpacing.iconMd,
                    child: option.isSelected ? Image.asset(AssetConstants.tickIcon) : null,
                  ),
                ],
              ),
            ),
            if (!isLast)
              ExcludeSemantics(
                child: LayoutBuilder(
                  builder: (context, constraints) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.filled(
                      (constraints.maxWidth / AppSpacing.dashPitch).floor(),
                      const SizedBox(
                        height: AppSpacing.hairline,
                        width: AppSpacing.dashWidth,
                        child: ColoredBox(color: AppPalette.gray3),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Semantics(
          header: true,
          child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFont.style(fontSize: 25)),
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      for (final (index, option) in options.indexed) _buildOption(option, index == options.length - 1),
      const SizedBox(height: AppSpacing.lg),
    ],
  );
}
