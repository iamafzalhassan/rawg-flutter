import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';

void showSheet(BuildContext context, Widget child) => showModalBottomSheet(
  backgroundColor: AppPalette.gray6,
  builder: (context) => SafeArea(
    top: false,
    child: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          ExcludeSemantics(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.xs), color: AppPalette.gray2),
              height: AppSpacing.sheetHandleHeight,
              width: AppSpacing.sheetHandleWidth,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Flexible(child: SingleChildScrollView(child: child)),
        ],
      ),
    ),
  ),
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
  useSafeArea: true,
);
