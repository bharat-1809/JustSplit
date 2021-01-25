import 'package:contri_app/sdk/functions/customer_support_functions.dart';
import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class PassResetMailDialog extends StatelessWidget {
  final Function onPressed;
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  PassResetMailDialog({
    @required this.onPressed,
    @required this.formKey,
    @required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      title: Text(
        "Forgot Password",
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: screenHeight * 0.030685206,
            ),
      ),
      content: Container(
        width: screenWidth * 0.80,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.028246941),
              CustomTextFormField(
                fieldController: emailController,
                hintText: "Enter registered email",
                prefixImage: "assets/icons/auth_icons/mail.svg",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: Validator().validateEmail,
                maxLines: 1,
              ),
              SizedBox(height: screenHeight * 0.025246941),
              Text(
                "A link will be sent to your registered email Id. Click on the link to reset your password",
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: screenHeight * 0.025),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await CustomerSupport.mailToSupport(
                    subject: "Trouble Signing In",
                    body: "Please%20explain%20your%20issue%briefly",
                  );
                  await FirebaseAnalytics()
                      .logEvent(name: 'trouble_signing_in');
                },
                child: Text(
                  "Trouble signing in? Contact Us",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
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
          onPressed: onPressed,
          child: Text("CONFIRM"),
        ),
      ],
    );
  }
}
