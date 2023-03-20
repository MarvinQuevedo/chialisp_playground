import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../providers/playground_provider.dart';
import '../../providers/projects_provider.dart';
import '../../providers/puzzles_uncompresser_provider.dart';
import '../../utils/chialisp.dart';
import '../../utils/dir_splitter.dart';
import '../../utils/monokaiSublimeThemeWithFont.dart';
import '../../utils/save_file_dialog.dart';
import '../../utils/snackbar.dart';
import '../widgets/editor_drawer.dart';
import 'result_controls_page.dart';

class EditorPage extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final bool showAppBard;
  final bool showBottomMenu;
  const EditorPage(
      {super.key,
      this.appBar,
      this.showAppBard = true,
      this.showBottomMenu = true});

  @override
  State<EditorPage> createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  String? lastCode;
  late final CodeController _controller;
  Map<String, TextStyle> theme = monokaiSublimeTheme;
  late final FocusNode _editorFocusNode;
  bool _editorInitialized = false;
  late final PlaygroundProvider _playProvider;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: _playProvider,
      child: Builder(builder: (context) {
        return Consumer<PlaygroundProvider>(
          builder: (context, playProvider, child) {
            PreferredSizeWidget? appBar2 = AppBar(
              backgroundColor: const Color.fromARGB(255, 14, 15, 13),
              title:
                  Text(playProvider.activeProjectName ?? "ChiaLisp Playground"),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () => undoCode(context),
                  icon: const Icon(Ionicons.arrow_undo),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () => redoCode(context),
                  icon: const Icon(Ionicons.arrow_redo),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () => saveFile(context),
                  icon: const Icon(Ionicons.save),
                  iconSize: 35,
                ),
                IconButton(
                  onPressed: () => openRunPage(context),
                  icon: const Icon(Ionicons.play_circle_outline),
                  iconSize: 40,
                ),
              ],
            );
            if (widget.appBar != null) {
              appBar2 = widget.appBar;
            } else if (!widget.showAppBard) {
              appBar2 = null;
            }
            return SafeArea(
              child: Container(
                color: theme['root']!.backgroundColor,
                child: Scaffold(
                  backgroundColor: theme['root']!.backgroundColor,
                  appBar: appBar2,
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
                            focusNode: _editorFocusNode,
                            lineNumberBuilder: (number, style) {
                              return TextSpan(
                                text: number.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    backgroundColor: Colors.red),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  bottomSheet: widget.showBottomMenu
                      ? Container(
                          color: const Color.fromARGB(255, 14, 15, 13),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          width: size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _ActionButton(
                                  onPressed: _addChar,
                                  value: "\t",
                                  maxWidth: 45,
                                  child: const Text("TAB"),
                                ),
                                _ActionButton(
                                  onPressed: _addChar,
                                  value: "(",
                                  child: const Text("("),
                                ),
                                _ActionButton(
                                  onPressed: _addChar,
                                  value: ")",
                                  child: const Text(")"),
                                ),
                                _ActionButton(
                                  onPressed: _addChar,
                                  value: ";",
                                  child: const Text(";"),
                                ),
                                _ActionButton(
                                  onPressed: _addChar,
                                  value: ".",
                                  child: const Text("."),
                                ),
                                _ActionButton(
                                  onPressed: _addChar,
                                  value: "'",
                                  child: const Text("'"),
                                ),
                                _ActionButton(
                                  onPressed: _addChar,
                                  value: "\"",
                                  child: const Text("\""),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void initState() {
    _editorFocusNode = FocusNode();
    _controller = CodeController(
      text: "", // Initial code
      language: chiaLisp,
    );
    _playProvider = PlaygroundProvider(_controller);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initEditor();
    });

    super.initState();
  }

  openRunPage(BuildContext context) async {
    final playProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
    final activeProject = playProvider.activeProject;

    if (activeProject == null) {
      await saveFile(context, title: "Save file first");
    } else {
      playProvider.saveProject(
        fileName(activeProject.path),
        _controller.text,
      );
      // ignore: use_build_context_synchronously
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
  }

  redoCode(BuildContext context) {
    _controller.historyController.redo();
  }

  Future<String?> saveFile(BuildContext context,
      {String title = 'Save file'}) async {
    final playProvider =
        Provider.of<PlaygroundProvider>(context, listen: false);
    final activeProject = playProvider.activeProject;
    if (activeProject == null) {
      return showSaveFileDialog(context, _controller.text, title: title);
    } else {
      await playProvider.saveProject(
          fileName(activeProject.path), _controller.text);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const MeSnackbar(
        content: Text("File saved", style: TextStyle(color: Colors.white)),
      ));
      return null;
    }
  }

  undoCode(BuildContext context) {
    _controller.historyController.undo();
  }

  void _addChar(value) {
    _controller.insertStr(value);
  }

  void _forceInitializedEditor() {
    if (_editorFocusNode.hasFocus && !_editorInitialized) {
      _controller.insertStr(" ");
      _controller.removeChar();
      _editorInitialized = true;
      _editorFocusNode.removeListener(_forceInitializedEditor);
    }
  }

  void _initEditor() {
    final puzzlesProvider = Provider.of<PuzzleUncompressersProvider>(
      context,
      listen: false,
    );
    final projectsProvider = Provider.of<ProjectsProvider>(
      context,
      listen: false,
    );
    projectsProvider.addListener(_updateProjectsNames);
    _playProvider
        .init(
      rootBundle: rootBundle,
      appDocDir: puzzlesProvider.appDocDir,
      projectsFilesNames: puzzlesProvider.puzzlesFilesNames,
      puzzlesFilesNames: projectsProvider.projectsFilesNames,
    )
        .then((value) {
      _controller.autocompleter.setCustomWords(_playProvider.includeFilesNames);
      _editorFocusNode.addListener(_forceInitializedEditor);
      FocusScope.of(context).requestFocus(_editorFocusNode);
    });
  }

  void _updateProjectsNames() {
    final projectsProvider = Provider.of<ProjectsProvider>(
      context,
      listen: false,
    );
    _playProvider.updateProjectsFilesNames(projectsProvider.projectsFilesNames);
  }
}

class _ActionButton extends StatelessWidget {
  final Widget child;
  final ValueChanged onPressed;
  final String value;
  final double maxWidth;

  const _ActionButton(
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
