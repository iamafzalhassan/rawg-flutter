import 'package:rawg/core/network/api_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<ApiResult<User>> signUp({required String email, required String name, required String password});

  Future<ApiResult<User>> signIn({required String email, required String password});

  Future<ApiResult<void>> signOut();

  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  Future<ApiResult<User>> _authenticate(Future<AuthResponse> Function() request, String failure) async {
    try {
      final user = (await request()).user;
      return user == null ? ApiFailure(failure) : ApiSuccess(user);
    } on AuthException catch (e) {
      return ApiFailure(e.message);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  @override
  User? getCurrentUser() => _supabaseClient.auth.currentUser;

  @override
  Future<ApiResult<User>> signIn({required String email, required String password}) => _authenticate(() => _supabaseClient.auth.signInWithPassword(email: email, password: password), 'Sign in failed. Please try again.');

  @override
  Future<ApiResult<void>> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      return const ApiSuccess(null);
    } on AuthException catch (e) {
      return ApiFailure(e.message);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  @override
  Future<ApiResult<User>> signUp({required String email, required String name, required String password}) =>
      _authenticate(() => _supabaseClient.auth.signUp(data: {'name': name}, email: email, password: password), 'Sign up failed. Please try again.');
}
