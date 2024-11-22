// lib/bloc/auth/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AppStarted extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class EmailSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailSignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class EmailSignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const EmailSignUpRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [name, email, password, phoneNumber];
}

class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class SignOutRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}
