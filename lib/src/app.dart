import 'package:chialisp_playground/src/features/editor/providers/playground_provider.dart';
import 'package:chialisp_playground/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:provider/provider.dart';

import 'features/editor/providers/projects_handler_provider.dart';
import 'features/editor/providers/projects_provider.dart';
import 'features/editor/providers/puzzles_uncompresser_provider.dart';
import 'features/splash/presentation/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeData = appTheme(context, Brightness.dark);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProjectsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ProjectsHandlerProvider(),
        ),
        Provider(
          create: (context) => PuzzleUncompressersProvider(),
        )
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'ChiaList Playground',
          theme: appThemeData.copyWith(
            scaffoldBackgroundColor:
                monokaiSublimeTheme['root']!.backgroundColor,
          ),
          home: const SplashPage(),
        );
      },
    );
  }
}
