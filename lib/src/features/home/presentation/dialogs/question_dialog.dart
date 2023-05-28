import 'package:flutter/material.dart';

Future<bool> showQuestionDialog(BuildContext context, String message,
    {String title = "Question", RelativeRect? position}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => QuestionDialog(
      title: title,
      message: message,
      position: position,
    ),
  );
  if (result is bool) {
    return result;
  }
  return false;
}

class QuestionDialog extends StatelessWidget {
  final String title;
  final String message;
  final RelativeRect? position;
  const QuestionDialog({
    super.key,
    required this.title,
    required this.message,
    this.position,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Ok"),
        ),
      ],
    );
  }
}
