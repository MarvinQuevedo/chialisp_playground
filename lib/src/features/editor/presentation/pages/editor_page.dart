import 'package:flutter/material.dart';
import 'package:flutter_chia_rust_utils/classes/clvm/chia_tools_cmds.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/lisp.dart';
import 'package:provider/provider.dart';

import '../../models/run_type.dart';
import '../../providers/playground_provider.dart';
import '../../utils/chialisp_obtain_include_files.dart';
import '../../utils/chialisp_parser.dart';
import '../widgets/embedded_editor.dart';

class EditorPage extends StatefulWidget {
  final String orignalCode;
  final RunType runType;
  const EditorPage(
      {super.key, required this.orignalCode, required this.runType});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final ValueNotifier<List<String?>> _arguments;
  List<String> _includedFiles = [];
  String? lastCode;
  late final CodeController _controller;
  Map<String, TextStyle> theme = monokaiSublimeTheme;
  bool showOutput = false;
  String outputText = "";
  List<TextEditingController> argsControllers = [];

  @override
  void initState() {
    _arguments = ValueNotifier<List<String?>>([]);
    _controller = CodeController(
      text: widget.orignalCode, // Initial code
      language: lisp,
    );

    _controller.addListener(_onEditorValueChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme['root']!.backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          Expanded(
            child: EmbeddedEditor(
              controller: _controller,
              runType: widget.runType,
              height: size.height,
              width: size.width,
            ),
          ),
          const SizedBox(
            height: 0,
          ),
        ],
      ),
      bottomSheet: Container(
        color: theme['root']!.backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              height: 75,
              child: ValueListenableBuilder(
                  valueListenable: _arguments,
                  builder: (context, value, child) {
                    if (value.isEmpty) {
                      return Container();
                    }
                    return SizedBox(
                      width: size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final argName = value[index];
                          final controller = argsControllers.length > index
                              ? argsControllers[index]
                              : null;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10, top: 10),
                            child: SizedBox(
                              width: 100,
                              child: TextField(
                                controller: controller,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: argName?.toUpperCase(),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: value.length,
                      ),
                    );
                  }),
            ),
            if (showOutput)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 5, top: 5),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.runType == RunType.run
                            ? "Run Output"
                            : "Brun Output",
                        style: theme['tag']!.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        outputText,
                        style: theme['tag']!.copyWith(fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 5, top: 5),
            ),
            Row(children: [
              ElevatedButton(
                onPressed: _run,
                child: const Text('Run'),
              ),
              const SizedBox(width: 20),
              if (widget.runType == RunType.run)
                ElevatedButton(
                  onPressed: () {
                    _compileClsp();
                  },
                  child: const Text('Compile'),
                ),
              if (widget.runType == RunType.brun) const SizedBox(width: 10),
              if (widget.runType == RunType.run) const SizedBox(width: 10),
            ]),
          ],
        ),
      ),
    );
  }

  void undo() {}

  void _compileClsp() {
    final playgroundProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
    playgroundProvider.includePuzzleFiles(_includedFiles).then((value) {
      final playgroundPath = playgroundProvider.playgroundInclude;
      ChiaToolsCmds.run([_controller.text, '-i', playgroundPath]).then((value) {
        setState(() {
          showOutput = true;
          outputText = value;
        });
      });
    }).catchError((error) {
      showError(error.toString());
    });
  }

  void _run() async {
    final playgroundProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
    playgroundProvider.includePuzzleFiles(_includedFiles).then((value) {
      final playgroundPath = playgroundProvider.playgroundInclude;
      ChiaToolsCmds.run([_controller.text, '-i', playgroundPath]).then((value) {
        final args = argsControllers.map((e) => e.text).join(" ");
        ChiaToolsCmds.brun([value, "($args)", '-i', playgroundPath])
            .then((value) {
          setState(() {
            showOutput = true;
            outputText = value;
          });
        });
      });
    }).catchError((error) {
      showError(error.toString());
    });
  }

  void _onEditorValueChanged() {
    final watch = Stopwatch()..start();
    final text = _controller.text;
    if (text == lastCode) return;

    _arguments.value = parseLisp(text);

    for (var i = 0; i < _arguments.value.length; i++) {
      if (argsControllers.length <= i) {
        argsControllers.add(TextEditingController());
      }
    }
    _includedFiles = chialispObtainINcludeFiles(text);
    lastCode = text;

    watch.stop();
  }

  Future showError(String error) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }
}
