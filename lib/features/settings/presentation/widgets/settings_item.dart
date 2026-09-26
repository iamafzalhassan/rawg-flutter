import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rawg/core/constants/asset_constants.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem(this.label, {super.key, this.showDropDown = false, this.showToggle = false, this.toggleValue = false, this.value, this.onToggleChanged, this.onTap});

  final bool showDropDown;
  final bool showToggle;
  final bool toggleValue;

  final String label;
  final String? value;

  final ValueChanged<bool>? onToggleChanged;

  final VoidCallback? onTap;

  VoidCallback? get _rowTap {
    final onToggleChanged = this.onToggleChanged;
    if (!showToggle) return onTap;
    return onToggleChanged == null ? null : () => onToggleChanged(!toggleValue);
  }

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Material(
      borderRadius: BorderRadius.circular(AppRadius.md),
      color: AppPalette.black1,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: _rowTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.settingsRowHeight),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.style(color: AppPalette.white, fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      if (value != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          value!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFont.style(color: AppPalette.gray1, fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showToggle) CupertinoSwitch(activeTrackColor: AppPalette.green1, inactiveThumbColor: AppPalette.gray1, inactiveTrackColor: AppPalette.gray4, onChanged: onToggleChanged, value: toggleValue),
                if (showDropDown) ExcludeSemantics(child: Image.asset(AssetConstants.chevronIcon, width: AppSpacing.iconMd)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
