import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found':AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'email-already-in-use':AuthErrorEmailAlreadyInUse(),
  'operation-not-allowed':AuthErrorOperationNotAllowed(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user':AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText});

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown() : super (
      dialogText: 'Authentication  error',
      dialogTitle: 'Unknown authentication error');
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser() : super (
      dialogText: 'No current user ',
      dialogTitle: 'No user was found with this data');
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin() : super (
      dialogText: 'Required  Reent Login ',
      dialogTitle: 'Log back again');
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed() : super (
      dialogText: 'Operation not allowed ',
      dialogTitle: 'You cannot register using this method at this moment');
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound() : super (
      dialogText: 'User not found ',
      dialogTitle: 'given user not found on server');

}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
    dialogTitle: 'Weak password',
    dialogText:
    'Please choose a stronger password consisting of more characters!',
  );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
    dialogTitle: 'Invalid email',
    dialogText: 'Please double check your email and try again',
  );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
    dialogTitle: 'email already in use',
    dialogText: 'Please choose another email',
  );
}