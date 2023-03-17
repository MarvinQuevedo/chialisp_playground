 
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; 
import 'package:provider/provider.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../providers/playground_provider.dart';
import '../../utils/save_file_dialog.dart';
import '../pages/projects_page.dart';

class EditorDrawer extends StatelessWidget {
  const EditorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 43, 46, 41),
      child: ListView(children: [
        DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.network(
                      "https://chialisp.com/img/logo.svg",
                      width: 35,
                      height: 35,
                      color: Colors.white,
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Image.network(
                      "https://ozonewallet.io/images/Ozone_Logo/Logo_Footer.png",
                      width: 100,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "ChiaList Playground",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Text(
                  "v0.0.1",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            )),
        ListTile(
          leading: const Icon(Icons.add, color: Colors.white),
          title:
              const Text("New file", style: TextStyle(color: Colors.white)),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
          onTap: () => _createNewProject(context),
        ),
        ListTile(
          leading: const Icon(Icons.list, color: Colors.white),
          title: const Text("Files", style: TextStyle(color: Colors.white)),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
          onTap: () => _openProjectsPage(context),
        ),
      ]),
    );
  }

  _openProjectsPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ProjectsPage()));
  }

  _createNewProject(BuildContext context) {
    showSaveFileDialog(context, "", title: "Create new file").then((result) {
      if (result != null) {
        final playProvider =
            Provider.of<PlaygroundProvider>(context, listen: false);
        playProvider.loadProjectWithFilename(result).then((value) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false);
        });
      }
    });
  }
}
