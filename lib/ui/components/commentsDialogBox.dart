import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:flutter/material.dart';

class AddCommentsBox extends StatelessWidget {
  final Function onAddTap;
  final Function onCancelTap;
  final TextEditingController textController;
  final GlobalKey<FormState> formKey;
  AddCommentsBox(
      {@required this.onAddTap,
      @required this.onCancelTap,
      @required this.textController,
      @required this.formKey});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          onPressed: onCancelTap,
          child: Text("CANCEL"),
        ),
        FlatButton(
          onPressed: onAddTap,
          child: Text("ADD"),
        ),
      ],
      elevation: 10.0,
      title: Text(
        "Add a comment",
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: screenHeight * 0.019685206, // 15
            ),
      ),
      scrollable: true,
      content: Container(
        width: screenWidth * 0.75,
        child: Form(
          key: formKey,
          child: CustomTextFormField(
            textInputAction: TextInputAction.done,
            fieldController: textController,
            hintText: "Add a comment",
            prefixImage: "assets/icons/bottom_bar/notes.svg",
            keyboardType: TextInputType.text,
            validator: Validator().validateNonEmptyText,
            maxLines: null,
          ),
        ),
      ),
    );
  }
}
