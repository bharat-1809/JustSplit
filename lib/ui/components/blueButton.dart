import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  BlueButton({@required this.title, @required this.onPressed})
      : assert(onPressed != null),
        assert(title != null);
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: kBorderRadius,
      color: Colors.transparent,
      elevation: 5.0,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
      child: RaisedButton(
        splashColor: Theme.of(context).splashColor,
        onPressed: onPressed,
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.button.copyWith(
                  fontSize: screenHeight * 0.017789072, // 16
                ),
          ),
        ),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: kBorderRadius,
        ),
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.018900889, // 17
        ),
      ),
    );
  }
}
