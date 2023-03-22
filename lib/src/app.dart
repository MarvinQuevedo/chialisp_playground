 
import 'package:chialisp_playground/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'features/editor/providers/editor_actions_provider.dart';
import 'features/editor/providers/projects_handler_provider.dart';
import 'features/editor/providers/projects_provider.dart';
import 'features/editor/providers/puzzles_uncompresser_provider.dart';
import 'features/home/presentation/providers/theme_provider.dart';
import 'features/splash/presentation/splash_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final appThemeData = appTheme(context, Brightness.dark);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Get.find<ProjectsProvider>(),
        ),
        ChangeNotifierProvider.value(
          value: Get.find<ProjectsHandlerProvider>(),
        ),
        Provider.value(
          value: Get.find<PuzzleUncompressersProvider>(),
        ),
        Provider.value(
          value: Get.find<EditorActionsProvider>(),
        ),
        ChangeNotifierProvider.value(
          value: Get.find<ThemeProvider>(),
        )
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'ChiaList Playground',
          debugShowCheckedModeBanner: false,
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
