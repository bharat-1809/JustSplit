import 'dart:async';

import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmNewPassController = TextEditingController();
  final _currentPassNode = FocusNode();
  final _newPassNode = FocusNode();
  final _confirmNewPassNode = FocusNode();
  final _validator = Validator();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    Widget _showPassIcon() {
      return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: IconButton(
          icon: SvgPicture.asset(
            _isObscure
                ? "assets/icons/auth_icons/visibility_off.svg"
                : "assets/icons/auth_icons/visibility.svg",
            color: Theme.of(context).primaryColor,
            height: screenHeight * 0.024471635,
            width: screenHeight * 0.024471635,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      );
    }

    /// on change password click
    void _onChangePassClick() async {
      if (!_formKey.currentState.validate()) return;
      try {
        showProgress(context);
        final _user = await FirebaseAuth.instance.currentUser();

        /// If the user is signed in using Google, they cannot change their password;
        if (_user.displayName != null ? _user.displayName.isNotEmpty : false) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
            SnackBar(
              content: Text(
                "You cannot change the password of your Google account here",
              ),
            ),
          );
          return;
        }

        final _credentials = EmailAuthProvider.getCredential(
          email: _user.email,
          password: _currentPassController.text,
        );

        final _reauthenticate =
            await _user.reauthenticateWithCredential(_credentials);

        if (_reauthenticate.user == null) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
            SnackBar(
              content: Text(
                "A problem occured. Please Login again",
              ),
            ),
          );
          return;
        }

        /// Authenticated user
        final _authUser = await FirebaseAuth.instance.currentUser();
        await _authUser.updatePassword(_newPassController.text);

        Navigator.of(context).pop();
        Navigator.of(context).pop();

        Fluttertoast.showToast(
          msg: "Password Changed Successfully",
          textColor: Theme.of(context).textTheme.bodyText1.color,
          backgroundColor: Theme.of(context).backgroundColor,
        );
      } on PlatformException catch (e) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      } on TimeoutException catch (e) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
          SnackBar(content: Text("Error Timedout: ${e.message}")),
        );
      } catch (e) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }

    return AlertDialog(
      title: Text(
        "Change Password",
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: screenHeight * 0.030685206,
            ),
      ),
      content: Container(
        height: screenHeight * 0.38,
        width: screenWidth * 0.80,
        child: Scaffold(
          key: _scaffoldKey,
          body: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.040246941),
                    CustomTextFormField(
                      currentNode: _currentPassNode,
                      nextNode: _newPassNode,
                      obscureText: _isObscure,
                      fieldController: _currentPassController,
                      hintText: "Enter current password",
                      prefixImage: "assets/icons/auth_icons/lock.svg",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: _validator.validatePassword,
                      maxLines: 1,
                      suffix: _showPassIcon(),
                    ),
                    SizedBox(height: screenHeight * 0.025246941),
                    CustomTextFormField(
                      currentNode: _newPassNode,
                      nextNode: _confirmNewPassNode,
                      fieldController: _newPassController,
                      obscureText: _isObscure,
                      hintText: "Enter New Password",
                      prefixImage: "assets/icons/auth_icons/lock.svg",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: _validator.validatePassword,
                      maxLines: 1,
                      suffix: _showPassIcon(),
                    ),
                    SizedBox(height: screenHeight * 0.025246941),
                    CustomTextFormField(
                      currentNode: _confirmNewPassNode,
                      fieldController: _confirmNewPassController,
                      obscureText: _isObscure,
                      hintText: "Confirm New Password",
                      prefixImage: "assets/icons/auth_icons/lock.svg",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (confirmPass) =>
                          _validator.validateConfirmPassword(
                        newPassword: _newPassController.text,
                        confirmPassword: confirmPass,
                      ),
                      maxLines: 1,
                      suffix: _showPassIcon(),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          onPressed: _onChangePassClick,
          child: Text("CHANGE PASSWORD"),
        ),
      ],
    );
  }
}
