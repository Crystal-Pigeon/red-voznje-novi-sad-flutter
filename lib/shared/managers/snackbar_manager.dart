import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnackbarManager {
  static final SnackbarManager _instance = SnackbarManager._internal();

  factory SnackbarManager() {
    return _instance;
  }

  SnackbarManager._internal();

  final List<String> _snackbarQueue = [];
  bool _isShowing = false;

  void showSnackbar(BuildContext context, String message) {
    if (_snackbarQueue.contains(message)) {
      return; // Don't queue if the same message is already in the queue
    }

    _snackbarQueue.add(message);
    if (!_isShowing) {
      _processQueue(context);
    }
  }

  void _processQueue(BuildContext context) async {
    if (_snackbarQueue.isEmpty || _isShowing) return;

    _isShowing = true;
    final message = _snackbarQueue.removeAt(0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: const Duration(seconds: 3),
      ),
    );

    await Future.delayed(const Duration(seconds: 3)); // Wait for the current snackbar to finish
    _isShowing = false;

    if (_snackbarQueue.isNotEmpty) {
      _processQueue(context); // Process the next snackbar in the queue
    }
  }

}
