import 'package:bloc_5/auth/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required super.isLoading,
    super.authError,
  });

  @override
  bool operator ==(Object other) {
    final secondClass = other;
    if (secondClass is AppStateLoggedIn) {
      return isLoading == secondClass.isLoading &&
          user.uid == secondClass.user.uid &&
          images.length == secondClass.images.length;
    } else {
      return false;
    }
  }

  // Couldnt Understand
  @override
  int get hashCode => Object.hash(
    isLoading,
    user.uid,


  );
}


class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({required super.isLoading, super.authError});
}

class AppStateRegistrationView extends AppState {
  const AppStateRegistrationView(
      {required super.isLoading,  super.authError});
}


extension GetUser on AppState {
  User? get user =>
      this is AppStateLoggedIn ? (this as AppStateLoggedIn).user : null;
}

extension GetImage on AppState {
  Iterable<Reference>? get images =>
      this is AppStateLoggedIn ? (this as AppStateLoggedIn).images : null;
}