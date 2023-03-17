import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chia_rust_utils/chia_bls.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/run_type.dart';
import '../../providers/playground_provider.dart';
import '../../utils/chialisp_obtain_include_files.dart';
import '../../utils/chialisp_parser.dart';
import '../../utils/chialisp_remove_comments.dart';
import '../../utils/error_dialog.dart';
import '../../utils/snackbar.dart';

enum _OutputType {
  compile,
  run,
  curry,
  includedFiles,
  args,
  error,
}

class _Output {
  final String text;
  final _OutputType type;
  _Output(this.text, this.type);
  @override
  String toString() {
    return "$type: $text";
  }
}

class ResultControlsPage extends StatefulWidget {
  final String code;
  final Map<String, TextStyle> theme;
  const ResultControlsPage(
      {super.key, required this.code, required this.theme});

  @override
  State<ResultControlsPage> createState() => _ResultControlsPageState();
}

class _ResultControlsPageState extends State<ResultControlsPage> {
  late final ValueNotifier<List<String?>> _arguments;
  final List<_Output> _outputs = [];
  List<String> _includedFiles = [];
  bool get showOutput => _outputs.isNotEmpty;
  bool building = false;

  String? compiled;
  RunType runType = RunType.run;
  List<TextEditingController> argsControllers = [];

  Map<String, TextStyle> get theme => widget.theme;

