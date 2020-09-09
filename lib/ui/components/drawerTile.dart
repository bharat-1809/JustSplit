import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String icon;
  const DrawerTile({@required this.title, @required this.icon, @required this.onTap})
      : assert(icon != null),
        assert(title != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: onTap,
      splashColor: Theme.of(context).splashColor,
      highlightColor: Theme.of(context).highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(
              icon,
              color: Theme.of(context).iconTheme.color,
              fit: BoxFit.contain,
              height: screenHeight * 0.030795426,
              width: screenHeight * 0.030795426,
            ),
            SizedBox(width: screenWidth * 0.0486618),
            Text(
              title,
              style: Theme.of(context).textTheme.headline2.copyWith(
                    fontSize: screenHeight * 0.015341804,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
