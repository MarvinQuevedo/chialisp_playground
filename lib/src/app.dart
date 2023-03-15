import 'package:chialisp_playground/src/features/editor/providers/playground_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:provider/provider.dart';

import 'features/splash/presentation/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaygroundProvider(),
      child: MaterialApp(
        title: 'ChiaList Playground',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: monokaiSublimeTheme['root']!.backgroundColor,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
