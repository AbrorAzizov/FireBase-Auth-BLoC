import 'package:bloc_5/bloc/auth_bloc/app_bloc.dart';
import 'package:bloc_5/bloc/auth_bloc/app_state.dart';
import 'package:bloc_5/dialog/delete_account_dialog.dart';
import 'package:bloc_5/firebase_options.dart';
import 'package:bloc_5/pages/home_page.dart';
import 'package:bloc_5/pages/login_page.dart';
import 'package:bloc_5/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) => AppBloc(),
          child: BlocConsumer(builder: (context, state) {
            if (state is AppStateLoggedOut){
              return LoginPage();
            }else if (state is AppStateLoggedIn){
              return HomePage();
            }else if (state is AppStateRegistrationView){
              return  SignupPage();
            }else {
              return Container();
            }
          }, listener: (context, state) {

            if (AppState.authError != null) {

              showDeleteAccountDialog(context);

            }
          },
          ),
        ));
  }
}
