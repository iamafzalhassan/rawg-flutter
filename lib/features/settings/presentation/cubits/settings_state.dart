part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final bool isSignedOut;
  final bool notificationsEnabled;

  final String? appVersion;
  final String? errorMessage;

  const SettingsState({this.isLoading = false, this.isSignedOut = false, this.notificationsEnabled = true, this.appVersion, this.errorMessage});

  SettingsState copyWith({bool? isLoading, bool? isSignedOut, bool? notificationsEnabled, String? appVersion, String? errorMessage}) => SettingsState(
    isLoading: isLoading ?? this.isLoading,
    isSignedOut: isSignedOut ?? this.isSignedOut,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    appVersion: appVersion ?? this.appVersion,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [isLoading, isSignedOut, notificationsEnabled, appVersion, errorMessage];
}
