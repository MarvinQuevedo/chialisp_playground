import 'package:get/get.dart';

import 'features/editor/providers/projects_handler_provider.dart';
import 'features/editor/providers/projects_provider.dart';
import 'features/editor/providers/puzzles_uncompresser_provider.dart';
import 'features/home/presentation/providers/theme_provider.dart';

void injectionContainer() {
  Get.lazyPut<ProjectsProvider>(() => ProjectsProvider());
  Get.lazyPut<ProjectsHandlerProvider>(() => ProjectsHandlerProvider());
  Get.lazyPut<PuzzleUncompressersProvider>(() => PuzzleUncompressersProvider());
  Get.lazyPut<ThemeProvider>(() => ThemeProvider());
  Get.create<ProjectsHandlerProvider>(
    () => ProjectsHandlerProvider(),
  );
}
