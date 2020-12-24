import 'package:contri_app/global/logger.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class AddExpTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final ImageProvider<dynamic> image;
  final TextInputType keyboardType;
  final Function validator;
  final bool currencyField;
  final Widget currencyImage;
  AddExpTextField(
      {@required this.hintText,
      @required this.textController,
      this.image,
      this.currencyImage,
      @required this.currencyField,
      @required this.keyboardType,
      @required this.validator})
      : assert((currencyField == false && currencyImage == null) ||
            (currencyField == true && currencyImage != null));
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.793333333,
      child: TextFormField(
        validator: validator,
        keyboardType: keyboardType,
        controller: textController,
        cursorColor: Theme.of(context).primaryColor,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.caption.copyWith(
              fontSize: screenHeight * 0.015565438, // 14
            ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.caption.copyWith(
                fontSize: screenHeight * 0.015565438, // 14
              ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.036458333,
            vertical: screenHeight * 0.011124524, // h=15, v=19
          ),
          icon: Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).primaryColorDark, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.50,
                    spreadRadius: 0.2,
                  ),
                ],
              ),
              height: screenHeight * 0.052472681, // 40
              width: screenHeight * 0.052472681, // 40
              child: CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: currencyField
                    ? currencyImage
                    : FadeInImage(
                        placeholder: AssetImage('assets/icons/misc/loader.png'),
                        image: image,
                        imageErrorBuilder: (context, error, stackTrace) {
                          logger.w("Firebase Image cannot be retrieved");
                          logger.e(image.toString());
                          logger.e(error);
                          return Image(
                            image: FirebaseImage(
                                'gs://contri-app.appspot.com/expense_avatars/001-holy.png'),
                            semanticLabel: "Error Image",
                          );
                        },
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
              color: Theme.of(context).primaryColorDark.withOpacity(0.75),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
              color: Theme.of(context).primaryColorDark.withOpacity(0.75),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
              color: Theme.of(context).primaryColorDark.withOpacity(0.75),
            ),
          ),
        ),
      ),
    );
  }
}
