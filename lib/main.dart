//1

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/screens/tabs.dart';

import 'screens/categories.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  //to use riverpod you need to wrap your app with another widget
  //and this is done to unlock this behind the scenes state management functionality
  //and here we are wrapping the entire app in ProviderScope so that in the all the widgets in the entire app can use these riverpod features
  //if you knew that only certain part of your app needed the provider then you could only wrap that part but here we want to be able to use riverpod
  //in entire app, therefore we will wrap the entire app
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const TabsScreen(),
    );
  }
}
