import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import '../screens/home_screen.dart';
import '../screens/tasks_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Stream<int> _sensorReadings() async* {
    var random = Random();
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield random.nextInt(100);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // User is not signed in -prompted to sign in or register
            return SignInScreen(
              providers: [
                EmailAuthProvider(),
              ],
            );
          } else {
            if (snapshot.data?.displayName == null) {
              // Newly registered User -prompted to add display name in profile
              return ProfileScreen(
                providers: [
                  EmailAuthProvider(),
                ],
              );
            } else {
//User is signed in and profile is updated -go to HomeScreen
              // return const HomeScreen();
              return TasksScreen();
            }
          }
        },
      ),
    );
  }
}
