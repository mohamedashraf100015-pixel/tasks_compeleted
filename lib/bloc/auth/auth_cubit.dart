import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _auth = FirebaseAuth.instance;
  bool _googleInitialized = false;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await cred.user?.updateDisplayName(name.trim());
      emit(AuthSuccess(message: 'Account created successfully!'));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      emit(AuthSuccess(message: 'Reset link sent! Check your inbox.'));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      if (!_googleInitialized) {
        // v7 initialization
        await GoogleSignIn.instance.initialize();
        _googleInitialized = true;
      }

      final googleUser = await GoogleSignIn.instance.authenticate();
      final auth = googleUser.authentication;

      if (auth.idToken == null) {
        emit(AuthError('Google Sign-In failed: missing ID token.'));
        return;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );

      await _auth.signInWithCredential(credential);
      emit(AuthSuccess());
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled || 
          e.code == GoogleSignInExceptionCode.interrupted) {
        emit(AuthInitial());
      } else {
        emit(AuthError('Google Sign-In failed: ${e.code}'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e.code)));
    } catch (e) {
      emit(AuthError('Google Sign-In error: ${e.toString()}'));
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try later.';
      case 'network-request-failed':
        return 'Check your internet connection.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Something went wrong ($code). Please try again.';
    }
  }
}