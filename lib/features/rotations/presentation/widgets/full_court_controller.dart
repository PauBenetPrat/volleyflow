import 'package:flutter/material.dart';

class FullCourtController {
  VoidCallback? _onUndo;
  VoidCallback? _onClear;

  void registerCallbacks({
    required VoidCallback onUndo,
    required VoidCallback onClear,
  }) {
    _onUndo = onUndo;
    _onClear = onClear;
  }

  void undo() {
    _onUndo?.call();
  }

  void clear() {
    _onClear?.call();
  }
}
