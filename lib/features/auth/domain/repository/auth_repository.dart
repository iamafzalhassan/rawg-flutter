import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRepository {
  Future<ApiResult<AppUser>> signUp({required String email, required String name, required String password});

  Future<ApiResult<AppUser>> signIn({required String email, required String password});

  Future<ApiResult<void>> signOut();

  AppUser? getCurrentUser();
}
