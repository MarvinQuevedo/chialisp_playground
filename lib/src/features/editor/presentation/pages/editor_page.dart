import 'package:chialisp_playground/src/features/editor/presentation/pages/result_controls_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:provider/provider.dart';

import '../../models/run_type.dart';
import '../../providers/playground_provider.dart';
import '../../utils/chialisp.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/monokaiSublimeThemeWithFont.dart';
import '../../utils/save_file_dialog.dart';
import '../widgets/editor_drawer.dart';

class EditorPage extends StatefulWidget {
  final String orignalCode;
  final RunType runType;
  const EditorPage(
      {super.key, required this.orignalCode, required this.runType});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  String? lastCode;
  late final CodeController _controller;
  Map<String, TextStyle> theme = monokaiSublimeTheme;

  @override
  void initState() {
    _controller = CodeController(
      text: widget.orignalCode, // Initial code
      language: chiaLisp,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addPersonalizedAutocomplements();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final playProvider = Provider.of<PlaygroundProvider>(context);
    return SafeArea(
      child: Container(
        color: theme['root']!.backgroundColor,
        child: Scaffold(
          backgroundColor: theme['root']!.backgroundColor,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 14, 15, 13),
            title:
                Text(playProvider.activeProjectName ?? "ChiaLisp Playground"),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => _saveFile(context),
                icon: const Icon(Ionicons.save),
                iconSize: 35,
              ),
              IconButton(
                onPressed: () => _openRunPage(context),
                icon: const Icon(Ionicons.play_circle_outline),
                iconSize: 40,
              ),
            ],
          ),
          drawer: const EditorDrawer(),
          body: ListView(
            padding: const EdgeInsets.only(top: 0),
            children: [
              CodeTheme(
                data: CodeThemeData(
                  styles: monokaiSublimeThemeWithFont("JetBrainsMono"),
                ),
                child: SizedBox(
                  width: size.width,
                  child: CodeField(
                    controller: _controller,
                    lineNumberBuilder: (number, style) {
                      return TextSpan(
                        text: number.toString(),
                        style: const TextStyle(
                            color: Colors.white, backgroundColor: Colors.red),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: Container(
            color: const Color.fromARGB(255, 14, 15, 13),
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            width: size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActionButton(
                    onPressed: _addChar,
                    value: "\t",
                    maxWidth: 45,
                    child: const Text("TAB"),
                  ),
                  ActionButton(
                    onPressed: _addChar,
                    value: "(",
                    child: const Text("("),
                  ),
                  ActionButton(
                    onPressed: _addChar,
                    value: ")",
                    child: const Text(")"),
                  ),
                  ActionButton(
                    onPressed: _addChar,
                    value: ";",
                    child: const Text(";"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addPersonalizedAutocomplements() {
    final playPro = Provider.of<PlaygroundProvider>(context, listen: false);
    _controller.autocompleter.setCustomWords(playPro.includeFilesNames);
  }

  void _addChar(value) {
    _controller.insertStr(value);
  }

  _openRunPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultControlsPage(
          code: _controller.text,
          theme: theme,
        ),
      ),
    );
  }

  _saveFile(BuildContext context) async {
    final playProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
    final activeProject = playProvider.activeProject;
    if (activeProject == null) {
      showSaveFileDialog(context, _controller.text);
    } else {
      final fileName = activeProject.path.split("/").last;
      await playProvider.saveProject(fileName, _controller.text);
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("File saved"),
                content: const Text("The file was saved successfully"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Ok"))
                ],
              ));
    }
  }
}

class ActionButton extends StatelessWidget {
  final Widget child;
  final ValueChanged onPressed;
  final String value;
  final double maxWidth;
  const ActionButton(
      {super.key,
      required this.child,
      required this.onPressed,
      required this.value,
      this.maxWidth = 40});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 25, maxWidth: maxWidth),
        child: TextButton(
          onPressed: () => onPressed(value),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(monokaiSublimeTheme['meta']!.color),
            foregroundColor:
                MaterialStateProperty.all(monokaiSublimeTheme['tag']!.color),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "JetBrainsMono"),
            child: child,
          ),
        ),
      ),
    );
  }
}
