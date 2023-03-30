import 'dart:io';

import '../../providers/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/projects_handler_provider.dart';
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
                          subtitle: Text(
                            formatFileDate(
                              provider.projects![index],
                            ),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                          onTap: () {
                            _openProject(context, provider.projects![index]);
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              _openProject(context, provider.projects![index]);
                            },
                          ));
                    },
                  ));
      },
    );
  }

  _openProject(BuildContext context, File file) {
    Provider.of<ProjectsHandlerProvider>(context, listen: false)
        .openProject(file, false);
    Navigator.maybePop(context);
  }

  String formatFileDate(File file) {
    final date = file.lastModifiedSync();
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}";
  }
}
