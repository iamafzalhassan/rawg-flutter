import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/auth/domain/entities/app_user.dart';
import 'package:rawg/features/auth/domain/repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<ApiResult<AppUser>> call({required String email, required String password}) => _authRepository.signIn(email: email, password: password);
}
