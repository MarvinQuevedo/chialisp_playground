import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          leading: const Icon(Icons.list, color: Colors.white),
          title: const Text("Projects", style: TextStyle(color: Colors.white)),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
          onTap: () => _openProjectsPage(context),
        ),
      ]),
    );
  }

  _openProjectsPage(BuildContext context) {}
}
