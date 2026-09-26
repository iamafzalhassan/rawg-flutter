part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;

  final String? errorMessage;

  const AuthState({this.isAuthenticated = false, this.isLoading = false, this.errorMessage});

  @override
  List<Object?> get props => [isAuthenticated, isLoading, errorMessage];
}
