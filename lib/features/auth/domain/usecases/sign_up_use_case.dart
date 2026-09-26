import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/auth/domain/entities/app_user.dart';
import 'package:rawg/features/auth/domain/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<ApiResult<AppUser>> call({required String email, required String name, required String password}) => _authRepository.signUp(email: email, name: name, password: password);
}
