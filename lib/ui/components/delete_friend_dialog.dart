import 'package:contri_app/api/functions/friends_functions.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';

class DeleteFriendDialog extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String content;
  DeleteFriendDialog({
    @required this.title,
    @required this.content,
    @required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline1
            .copyWith(fontSize: screenHeight * 0.022246941),
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyText1.copyWith(),
      ),
      actions: [
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Delete'),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
