import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rawg/features/auth/domain/entities/app_user.dart';
import 'package:rawg/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  ApiResult<AppUser> _toAppUserResult(ApiResult<User> result) => switch (result) {
    ApiSuccess(:final data) => ApiSuccess(_toAppUser(data)),
    ApiFailure(:final message) => ApiFailure(message),
  };

  AppUser _toAppUser(User user) => AppUser(email: user.email, id: user.id);

  @override
  AppUser? getCurrentUser() {
    final user = _remoteDataSource.getCurrentUser();
    return user == null ? null : _toAppUser(user);
  }

  @override
  Future<ApiResult<AppUser>> signIn({required String email, required String password}) async => _toAppUserResult(await _remoteDataSource.signIn(email: email, password: password));

  @override
  Future<ApiResult<void>> signOut() => _remoteDataSource.signOut();

  @override
  Future<ApiResult<AppUser>> signUp({required String email, required String name, required String password}) async => _toAppUserResult(await _remoteDataSource.signUp(email: email, name: name, password: password));
}
