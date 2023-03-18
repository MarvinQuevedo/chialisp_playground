import 'package:chialisp_playground/src/features/editor/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:provider/provider.dart';

import '../providers/playground_provider.dart';
import 'snackbar.dart';

Future<String?> showSaveFileDialog(BuildContext context, String content,
    {String title = "Save file"}) async {
  //show dialog for insert name with TextEditingController
  final textController = TextEditingController();
  final tagColor = monokaiSublimeTheme['tag']!.color!;
  final playgroundProvider =
      Provider.of<PlaygroundProvider>(context, listen: false);
  final fileName = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(color: Colors.white)),
          backgroundColor: monokaiSublimeTheme['root']!.backgroundColor,
          content: Row(
            children: [
              Expanded(
                child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: "Insert file name",
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: tagColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: tagColor),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: tagColor),
                      ),
                      fillColor: monokaiSublimeTheme['tag']!.backgroundColor,
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (_) {
                      if (textController.text.trim().isEmpty) {
                        showError("Filename can't be empty", context);
                      } else {
                        Navigator.pop(context, textController.text);
                      }
                    }),
              ),
              const Text(
                ".clsp",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: tagColor),
              ),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.trim().isEmpty) {
                  showError("Filename can't be empty", context);
                } else {
                  Navigator.pop(context, textController.text);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: tagColor),
              ),
            )
          ],
        );
      });
  if (fileName != null) {
    await playgroundProvider.saveProject(
      fileName + ".clsp",
      content,
    );

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const MeSnackbar(
      content: Text("File saved", style: TextStyle(color: Colors.white)),
      duration: Duration(seconds: 2),
    ));
    return fileName + ".clsp";
  }
  return null;
}
