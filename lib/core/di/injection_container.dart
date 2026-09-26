import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rawg/core/network/api_request.dart';
import 'package:rawg/core/network/connection_checker.dart';
import 'package:rawg/core/secrets/app_secrets.dart';
import 'package:rawg/core/services/one_signal_service.dart';
import 'package:rawg/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rawg/features/auth/data/repository/auth_repository_impl.dart';
import 'package:rawg/features/auth/domain/repository/auth_repository.dart';
import 'package:rawg/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:rawg/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:rawg/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:rawg/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:rawg/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:rawg/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:rawg/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:rawg/features/dashboard/data/models/local/hive_game_overview_model.dart';
import 'package:rawg/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:rawg/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:rawg/features/dashboard/domain/usecases/get_game_overview_use_case.dart';
import 'package:rawg/features/dashboard/domain/usecases/get_games_use_case.dart';
import 'package:rawg/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:rawg/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HiveGameOverviewModelAdapter());
  await Supabase.initialize(anonKey: AppSecrets.supabaseAnonKey, url: AppSecrets.supabaseUrl);
  serviceLocator
    ..registerLazySingleton<SupabaseClient>(() => Supabase.instance.client)
    ..registerLazySingleton(OneSignalService.new)
    ..registerLazySingleton(ApiRequest.new)
    ..registerLazySingleton<ConnectionChecker>(() => ConnectionCheckerImpl(InternetConnection()))
    ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(serviceLocator()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(serviceLocator()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(serviceLocator()))
    ..registerLazySingleton(() => SignInUseCase(serviceLocator()))
    ..registerLazySingleton(() => SignOutUseCase(serviceLocator()))
    ..registerLazySingleton(() => SignUpUseCase(serviceLocator()))
    ..registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(serviceLocator()))
    ..registerLazySingleton<DashboardLocalDataSource>(DashboardLocalDataSourceImpl.new)
    ..registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerLazySingleton(() => GetGameOverviewUseCase(serviceLocator()))
    ..registerLazySingleton(() => GetGamesUseCase(serviceLocator()))
    ..registerFactory(() => AuthCubit(serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerFactory(() => DashboardCubit(serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerFactory(() => SettingsCubit(serviceLocator(), serviceLocator()));
}
