import 'package:chialisp_playground/src/features/home/presentation/pages/desktop_home_page.dart';
import 'package:chialisp_playground/src/features/home/presentation/pages/mobile_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive/responsive.dart';
import '../../../editor/providers/projects_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsHandler>(
      builder: (context, projectsHandler, child) {
        return FlexBuilderWidget(
          builder: (BuildContext context, double width, double offset,
              ScreenSize size) {
            switch (size) {
              case ScreenSize.sm:
              case ScreenSize.xs:
              case ScreenSize.md:
                return const MobileHomePage();

              case ScreenSize.lg:
              case ScreenSize.xl:
              case ScreenSize.xxl:
              case ScreenSize.xxxl:
                return const DesktopHomePage();
            }
          },
        );
      },
    );
  }
}
