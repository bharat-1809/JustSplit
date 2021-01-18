import 'package:flutter/material.dart';

class CustomPopItem extends StatelessWidget {
  final String title;

  CustomPopItem({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
