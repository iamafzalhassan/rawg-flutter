import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/auth/domain/repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<ApiResult<void>> call() => _authRepository.signOut();
}
