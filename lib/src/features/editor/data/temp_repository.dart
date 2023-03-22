import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

// ignore: non_constant_identifier_names
final _DS = Platform.pathSeparator;

class TempRepository {
  static final TempRepository instance = TempRepository._();
/*   DateTime _lastSaved = DateTime.now();
  String _lastSavedData = ""; */
  Timer? _timer;
  Directory? _appDocDic;
  TempRepository._();
  final  _temp = <String, String>{};

  void set(String key, String value) {
    _temp[key] = value;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(seconds: 2), () async {
      /*  _lastSaved = DateTime.now();
      _lastSavedData = value; */
      final watch = Stopwatch()..start();
      if (_appDocDic == null) {
        final docDic = await getApplicationDocumentsDirectory();
        _appDocDic =
            Directory('${docDic.absolute.path}$_DS.chialisp_playground');
      }
      final tempDir =
          Directory('${_appDocDic!.absolute.path}$_DS.chialisp_temps');
      final tempFile = File('${tempDir.absolute.path}${_DS}_tempFile.txt');
      if (!tempDir.existsSync()) {
        tempDir.createSync(recursive: true);
      }
      await tempFile.writeAsString(getAlls());
      watch.stop();

      developer.log('saved, ${watch.elapsedMicroseconds}');
    });
  }

  String getAlls() {
    return json.encode(_temp);
  }

  Future loadTempFile() async {
    try {
      if (_appDocDic == null) {
        final docDic = await getApplicationDocumentsDirectory();
        _appDocDic =
            Directory('${docDic.absolute.path}$_DS.chialisp_playground');
      }
      final tempDir =
          Directory('${_appDocDic!.absolute.path}$_DS.chialisp_temps');
      developer.log(tempDir.absolute.path);
      final tempFile = File('${tempDir.absolute.path}${_DS}_tempFile.txt');
      final fileData = await tempFile.readAsString();
      final readedData = Map<String, String>.from(json.decode(fileData));
      _temp.addAll(readedData);
    } catch (e) {
      developer.log(e.toString());
    }
  }

  String? get(String key) => _temp[key];

  void remove(String key) => _temp.remove(key);
}
