import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'MVVM/view.dart';
import 'firebase_options.dart'; // Import the generated file

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options:
            DefaultFirebaseOptions.currentPlatform, // Use the generated options
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          print('Error initializing Firebase: ${snapshot.error}');
          return MaterialApp(
            home: Scaffold(
              body: Center(
                  child:
                      Text("Error initializing Firebase: ${snapshot.error}")),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
        );
      },
    );
  }
}
