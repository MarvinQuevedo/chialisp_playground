import 'dart:io';

import 'package:chialisp_playground/src/features/editor/providers/playground_provider.dart';
import 'package:chialisp_playground/src/features/editor/providers/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../utils/dir_splitter.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProjectsProvider>(context, listen: false).loadProjects();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsProvider>(
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
                        title: Text(fileName(provider.projects![index].path)),
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

  void _openProject(File file, BuildContext context) async{
    final provider = Provider.of<PlaygroundProvider>(context, listen: false);

    await provider.loadProject(file);
    _goToHomePage();
  }

  void _goToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false);
  }

 

  String formatFileDate(File file) {
    final date = file.lastModifiedSync();
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}";
  }
}
