import 'package:delivery_flutter_app/common/component/confirm_dialog.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Future<dynamic> showConfirmDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: this,
      builder: (context) => ConfirmDialog(
        title: title,
        content: content,
        onConfirm: onConfirm,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
