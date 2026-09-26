import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/core/services/one_signal_service.dart';
import 'package:rawg/features/auth/domain/usecases/sign_out_use_case.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final OneSignalService _oneSignalService;

  final SignOutUseCase _signOutUseCase;

  SettingsCubit(this._oneSignalService, this._signOutUseCase) : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    emit(state.copyWith(notificationsEnabled: enabled));
    await _oneSignalService.setNotificationsEnabled(enabled);
  }

  Future<void> signOut() async {
    emit(state.copyWith(isLoading: true, isSignedOut: false));
    switch (await _signOutUseCase()) {
      case ApiSuccess():
        await _oneSignalService.removeExternalUserId();
        emit(state.copyWith(isLoading: false, isSignedOut: true));
      case ApiFailure(:final message):
        emit(state.copyWith(isLoading: false, errorMessage: message));
    }
  }

  Future<void> _loadSettings() async => emit(state.copyWith(notificationsEnabled: await _oneSignalService.getNotificationsEnabled()));
}
