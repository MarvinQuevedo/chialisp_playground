import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

 
abstract class EditorActionHelper {
  void addChar(String value);
  void undoCode(BuildContext context);
  void redoCode(BuildContext context);
  void saveFile(BuildContext context, {required String title});
  void openRunPage(BuildContext context);
}

class EditorActionsProvider { 
  EditorActionHelper? editorActionHelper;

  static EditorActionsProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<EditorActionsProvider>(context, listen: listen);
  }
  
}