  String get cleanedCode => chialispRemoveComments(widget.code);
  @override
  void initState() {
    _arguments = ValueNotifier<List<String?>>([]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _processInitialCode();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reversedOutput = _outputs.reversed.toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Result Controls'),
          backgroundColor: const Color.fromARGB(255, 14, 15, 13),
          actions: [
            IconButton(
              onPressed: () => _cleanOutputs(),
              icon: const Icon(Ionicons.refresh_outline),
            ),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () => _shareProject(),
              icon: const Icon(Ionicons.share_outline),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Column(children: [
            if (showOutput)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: ListView.builder(
                    reverse: true,
                    itemBuilder: (context, index) {
                      final output = reversedOutput[index];
                      final isLast = index == 0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          "${outputTypeStr(output.type)}:",
                                          style: theme['tag']!
                                              .copyWith(fontSize: 22)),
                                    ),
                                    IconButton(
                                        onPressed: () => _copy(output.text),
                                        icon: const Icon(Icons.copy))
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  output.text,
                                  style: theme['code'],
                                ),
                                const SizedBox(height: 10),
                                if (!isLast)
                                  Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                              ],
                            ),
                          ),
                          if (building && isLast)
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  CupertinoActivityIndicator(radius: 20),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                    itemCount: reversedOutput.length,
                  ),
                ),
              ),
          ]),
        ),
        bottomSheet: Container(
          color: const Color.fromARGB(255, 14, 15, 13),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          width: size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                                padding:
                                    const EdgeInsets.only(right: 10, top: 10),
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
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutputActionButton(
                      onPressed: _run,
                      child: const Text("Run"),
                    ),
                    OutputActionButton(
                      onPressed: _compileClsp,
                      child: const Text("Compile"),
                    ),
                    OutputActionButton(
                      onPressed: executeCurry,
                      child: const Text("Curry"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String outputTypeStr(_OutputType type) {
    switch (type) {
      case _OutputType.compile:
        return 'Compile';
      case _OutputType.run:
        return 'Run';
      case _OutputType.curry:
        return 'Curry';
      case _OutputType.includedFiles:
        return 'Included Files';
      case _OutputType.error:
        return 'Error';
      case _OutputType.args:
        return 'Args';
    }
  }

  void _compileClsp() {
    final playgroundProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
    setState(() {
      building = true;
    });
    playgroundProvider.includePuzzleFiles(_includedFiles).then((value) {
      final playgroundPath = playgroundProvider.playgroundInclude;
      ChiaToolsCmds.run([widget.code, '-i', playgroundPath]).then((value) {
        setState(() {
          _outputs.add(_Output(value, _OutputType.compile));
          building = false;
          compiled = value;
        });
      });
    }).catchError((error) {
      showError(error.toString(), context);
    });
  }

  void _run() async {
    final playgroundProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
    playgroundProvider.includePuzzleFiles(_includedFiles).then((value) {
      final playgroundPath = playgroundProvider.playgroundInclude;
      if (compiled != null) {
        _bRun(playgroundPath: playgroundPath, compiledValue: compiled!);
        return;
      } else {
        ChiaToolsCmds.run([widget.code, '-i', playgroundPath]).then((value) {
          setState(() {
            _outputs.add(_Output(value, _OutputType.compile));
            building = false;
            compiled = value;
          });
          _bRun(playgroundPath: playgroundPath, compiledValue: value);
        });
      }
    }).catchError((error) {
      showError(error.toString(), context);
    });
  }

  void _bRun({required String playgroundPath, required String compiledValue}) {
    final args = argsControllers.map((e) => e.text).join(" ");
    setState(() {
      _outputs.add(_Output(args, _OutputType.args));
    });
    ChiaToolsCmds.brun([compiledValue, "($args)", '-i', playgroundPath])
        .then((value) {
      setState(() {
        _outputs.add(_Output(value, _OutputType.run));
        building = false;
      });
    });
  }

  void _curry(String programStr) {
    final args = argsControllers.map((e) => e.text).toList();
    final program = Program.parse(programStr);
    final programArgs = <Program>[];
    for (var i = 0; i < args.length; i++) {
      final arg = args[i];
      programArgs.add(Program.parse(arg));
    }
    setState(() {
      _outputs.add(_Output(args.join(" "), _OutputType.args));
    });
    program.curry(args: programArgs).then((value) async {
      final outputText = await value.serializeToHex();
      setState(() {
        _outputs.add(_Output(outputText, _OutputType.curry));
        building = false;
      });
    });
  }

  void executeCurry() async {
    final playgroundProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
    setState(() {
      building = true;
    });
    playgroundProvider.includePuzzleFiles(_includedFiles).then((value) {
      final playgroundPath = playgroundProvider.playgroundInclude;
      if (compiled != null) {
        _curry(compiled!);
        return;
      } else {
        ChiaToolsCmds.run([widget.code, '-i', playgroundPath]).then((value) {
          setState(() {
            _outputs.add(_Output(value, _OutputType.compile));
            building = false;
            compiled = value;
          });
          _curry(value);
        });
      }
    }).catchError((error) {
      showError(error.toString(), context);
    });
  }

  void _processInitialCode() {
    _arguments.value = parseLisp(cleanedCode);

    for (var i = 0; i < _arguments.value.length; i++) {
      if (argsControllers.length <= i) {
        argsControllers.add(TextEditingController());
      }
    }
    _includedFiles = chialispObtainINcludeFiles(widget.code);
    _outputs.add(_Output(_includedFiles.join("\n"), _OutputType.includedFiles));
  }

  _cleanOutputs() {
    setState(() {
      _outputs.clear();
      compiled = null;
    });
  }

  _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    //show snackbar
    Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(
          const MeSnackbar(
            content: Text("Copied to clipboard", style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 1),
          ),
        ));
  }

  _shareProject() async {
    setState(() {
      building = true;
    });

    final playgroundProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);

    final fileToShare = await playgroundProvider.genereSharedActiveProject(
        widget.code, _outputs, _includedFiles);
    final xFile = XFile(
      fileToShare.path,
      mimeType: 'application/zip',
      name: fileToShare.path.split('/').last,
      bytes: await fileToShare.readAsBytes(),
      lastModified: fileToShare.lastModifiedSync(),
      length: fileToShare.lengthSync(),
    );
    final activeProjectName = playgroundProvider.activeProjectName;

    Share.shareXFiles([xFile], text: activeProjectName);
    setState(() {
      building = false;
    });
  }
}

class OutputActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  final double maxWidth;
  const OutputActionButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.maxWidth = 90});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 25, maxWidth: maxWidth),
        child: TextButton(
          onPressed: () =>
              {FocusScope.of(context).requestFocus(FocusNode()), onPressed()},
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
