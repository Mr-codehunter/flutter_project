import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:superfine_data_collection/pages/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'Authenticate/authenticate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

 Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAG_HHT2tuAbBfE41D1q9Tqvi3uDSts_mY",
        authDomain: "flutter-project-25fb4.firebaseapp.com",
        databaseURL: "https://flutter-project-25fb4-default-rtdb.firebaseio.com",
        projectId: "flutter-project-25fb4",
        storageBucket: "flutter-project-25fb4.appspot.com",
        messagingSenderId: "714742905997",
        appId: "1:714742905997:web:9f463cdc86c261e43ab6c4",
        measurementId: "G-RPWERMXNCL"
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // CHeck for Errors
        if (snapshot.hasError) {
          print("Something went Wrong");
        }
        // once Completed, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'SuperFine Collector',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            home: Authenticate(),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}