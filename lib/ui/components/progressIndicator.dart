import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showProgress(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    child: Center(
      child: Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
