import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rawg/core/configs/app_router.dart';
import 'package:rawg/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    key: ValueKey(context.locale.toString()),
    locale: context.locale,
    localizationsDelegates: context.localizationDelegates,
    routerConfig: AppRouter.router,
    supportedLocales: context.supportedLocales,
    theme: AppTheme.dark,
    title: 'appTitle'.tr(),
  );
}
