import 'package:chat_gpt/domain/providers/chat_provider.dart';
import 'package:chat_gpt/domain/providers/models_provider.dart';
import 'package:chat_gpt/feature/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: kScaffoldBackgroundColor,
          appBarTheme: const AppBarTheme(color: kCardColor),
          useMaterial3: true,
        ),
        home: const SafeArea(child: ChatScreen()),
      ),
    );
  }
}
