import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final Color textColor;
  final String text;
  final Function onPressed;
  BottomButton(
      {@required this.onPressed,
      @required this.text,
      @required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
      ),
      width: screenWidth * 0.350931873,
      child: RaisedButton(
        elevation: 1.0,
        onPressed: onPressed,
        splashColor: Theme.of(context).primaryColor.withOpacity(0.4),
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: kBorderRadius,
          side: BorderSide(
            width: 0.5,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012677255),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button.copyWith(
                fontSize: screenHeight * 0.015677255,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
