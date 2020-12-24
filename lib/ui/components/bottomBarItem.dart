import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomBarItem extends StatelessWidget {
  final String name;
  final String image;
  final Function onTap;
  BottomBarItem(
      {@required this.name, @required this.image, @required this.onTap})
      : assert(image != null),
        assert(name != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: screenHeight * 0.005559085), // 5
              child: SvgPicture.asset(
                image,
                color: Theme.of(context).iconTheme.color,
                height: screenHeight * 0.03001906, // 27
                width: screenHeight * 0.03001906, // 27
                fit: BoxFit.contain,
              ),
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: screenHeight * 0.010006353,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
