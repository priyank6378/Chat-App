import 'package:chat_app/views/chat_page_view.dart';
import 'package:chat_app/views/no_internet_view.dart';
import 'package:chat_app/views/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/const/route.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/service/auth_providers.dart';
import 'package:chat_app/views/login_page_view.dart';
import 'package:chat_app/views/main_page_view.dart';
import 'package:chat_app/views/signup_page_view.dart';
import 'package:chat_app/views/verify_email_view.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: {
        loginPageRoute: (context) => const LoginPageView(),
        homePageRoute: (context) => const MyHomePage(),
        signupPageRoute: (context) => const SignUpPageView(),
        verifyEmailPageRoute: (context) => const VerifyEmailView(),
        chatPageRoute: (context) => const ChatPageView(),
        profileRoute:(context) => const ProfileView(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: InternetConnectionChecker().hasConnection,
      builder: (context, snapshot) {
        print(snapshot.data);
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data == true) {
            User? curUser = GoogleAuthentication().getUser();
            if (curUser == null) {
              return const LoginPageView();
            }
            if (curUser.emailVerified == false) {
              return const VerifyEmailView();
            }
            return const MainPageView();
          } else {
            return const NoInternetView(directRoute: loginPageRoute);
          }
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
