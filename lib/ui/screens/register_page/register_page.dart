import 'package:contri_app/sdk/functions/messaging_functions.dart';
import 'package:contri_app/ui/components/blueButton.dart';
import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/components/googleButton.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:contri_app/ui/screens/login_page/login_page.dart';
import 'package:contri_app/ui/screens/register_page/bloc/register_bloc.dart';
import 'package:contri_app/ui/screens/verification_page/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatelessWidget {
  static const String id = 'register_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: RegisterMainBody(),
      ),
    );
  }
}

class RegisterMainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _onGoogleSignUpPressed() {
      if (!_RegisterFormState.acceptTnC) {
        context.showSnackBar("Please accept Terms and Conditions");
        return;
      }

      BlocProvider.of<RegisterBloc>(context).add(GoogleSignUpClicked());
    }

    void _onSignInPressed() {
      Navigator.of(context).pushReplacementNamed(LoginPage.id);
    }

    return SafeArea(
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailed) {
            Navigator.of(context).pop();
            context.showSnackBar(state.message);
          }
          if (state is RegisterSuccess) {
            NotificationHandler().configureFcm(context);
            context.showSnackBar("Registration Successful");
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacementNamed(VerificationPage.id);
          }
          if (state is RegisterInProgress) {
            showProgress(context);
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              SizedBox(
                height: screenHeight * 0.142312579, // 128
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.072916667), // 30
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: screenHeight * 0.042249047, //38
                          ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.036689962, //33
                    ),
                    RegisterForm(),
                    SizedBox(
                      height: screenHeight * 0.053367217, // 48
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "or register with",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                fontSize: screenHeight * 0.01111817, // 10
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.053367217, // 48
                    ),
                    GoogleButton(
                      title: "Sign Up with Google",
                      onPressed: _onGoogleSignUpPressed,
                    ),
                    SizedBox(height: screenHeight * 0.140462516),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: screenHeight * 0.01111817, // 10
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        GestureDetector(
                          onTap: _onSignInPressed,
                          child: Text(
                            "Sign In",
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: screenHeight * 0.01111817, // 10
                                    ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailTextController = TextEditingController();
  final _passtextController = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _validator = Validator();
  static bool acceptTnC = false;
  bool _isObscure = true;

  void _onRegisterButtonPressed() {
    if (!_formKey.currentState.validate()) return;

    if (!acceptTnC) {
      context.showSnackBar("Please accept Terms and Conditions");
      return;
    }

    BlocProvider.of<RegisterBloc>(context).add(RegisterButtonClicked(
        email: _emailTextController.text, password: _passtextController.text));
  }

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

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            currentNode: _emailNode,
            nextNode: _passwordNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            fieldController: _emailTextController,
            hintText: 'Email',
            prefixImage: 'assets/icons/auth_icons/mail.svg',
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
          CustomTextFormField(
            currentNode: _passwordNode,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            fieldController: _passtextController,
            hintText: 'Password',
            prefixImage: 'assets/icons/auth_icons/lock.svg',
            keyboardType: TextInputType.text,
            validator: _validator.validatePassword,
            obscureText: _isObscure,
            suffix: _showPassIcon(),
          ),
          // SizedBox(height: screenHeight * 0.061149936), // 55
          SizedBox(height: screenHeight * 0.024459975), // 22
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                value: acceptTnC,
                onChanged: (newVal) {
                  setState(() {
                    acceptTnC = newVal;
                  });
                },
                visualDensity: VisualDensity.compact,
              ),
              Text(
                "I accept ",
                style: Theme.of(context).textTheme.headline3.copyWith(
                      fontSize: screenHeight * 0.01111817, // 10
                    ),
              ),
              GestureDetector(
                onTap: () async {
                  launch("https://contri-app.web.app");
                },
                child: Text(
                  "Terms and Conditions",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: screenHeight * 0.01111817, // 10
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
          BlueButton(title: "Sign Up", onPressed: _onRegisterButtonPressed),
        ],
      ),
    );
  }
}
