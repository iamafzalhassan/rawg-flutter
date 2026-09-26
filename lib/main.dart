import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rawg/app.dart';
import 'package:rawg/core/configs/app_router.dart';
import 'package:rawg/core/constants/locale_constants.dart';
import 'package:rawg/core/di/injection_container.dart';
import 'package:rawg/core/services/one_signal_service.dart';
import 'package:rawg/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:rawg/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:rawg/features/settings/presentation/cubits/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initDependencies();
  serviceLocator<OneSignalService>().initialize(AppRouter.router);
  runApp(
    EasyLocalization(
      fallbackLocale: const Locale('en', 'US'),
      path: 'assets/locales',
      supportedLocales: LocaleConstants.languages.keys.toList(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => serviceLocator<AuthCubit>()..checkCurrentUser()),
          BlocProvider(create: (_) => serviceLocator<DashboardCubit>()),
          BlocProvider(create: (_) => serviceLocator<SettingsCubit>()),
        ],
        child: const App(),
      ),
    ),
  );
}
