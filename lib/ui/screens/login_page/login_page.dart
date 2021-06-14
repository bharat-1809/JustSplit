import 'package:contri_app/sdk/functions/messaging_functions.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/blueButton.dart';
import 'package:contri_app/ui/components/currency_helpers.dart';
import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/components/forgotPasswordDialog.dart';
import 'package:contri_app/ui/components/googleButton.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:contri_app/ui/screens/complete_profile/complete_profile.dart';
import 'package:contri_app/ui/screens/home_page/home_page.dart';
import 'package:contri_app/ui/screens/login_page/bloc/login_bloc.dart';
import 'package:contri_app/ui/screens/register_page/register_page.dart';
import 'package:contri_app/ui/screens/verification_page/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  static const String id = "login_page";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(body: LoginMainBody()),
    );
  }
}

class LoginMainBody extends StatelessWidget {
  const LoginMainBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onGoogleSignInPressed() {
      BlocProvider.of<LoginBloc>(context).add(LoginWithGoogle());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Google Sign In"),
      ));
    }

    void _onSignUpPressed() {
      Navigator.of(context).pushReplacementNamed(RegisterPage.id);
    }

    return SafeArea(
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginFailure) {
            Navigator.of(context).pop();
            context.showSnackBar(state.message);
          }
          if (state is LoginSuccess) {
            NotificationHandler().configureFcm(context);
            Navigator.of(context).pop();

            final _currencyData = await getCurrencyData(context);
            currencySymbol = getCurrencySymbol(currencyData: _currencyData);

            Navigator.of(context).pushReplacementNamed(HomePage.id);
          }
          if (state is LoginInProgress) {
            showProgress(context);
          }
          if (state is LoginNeedsProfileComplete) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            await context.showSnackBar(
                "Profile is incomplete. Please Complete your profile");
            Navigator.of(context).pushReplacementNamed(ProfileRegPage.id);
          }
          if (state is LoginNeedsVerification) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            context.showSnackBar(
                "User email is not verified. Please verify your email id");
            Navigator.of(context).pushReplacementNamed(VerificationPage.id);
          }

          if (state is ForgetPasswordSuccess) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            context.showSnackBar(
              "A link to reset password has been sent to your email id. Please click on the link to reset your password",
            );
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
                      "Welcome",
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: screenHeight * 0.042249047, //38
                          ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.036689962, //33
                    ),
                    LoginForm(),
                    SizedBox(
                      height: screenHeight * 0.053367217, // 48
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "or connect with",
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
                      title: "Continue with Google",
                      onPressed: _onGoogleSignInPressed,
                    ),
                    SizedBox(height: screenHeight * 0.180462516), // 183
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: screenHeight * 0.01111817, // 10
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        GestureDetector(
                          onTap: _onSignUpPressed,
                          child: Text(
                            "Sign Up",
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

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailTextController = TextEditingController();
  final _passtextController = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _validator = Validator();
  bool _isObscure = true;

  void _onLoginButtonPressed() {
    if (!_formKey.currentState.validate()) return;
    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(
        email: _emailTextController.text,
        password: _passtextController.text,
      ),
    );
  }

  void _onForgetPasswordPressed() {
    final _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (dialogContext) => PassResetMailDialog(
        formKey: _formKey,
        emailController: _emailController,
        onPressed: () {
          if (!_formKey.currentState.validate()) return;

          BlocProvider.of<LoginBloc>(context)
              .add(ForgetPassword(email: _emailController.text));
        },
      ),
    );
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
          SizedBox(height: screenHeight * 0.024459975), // 22
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _onForgetPasswordPressed,
                child: Text(
                  "FORGOT PASWWORD",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: screenHeight * 0.01111817, // 10
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
          BlueButton(title: "Sign In", onPressed: _onLoginButtonPressed),
        ],
      ),
    );
  }
}
