import 'package:contri_app/ui/global/utils.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String name;
  final String id;
  final String photoUrl;
  final Object arguments;
  UserTile(
      {@required this.name,
      @required this.id,
      @required this.photoUrl,
      this.arguments});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: screenHeight * 0.005559085),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenHeight * 0.049913596,
            height: screenHeight * 0.049913596,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColorDark,
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: FadeInImage(
                placeholder: AssetImage('assets/icons/misc/loader.png'),
                image: FirebaseImage(photoUrl),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.036458333), // 15
          Text(
            name,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: screenHeight * 0.016677255, // 15
                ),
          ),
        ],
      ),
    );
  }
}
