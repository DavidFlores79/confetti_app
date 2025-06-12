import 'package:confetti_app/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Conffeti Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // This works for both Android and iOS.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // your app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms, where the
        // controls will be larger and further apart (less dense).
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // The default font family for the app.
        fontFamily: 'Roboto',
        // The default text theme for the app.
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20.0, color: Colors.black),
          headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
