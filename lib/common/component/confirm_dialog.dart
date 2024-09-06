import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            onConfirm();
            context.pop();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
