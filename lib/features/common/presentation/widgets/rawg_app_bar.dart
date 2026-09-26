import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rawg/core/constants/asset_constants.dart';
import 'package:rawg/core/constants/route_constants.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_spacing.dart';

class RawgAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RawgAppBar({super.key, this.title});

  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    actions: title == null
        ? [
            IconButton(
              icon: Image.asset(AssetConstants.settingIcon, width: AppSpacing.iconLg),
              onPressed: () => context.pushNamed(RouteConstants.settings),
              tooltip: 'settings.title'.tr(),
            ),
            const SizedBox(width: AppSpacing.xs),
          ]
        : null,
    automaticallyImplyLeading: false,
    centerTitle: true,
    leading: title == null
        ? null
        : IconButton(
            icon: Image.asset(AssetConstants.leftArrowIcon, width: AppSpacing.iconLg),
            onPressed: () => context.pop(),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          ),
    title: title == null ? Image.asset(AssetConstants.logoMinimal, semanticLabel: 'appTitle'.tr(), width: AppSpacing.logoWidth) : Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppFont.style(fontSize: 20)),
  );
}
