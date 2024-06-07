import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastManager {
  static void showSuccessToast(
      BuildContext context, String title, String message) {
    MotionToast.success(
      borderRadius: 12,
      animationCurve: Curves.linearToEaseOut,
      toastDuration: const Duration(seconds: 1),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromLeft,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      description: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ).show(context);
  }
}
