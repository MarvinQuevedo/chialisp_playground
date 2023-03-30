import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

 
abstract class EditorActionHelper {
  void addChar(String value);
  void undoCode( );
  void redoCode( );
  void saveFile(  {String title = 'Save file'});
  void openRunPage({bool isDesktop = false});
}

class EditorActionsProvider extends ChangeNotifier{ 
  EditorActionHelper? _editorActionHelper;
  EditorActionHelper? get editorActionHelper => _editorActionHelper;
  set editorActionHelper(EditorActionHelper? value) {
    _editorActionHelper = value;
    notifyListeners();
  }

  static EditorActionsProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<EditorActionsProvider>(context, listen: listen);
  }
  
}
