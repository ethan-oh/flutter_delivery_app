import 'package:delivery_flutter_app/common/component/confirm_dialog.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Future<dynamic> showConfirmDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: this,
      builder: (context) => ConfirmDialog(
        title: title,
        content: content,
        onConfirm: onConfirm,
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: '닫기',
          onPressed: () {},
        ),
      ),
    );
  }
}
