import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(title: title, message: message),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Elimina'),
        ),
      ],
    );
  }
}
