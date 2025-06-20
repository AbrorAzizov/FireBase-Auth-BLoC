import 'dart:io';

import 'package:bloc_5/auth/auth_error.dart';
import 'package:bloc_5/bloc/auth_bloc/app_event.dart';
import 'package:bloc_5/bloc/auth_bloc/app_state.dart';
import 'package:bloc_5/utils/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppStateLoggedOut(isLoading: false)) {
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      final imagePath = File(event.pathToImage);
      if (user != null) {
        emit(AppStateLoggedIn(
            isLoading: true, user: user, images: state.images ?? []));
        await uploadImage(file: imagePath, userId: user.uid);
        final newImages = await getImages(user.uid);
        emit(AppStateLoggedIn(isLoading: false, user: user, images: newImages));
      } else {
        emit(AppStateLoggedOut(isLoading: false));
      }
    });

    on<AppEventInitialize>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(AppStateLoggedOut(isLoading: false));
        return;
      }
      final images = await getImages(user.uid);
      emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
    });

    on<AppEventLogout>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(AppStateLoggedOut(isLoading: false));
          return;
        }
        try {
          emit(AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ));
          await FirebaseAuth.instance.signOut();
          emit(AppStateLoggedOut(isLoading: false));
        } on FirebaseAuthException catch (e) {
          emit(AppStateLoggedIn(
              isLoading: false,
              images: state.images ?? [],
              authError: AuthError.from(e),
              user: user));
        }
      },
    );

    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AppStateLoggedOut(isLoading: false));
        return;
      }
      emit(AppStateLoggedIn(
          isLoading: true, user: user, images: state.images ?? []));

      try {
        final folder = await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final ref in folder.items) {
          await ref.delete();
        }
        await user.delete();

        await FirebaseAuth.instance.signOut();
        emit(AppStateLoggedOut(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: false,
            authError: AuthError.from(e)));
      } on FirebaseException {
        emit(AppStateLoggedOut(isLoading: false));
      }
    });

    on<AppEventRegistration>(
      (event, emit) async {
        final password = event.password;
        final email = event.email;
        try {
          emit(AppStateRegistrationView(
            isLoading: true,
          ));

          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          final user = credential.user;

          emit(AppStateLoggedIn(
            user: user!,
            images: const [],
            isLoading: false,
          ));
        } on FirebaseAuthException catch (e) {
          emit(AppStateRegistrationView(
              isLoading: false, authError: AuthError.from(e)));
        }
      },
    );
    on<AppEventGoToLogin>(
      (event, emit) {
        emit(AppStateLoggedOut(isLoading: false));
      },
    );

    on<AppEventLoggIn>(
      (event, emit) async {
        emit(AppStateLoggedOut(isLoading: true));
        final password = event.password;
        final email = event.email;
         try{
          final userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          final user = userCredential.user;
          if (user == null) {
            emit(const AppStateLoggedOut(isLoading: false));
            return;
          }
          final images =   await getImages(user.uid);



          emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
        } on FirebaseAuthException catch (e){
           emit(AppStateLoggedOut(isLoading: false,authError: AuthError.from(e)));
         }
      },
    );
    on<AppEventGoToRegistration>((event, emit) {
      emit( AppStateRegistrationView(isLoading: false));
    },);
  }

  Future<Iterable<Reference>> getImages(String userId) async {
    final listResult = await FirebaseStorage.instance.ref(userId).list();
    return listResult.items;
  }
}
