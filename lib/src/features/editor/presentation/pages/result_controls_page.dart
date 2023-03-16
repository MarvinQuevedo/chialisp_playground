import 'package:flutter/material.dart';
import 'package:flutter_chia_rust_utils/chia_bls.dart';
import 'package:provider/provider.dart';

import '../../models/run_type.dart';
import '../../providers/playground_provider.dart';
import '../../utils/chialisp_obtain_include_files.dart';
import '../../utils/chialisp_parser.dart';
import '../../utils/chialisp_remove_comments.dart';
import '../../utils/error_dialog.dart';

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
  List<String> _includedFiles = [];
  bool showOutput = false;
  String outputText = "";
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result Controls'),
          backgroundColor: const Color.fromARGB(255, 14, 15, 13),
          actions: [
            IconButton(
              onPressed: () => _processInitialCode,
              icon: const Icon(Icons.refresh),
            )],
        ),
        body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              SizedBox(
                height: 30,
              ),
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
                          runType == RunType.run ? "Run Output" : "Brun Output",
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
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _run,
                    child: const Text('Run'),
                  ),
                  const SizedBox(width: 20),
                  if (runType == RunType.run)
                    ElevatedButton(
                      onPressed: () {
                        _compileClsp();
                      },
                      child: const Text('Compile'),
                    ),
                ],
              )
            ]));
  }

  void _compileClsp() {
    final playgroundProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
         setState(() {
          showOutput = true;
          outputText = "Building...";
        });
    playgroundProvider.includePuzzleFiles(_includedFiles).then((value) {
      final playgroundPath = playgroundProvider.playgroundInclude;
      ChiaToolsCmds.run([widget.code, '-i', playgroundPath]).then((value) {
        setState(() {
          showOutput = true;
          outputText = value;
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
      ChiaToolsCmds.run([widget.code, '-i', playgroundPath]).then((value) {
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
    print(_includedFiles);
  }
}
