// lib/bloc/auth/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luxe_loft/bloc/auth/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late final Stream<User?> _userStream;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    _userStream = authRepository.user;
    _userStream.listen((user) {
      if (user != null) {
        add(AppStarted());
      } else {
        add(SignOutRequested());
      }
    });

    on<AppStarted>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<EmailSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signInWithEmailAndPassword(
            event.email, event.password);
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<EmailSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUpWithEmailAndPassword(
          name: event.name,
          email: event.email,
          password: event.password,
          phoneNumber: event.phoneNumber,
        );
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<PasswordResetRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.resetPassword(event.email);
        emit(PasswordResetEmailSent(event.email));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    });
  }
}
