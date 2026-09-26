part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final bool isSignedOut;
  final bool notificationsEnabled;

  final String? errorMessage;

  const SettingsState({this.isLoading = false, this.isSignedOut = false, this.notificationsEnabled = true, this.errorMessage});

  SettingsState copyWith({bool? isLoading, bool? isSignedOut, bool? notificationsEnabled, String? errorMessage}) =>
      SettingsState(isLoading: isLoading ?? this.isLoading, isSignedOut: isSignedOut ?? this.isSignedOut, notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled, errorMessage: errorMessage);

  @override
  List<Object?> get props => [isLoading, isSignedOut, notificationsEnabled, errorMessage];
}
