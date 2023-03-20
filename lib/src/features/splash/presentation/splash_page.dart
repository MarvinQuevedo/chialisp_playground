// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../editor/providers/projects_provider.dart';
import '../../editor/providers/puzzles_uncompresser_provider.dart';
import '../../home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String log = "Initializing...";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              log,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initEnviroments();
    });
    super.initState();
  }

  void _initEnviroments() {
    final playgroundProvider =
        Provider.of<PuzzleUncompressersProvider>(context, listen: false);
    playgroundProvider.init(rootBundle).then((value) {
      final projecsProvider =
          Provider.of<ProjectsProvider>(context, listen: false);
      projecsProvider.appDocDir = playgroundProvider.appDocDir;
      projecsProvider.loadProjects().then((value) {
        _goToHomePage();
      });
    });
  }

  void _goToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false);
  }
}
