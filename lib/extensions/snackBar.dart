import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  showSnackBar(String text) {
    Scaffold.of(this).hideCurrentSnackBar();
    Scaffold.of(this).showSnackBar(
      _snackBar(text),
    );
  }

  SnackBar _snackBar(String text) => SnackBar(
        content: Text(text),
        duration: Duration(seconds: 4),
      );
}
