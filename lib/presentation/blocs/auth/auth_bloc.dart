import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuth extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class SignInWithEmail extends AuthEvent {
  final String email, password;
  const SignInWithEmail(this.email, this.password);
  @override
  List<Object?> get props => [email];
}

class RegisterWithEmail extends AuthEvent {
  final String email, password;
  const RegisterWithEmail(this.email, this.password);
  @override
  List<Object?> get props => [email];
}

class SignOut extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user.uid];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;
  final GoogleSignIn _google;

  AuthBloc({FirebaseAuth? auth, GoogleSignIn? google})
      : _auth = auth ?? FirebaseAuth.instance,
        _google = google ?? GoogleSignIn(),
        super(AuthInitial()) {
    on<CheckAuth>(_onCheck);
    on<SignInWithGoogle>(_onGoogle);
    on<SignInWithEmail>(_onEmail);
    on<RegisterWithEmail>(_onRegister);
    on<SignOut>(_onSignOut);
  }

  Future<void> _onCheck(CheckAuth e, Emitter<AuthState> emit) async {
    final user = _auth.currentUser;
    emit(user != null ? Authenticated(user) : Unauthenticated());
  }

  Future<void> _onGoogle(SignInWithGoogle e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final account = await _google.signIn();
      if (account == null) {
        emit(Unauthenticated());
        return;
      }
      final gAuth = await account.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final result = await _auth.signInWithCredential(cred);
      emit(Authenticated(result.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onEmail(SignInWithEmail e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: e.email,
        password: e.password,
      );
      emit(Authenticated(result.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Sign in failed'));
    }
  }

  Future<void> _onRegister(RegisterWithEmail e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: e.email,
        password: e.password,
      );
      emit(Authenticated(result.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Registration failed'));
    }
  }

  Future<void> _onSignOut(SignOut e, Emitter<AuthState> emit) async {
    await _google.signOut();
    await _auth.signOut();
    emit(Unauthenticated());
  }
}
