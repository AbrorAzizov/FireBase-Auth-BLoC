import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {}

class AppEventUploadImage extends AppEvent {
  final String pathToImage;

  AppEventUploadImage({required this.pathToImage});
}

class AppEventDeleteAccount extends AppEvent {}

class AppEventLogout extends AppEvent {}

@immutable
class AppEventLoggIn extends AppEvent {
  final String email;
  final String password;

   AppEventLoggIn({required this.email, required this.password});
}

@immutable
class AppEventRegistration extends AppEvent {
  final String email;
  final String password;

   AppEventRegistration({required this.email, required this.password});
}

class AppEventInitialize extends AppEvent {}

class AppEventGoToLogin extends AppEvent{}

class AppEventGoToRegistration extends AppEvent{}