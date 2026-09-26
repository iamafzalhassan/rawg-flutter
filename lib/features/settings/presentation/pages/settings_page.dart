import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rawg/core/constants/locale_constants.dart';
import 'package:rawg/core/constants/route_constants.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/core/utils/show_sheet.dart';
import 'package:rawg/core/utils/show_snack_bar.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_app_bar.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_button.dart';
import 'package:rawg/features/common/presentation/widgets/selection_sheet.dart';
import 'package:rawg/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:rawg/features/settings/presentation/widgets/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildLanguageSheet(BuildContext context) => SelectionSheet(
    options: [for (final MapEntry(key: locale, value: name) in LocaleConstants.languages.entries) (label: name.tr(), onTap: () => _selectLanguage(context, locale), isSelected: context.locale == locale)],
    title: 'settings._selectLanguage'.tr(),
  );

  Future<void> _selectLanguage(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<SettingsCubit, SettingsState>(
    listener: (context, state) {
      if (state.errorMessage != null) showSnackBar(context, state.errorMessage!);
      if (state.isSignedOut) context.goNamed(RouteConstants.auth);
    },
    listenWhen: (previous, current) => previous.isSignedOut != current.isSignedOut || previous.errorMessage != current.errorMessage,
    builder: (context, state) => Scaffold(
      appBar: RawgAppBar(title: 'settings.title'.tr()),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            SettingsItem(
              'settings.language'.tr(),
              onTap: () => showSheet(context, Builder(builder: _buildLanguageSheet)),
              showDropDown: true,
              value: (LocaleConstants.languages[context.locale] ?? 'languages.english').tr(),
            ),
            const SizedBox(height: AppSpacing.md),
            SettingsItem('settings.notifications'.tr(), onToggleChanged: context.read<SettingsCubit>().setNotificationsEnabled, showToggle: true, toggleValue: state.notificationsEnabled),
            const SizedBox(height: AppSpacing.md),
            SettingsItem('settings.appVersion'.tr(), value: '1.0'),
            const Spacer(),
            RawgButton(backgroundColor: AppPalette.black1, isLoading: state.isLoading, label: 'settings.signOut'.tr(), onPressed: context.read<SettingsCubit>().signOut, textColor: AppPalette.red1),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    ),
  );
}
