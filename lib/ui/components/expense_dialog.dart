import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';

class ExpenseDialog extends StatelessWidget {
  final String title;
  final String content;
  final String proceedButtonText;
  final Function onPressed;
  ExpenseDialog({
    @required this.title,
    @required this.onPressed,
    @required this.content,
    @required this.proceedButtonText,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: screenHeight * 0.022246941,
            ),
      ),
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: onPressed,
          child: Text(proceedButtonText),
        ),
      ],
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyText1.copyWith(),
      ),
    );
  }
}
