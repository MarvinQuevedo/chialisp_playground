import 'package:chialisp_playground/src/features/editor/providers/puzzles_uncompresser_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future showInstallCipherLibs(BuildContext context) async {
  var loading = false;
  const textSize = 14.0;
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            actionsPadding: loading
                ? const EdgeInsets.all(0)
                : const EdgeInsets.only(right: 10, bottom: 10),
            content: SizedBox(
              height: 100,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cypher | chialisp library 🌱',
                          style: TextStyle(
                            fontSize: textSize + 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'A ',
                                style: TextStyle(fontSize: textSize),
                              ),
                              TextSpan(
                                text: 'chialisp',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: textSize,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlString('https://chialisp.com');
                                  },
                              ),
                              const TextSpan(
                                text:
                                    ' library to develop smart coins (contracts) on the Chia Blockchain by ',
                                style: TextStyle(fontSize: textSize),
                              ),
                              TextSpan(
                                text: 'Hashgreen Labs',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: textSize,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlString(
                                        'https://www.hashgreen.net');
                                  },
                              ),
                              const TextSpan(
                                text: '.',
                                style: TextStyle(fontSize: textSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (loading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              if (!loading)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              if (!loading)
                TextButton(
                  child: const Text('Install'),
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    PuzzleUncompressersProvider.of(context, listen: false)
                        .installCipherLib()
                        .then((value) {
                      if (value) {
                        showInstalledDialog(context).then((value) {
                          Navigator.of(context).maybePop();
                        });
                      } else {
                        showInstallErrorDialog(context);
                      }
                    });
                  },
                )
            ],
          );
        });
      });
}

Future showInstalledDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Install Chiper lib"),
            content: const Text(
                'Cypher | chialisp library 🌱 installed successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                child: const Text('Close'),
              ),
            ]);
      });
}

showInstallErrorDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Install Chiper lib"),
            content:
                const Text('Cypher | chialisp library 🌱 installed failed!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                child: const Text('Close'),
              ),
            ]);
      });
}
