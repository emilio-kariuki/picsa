import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';

extension Toasts on BuildContext {
  void showErrorToast({
    required String title,
    required String message,
    required BuildContext context,
  }) {
    Toastification().show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: title,
      description: message,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void showSuccessToast(
      {required String title,
      required String message,
      required BuildContext context}) {
    Toastification().show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: title,
      description: message,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}


