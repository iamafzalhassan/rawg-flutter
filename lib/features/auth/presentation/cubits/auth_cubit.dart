import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/core/services/one_signal_service.dart';
import 'package:rawg/features/auth/domain/entities/app_user.dart';
import 'package:rawg/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:rawg/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:rawg/features/auth/domain/usecases/sign_up_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  final OneSignalService _oneSignalService;

  final SignInUseCase _signInUseCase;

  final SignUpUseCase _signUpUseCase;

  AuthCubit(this._getCurrentUserUseCase, this._oneSignalService, this._signInUseCase, this._signUpUseCase) : super(const AuthState());

  void checkCurrentUser() {
    final user = _getCurrentUserUseCase();
    if (user != null) _oneSignalService.setExternalUserId(user.id);
  }

  Future<void> signIn({required String email, required String password}) => _authenticate(() => _signInUseCase(email: email.trim(), password: password.trim()));

  Future<void> signUp({required String email, required String name, required String password}) => _authenticate(() => _signUpUseCase(email: email.trim(), name: name.trim(), password: password.trim()));

  Future<void> _authenticate(Future<ApiResult<AppUser>> Function() request) async {
    emit(const AuthState(isLoading: true));
    switch (await request()) {
      case ApiSuccess(:final data):
        await _oneSignalService.setExternalUserId(data.id);
        emit(const AuthState(isAuthenticated: true));
      case ApiFailure(:final message):
        emit(AuthState(errorMessage: message));
    }
  }
}
