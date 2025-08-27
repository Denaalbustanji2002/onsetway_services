import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthIdle extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final String email;
  final String role;
  const AuthSuccess(this.token, this.email, this.role);
  @override
  List<Object?> get props => [token, email, role];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthActionOk extends AuthState {
  final String message; // e.g., signup/forgot responses
  const AuthActionOk(this.message);
  @override
  List<Object?> get props => [message];
}
