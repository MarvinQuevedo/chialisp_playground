import 'dart:io';

import 'package:chialisp_playground/src/features/editor/providers/playground_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../home/presentation/pages/home_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlaygroundProvider>(context, listen: false).loadProjects();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaygroundProvider>(
      builder: (context, provider, child) {
        return Scaffold(
            appBar: AppBar(
              title: const Text("Projects"),
            ),
            body: provider.projects == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: provider.projects!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filename(provider.projects![index])),
                        subtitle:
                            Text(formatFileDate(provider.projects![index])),
                        onTap: () {
                          _openProject(provider.projects![index], context);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.keyboard_arrow_right),
                          onPressed: () {
                             _openProject(provider.projects![index], context);
                          },
                        )
                      );
                    },
                  ));
      },
    );
  }

  void _openProject(File file, BuildContext context) {
    final provider = Provider.of<PlaygroundProvider>(context, listen: false);

    provider.loadProject(file);
    _goToHomePage();
  }

  void _goToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false);
  }

  String filename(File file) {
    return file.path.split("/").last;
  }

  String formatFileDate(File file) {
    final date = file.lastModifiedSync();
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}";
  }
}
