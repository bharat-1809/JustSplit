import 'package:contri_app/ui/components/blueButton.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/screens/complete_profile/complete_profile.dart';
import 'package:contri_app/ui/screens/verification_page/bloc/verification_bloc.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';

class VerificationPage extends StatelessWidget {
  static const String id = "verification_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            VerificationBloc()..add(VerificationInitiated(isFirstTime: true)),
        child: VerificationMainBody(),
      ),
    );
  }
}

class VerificationMainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _onConfirmButtonPressed() {
      BlocProvider.of<VerificationBloc>(context).add(VerificationInitiated());
    }

    void _onResendButtonPressed() {
      BlocProvider.of<VerificationBloc>(context).add(ResendVerificationMail());
    }

    return BlocConsumer<VerificationBloc, VerificationState>(
      listener: (context, state) {
        if (state is VerificationFailed) {
          Navigator.of(context).pop();
          context.showSnackBar(state.message);
        }
        if (state is VerificationSuccess) {
          context.showSnackBar("Verification Successful");
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed(ProfileRegPage.id);
        }
        if (state is VerificationInProgress) {
          showProgress(context);
        }
        if (state is ResendVerification) {
          Navigator.of(context).pop();
          BlocProvider.of<VerificationBloc>(context).add(VerificationInitiated());
        }
      },
      builder: (context, state) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.072916667), // 30
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * 0.222363405, // 200
                  child: Builder(
                    builder: (context) => FlareActor(
                      'assets/flare/verification_loading.flr',
                      alignment: Alignment.center,
                      animation: 'loading',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.044472681), // 40
                Text(
                  "Waiting for Verification",
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: screenHeight * 0.03001906, // 27
                      ),
                ),
                SizedBox(height: screenHeight * 0.03001906), // 27
                Text(
                  "A verification email has been sent to your email",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: screenHeight * 0.015565438, // 14
                      ),
                ),
                Text(
                  "Verify by clicking on the link provided",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: screenHeight * 0.015565438, // 14
                      ),
                ),
                SizedBox(height: screenHeight * 0.050031766), // 45
                BlueButton(
                  title: "Confirm Verification",
                  onPressed: _onConfirmButtonPressed,
                ),
                SizedBox(height: screenHeight * 0.025031766), // 45
                BlueButton(
                  title: "Resend Verification Link",
                  onPressed: _onResendButtonPressed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
