import 'dart:math';

import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/blueButton.dart';
import 'package:contri_app/ui/components/currency_helpers.dart';
import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/components/phone_number_field.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/components/selectAvatar_dialog.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:contri_app/ui/screens/complete_profile/bloc/profilereg_bloc.dart';
import 'package:contri_app/ui/screens/home_page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';

class ProfileRegPage extends StatelessWidget {
  static const String id = "profile_reg_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ProfileregBloc(),
        child: ProfileRegMainBody(),
      ),
    );
  }
}

class ProfileRegMainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileregBloc, ProfileregState>(
      listener: (context, state) {
        if (state is ProfileRegFailed) {
          context.showSnackBar(state.message);
        }
        if (state is ProfileRegSuccess) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          context.showSnackBar("Profile Registration Successful");
          Navigator.of(context).pushReplacementNamed(HomePage.id);
        }
        if (state is ProfileRegInProgress) {
          showProgress(context);
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.072916667),
          child: ListView(
            children: [
              SizedBox(height: screenHeight * 0.0800),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Complete Your Profile",
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: screenHeight * 0.042249047, //38
                        ),
                  ),
                  SizedBox(height: screenHeight * 0.050814485),
                  ProfileForm(),
                ],
              ),
            ],
          ),
        ); // 30);
      },
    );
  }
}

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _defaultCurrencyController = TextEditingController(text: "INR");
  final _photoUrlController = TextEditingController(
    text: userAvatars[Random().nextInt(userAvatars.length)],
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  final _phoneNode = FocusNode();
  final _currencyNode = FocusNode();

  final _validator = Validator();
  Map<String, dynamic> _currencyData = {};

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user.displayName != null) {
        if (user.displayName.length > 0) {
          final List<String> _names = user.displayName.split(" ");
          _firstNameController.text = _names[0];
          _lastNameController.text = _names[1];
        }
      }
    });

    _photoUrlController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _currencyData = await getCurrencyData(context);
  }

  @override
  Widget build(BuildContext context) {
    void _onSaveButtonPressed() {
      if (!_formKey.currentState.validate() || _photoUrlController.text == null) return;

      BlocProvider.of<ProfileregBloc>(context).add(
        ProfileRegClicked(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          photoUrl: _photoUrlController.text,
          phoneNumber: _phoneNumberController.text,
          defaultCurrency: _defaultCurrencyController.text,
        ),
      );

      currencySymbol = getCurrencySymbol(
        currencyData: _currencyData,
        currencyCode: _defaultCurrencyController.text,
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.35),
                  offset: Offset(3.0, 3.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AvatarPicker(pictureUrlController: _photoUrlController),
                );
              },
              child: CircleAvatar(
                child: FadeInImage(
                  placeholder: AssetImage('assets/icons/misc/loader.png'),
                  image: FirebaseImage(_photoUrlController.text),
                ),
                radius: screenHeight * 0.056702668, // 51
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.042249047), // 38
          CustomTextFormField(
            currentNode: _firstNameNode,
            nextNode: _lastNameNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            fieldController: _firstNameController,
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
            fieldController: _lastNameController,
            hintText: 'Last Name',
            prefixImage: 'assets/icons/auth_icons/lastName.svg',
            keyboardType: TextInputType.text,
            validator: _validator.validateCanBeEmptyText,
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
          CurrencyFormField(
            defaultCurrencyCodeController: _defaultCurrencyController,
            currentNode: _currencyNode,
            nextNode: _phoneNode,
            enabled: true,
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
          PhoneNumberField(
            focusNode: _phoneNode,
            textInputAction: TextInputAction.done,
            phoneController: _phoneNumberController,
            hintText: 'Phone Number',
          ),

          SizedBox(height: screenHeight * 0.042249047),
          BlueButton(
            title: "Save and Continue",
            onPressed: _onSaveButtonPressed,
          ),
        ],
      ),
    );
  }
}
