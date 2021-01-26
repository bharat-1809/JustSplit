import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class AvatarPicker extends StatefulWidget {
  final TextEditingController pictureUrlController;
  AvatarPicker({@required this.pictureUrlController});

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  String selectedAvatar;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      title: Text(
        "Select your avatar",
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: screenHeight * 0.025,
            ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("CANCEL"),
        ),
        FlatButton(
          onPressed: () {
            widget.pictureUrlController.text = selectedAvatar;
            Navigator.of(context).pop();
          },
          child: Text("SELECT"),
        ),
      ],
      content: Container(
        height: screenHeight * 0.55,
        width: screenWidth * 0.90,
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: userAvatars.length,
          gridDelegate:
              SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 95),
          itemBuilder: (context, index) {
            bool _isSelected = selectedAvatar == userAvatars[index];
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    _isSelected
                        ? BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.30),
                            offset: Offset.zero,
                            blurRadius: 15.0,
                            spreadRadius: 1.1,
                          )
                        : BoxShadow(
                            color: Colors.transparent,
                          ),
                  ],
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: _isSelected ? 3 : 0.0,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    setState(() {
                      selectedAvatar = userAvatars[index];
                    });
                  },
                  child: AvatarTile(
                    avatarUrl: userAvatars[index],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AvatarTile extends StatelessWidget {
  final String avatarUrl;
  AvatarTile({@required this.avatarUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColorDark.withOpacity(0.25),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withOpacity(0.20),
            blurRadius: 15.0,
            offset: Offset(1.0, 1.0),
            spreadRadius: 0.75,
          ),
        ],
      ),
      child: FadeInImage(
        placeholder: AssetImage('assets/icons/misc/loader.png'),
        image: FirebaseImage(
          avatarUrl,
          cacheRefreshStrategy: CacheRefreshStrategy.NEVER,
        ),
      ),
    );
  }
}
