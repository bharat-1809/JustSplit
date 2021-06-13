import 'package:contri_app/global/logger.dart';
import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/components/phone_number_field.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:contri_app/extensions/snackBar.dart';

class AddNewFriendDialog extends StatefulWidget {
  final void Function() onPressed;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNumberController;
  AddNewFriendDialog({
    @required this.onPressed,
    @required this.formKey,
    @required this.firstNameController,
    @required this.lastNameController,
    @required this.phoneNumberController,
  })  : assert(onPressed != null),
        assert(formKey != null),
        assert(firstNameController != null),
        assert(lastNameController != null),
        assert(phoneNumberController != null);

  @override
  _AddNewFriendDialogState createState() => _AddNewFriendDialogState();
}

class _AddNewFriendDialogState extends State<AddNewFriendDialog> {
  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  final _phoneNode = FocusNode();
  final _validator = Validator();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      scrollable: true,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            // // Another 'pop' to restrict the user form adding expense with a NULL user
            // This is commented out as this pops out the homepage when adding friends in the friend page
            // Navigator.of(context).pop();
          },
          child: Text("CANCEL"),
        ),
        FlatButton(
          onPressed: widget.onPressed,
          child: Text("ADD FRIEND"),
        ),
      ],
      title: Text(
        "Add Friend",
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: screenHeight * 0.030685206,
            ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius,
      ),
      content: Container(
        width: screenWidth,
        height: screenHeight * 0.47,
        child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          body: Builder(
            builder: (context) => Form(
              key: widget.formKey,
              child: Container(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: screenHeight * 0.026677255),
                      FlatButton(
                        onPressed: () async {
                          bool _hasPermission = await FlutterContactPicker.hasPermission();
                          if (!_hasPermission) {
                            _hasPermission =
                                await FlutterContactPicker.requestPermission(force: true);
                          }
                          if (_hasPermission) {
                            PhoneContact _contact =
                                await FlutterContactPicker.pickPhoneContact(askForPermission: true);
                            setState(() {
                              widget.phoneNumberController.text = _contact.phoneNumber.number;
                              final List<String> _nameList = _contact.fullName.split(" ");
                              widget.firstNameController.text = _nameList[0];
                              widget.lastNameController.text =
                                  _nameList.length > 1 ? _nameList[1] : "";
                            });
                          } else {
                            context.showSnackBar("Permission Not Granted");
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: kBorderRadius,
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          "Pick from Contacts",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: screenHeight * 0.015685206,
                              ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.020685206),
                      Text("OR", style: Theme.of(context).textTheme.caption),
                      SizedBox(height: screenHeight * 0.020685206),
                      CustomTextFormField(
                        currentNode: _firstNameNode,
                        nextNode: _lastNameNode,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        fieldController: widget.firstNameController,
                        hintText: 'First Name',
                        prefixImage: 'assets/icons/auth_icons/firstName.svg',
                        keyboardType: TextInputType.text,
                        validator: _validator.validateName,
                      ),
                      SizedBox(height: screenHeight * 0.024459975), // 22
                      CustomTextFormField(
                        currentNode: _lastNameNode,
                        nextNode: _phoneNode,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        fieldController: widget.lastNameController,
                        hintText: 'Last Name',
                        prefixImage: 'assets/icons/auth_icons/lastName.svg',
                        keyboardType: TextInputType.text,
                        validator: _validator.validateCanBeEmptyText,
                      ),
                      SizedBox(height: screenHeight * 0.024459975), // 22
                      PhoneNumberField(
                        phoneController: widget.phoneNumberController,
                        focusNode: _phoneNode,
                        textInputAction: TextInputAction.done,
                        initialPhone: widget.phoneNumberController.text,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void inviteFriend(
    {@required BuildContext context,
    @required String phoneNumber,
    @required String firstName}) async {
  final _dialog = AlertDialog(
    actions: [
      FlatButton(
        onPressed: () async {
          await sendInviteSms(phoneNumber: phoneNumber, firstName: firstName);

          Navigator.of(context).pop();
        },
        child: Text("SEND TEXT MESSAGE"),
      ),
    ],
    title: Text(
      "🎉 Your Friend has been added",
      style: Theme.of(context).textTheme.headline4.copyWith(
            fontSize: screenHeight * 0.020685206,
          ),
    ),
    content: Text(
      "Send a text message to let them know: ",
      style: Theme.of(context).textTheme.caption,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: kBorderRadius,
    ),
  );

  showDialog(
    context: context,
    builder: (context) => _dialog,
  );
}

Future<void> sendInviteSms({@required String phoneNumber, @required String firstName}) async {
  final String _message =
      "Hi $firstName! Join me on JustSplit, an expense splitting application that I use for managing my expenses. Its simple and easy to use. Download it here: https://play.google.com/store/apps/details?id=dot.studios.contri_app";

  String _result =
      await sendSMS(message: _message, recipients: [phoneNumber]).catchError((onError) {
    logger.e(onError);
  });

  logger.v(_result);
}
