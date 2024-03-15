import 'package:chat_gpt/feature/chat_screen.dart';
import 'package:flutter/material.dart';

import 'data/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: kScaffoldBackgroundColor,
        appBarTheme: const AppBarTheme(color: kCardColor),
        useMaterial3: true,
      ),
      home: const SafeArea(child: ChatScreen()),
    );
  }
}
