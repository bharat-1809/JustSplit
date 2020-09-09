import 'dart:math' as math;

import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/logger.dart';
import 'package:contri_app/ui/components/currency_helpers.dart';
import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/components/selectAvatar_dialog.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:contri_app/ui/screens/profile_page/bloc/profile_bloc.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';

class ProfilePage extends StatelessWidget {
  static const String id = "profile_page";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: ProfilePageBody(),
    );
  }
}

class ProfilePageBody extends StatefulWidget {
  @override
  _ProfilePageBodyState createState() => _ProfilePageBodyState();
}

class _ProfilePageBodyState extends State<ProfilePageBody>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _defaultCurrencyController = TextEditingController();
  final _photoUrlController = TextEditingController();
  AnimationController _animationController;
  Animation _opacityAnimation;
  bool editable = false;
  Map<String, dynamic> _currencyData = {};

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    final _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.ease);
    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(_curve);

    _photoUrlController.text = globalUser.pictureUrl;
    _firstNameController.text = globalUser.firstName;
    _lastNameController.text = globalUser.lastName;
    _defaultCurrencyController.text = globalUser.defaultCurrency;
    _phoneNumberController.text = globalUser.phoneNumber;

    _photoUrlController.addListener(() {
      setState(() {
        logger.d("Avatar Changed");
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _currencyData = await getCurrencyData(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("My Profile"),
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).cardColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          floatingActionButton: FloatingActionButton(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController.value * 2 * math.pi,
                  child: Opacity(
                    opacity: _animationController.value == 1
                        ? 1.0
                        : 1 - (_animationController.value * 0.5),
                    child: child,
                  ),
                );
              },
              child: Icon(
                state is EditableProfilePage ? Icons.save : Icons.edit,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              if (state is EditableProfilePage) {
                if (!_formKey.currentState.validate()) return;
                BlocProvider.of<ProfileBloc>(context).add(
                  ProfileSaved(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    defaultCurrency: _defaultCurrencyController.text,
                    phoneNumber: _phoneNumberController.text,
                    pictureUrl: _photoUrlController.text,
                  ),
                );
              } else if (state is ProfilePageLoaded ||
                  state is ProfileChangeSuccess) {
                _animationController.forward();
                BlocProvider.of<ProfileBloc>(context).add(EditProfile());
              }
            },
          ),
          body: Builder(
            builder: (context) => ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(35.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: screenHeight * 0.064472681),
                      GestureDetector(
                        onTap: editable
                            ? () {
                                Feedback.forTap(context);
                                showDialog(
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AvatarPicker(
                                        pictureUrlController:
                                            _photoUrlController);
                                  },
                                  context: context,
                                );
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).primaryColorDark,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.25),
                                  blurRadius: 15.0,
                                  offset: Offset(5.0, 5.0),
                                  spreadRadius: 2.0,
                                )
                              ]),
                          child: Hero(
                            tag: "profile",
                            child: CircleAvatar(
                              radius: screenHeight * 0.055590851, // 50
                              child: FadeInImage(
                                placeholder:
                                    AssetImage('assets/icons/misc/loader.png'),
                                image: FirebaseImage(_photoUrlController.text),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.075),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Builder(
                  builder: (context) => BlocListener<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileChangeFailure) {
                        context.showSnackBar(state.message);
                      } else if (state is ProfileChangeSuccess) {
                        Navigator.of(context).pop();
                        editable = false;
                        _animationController.reverse();

                        currencySymbol = getCurrencySymbol(
                          currencyData: _currencyData,
                          currencyCode: _defaultCurrencyController.text,
                        );

                        context.showSnackBar("Profile updated Successfully");
                      } else if (state is ProfilePageLoading) {
                        showProgress(context);
                      } else if (state is EditableProfilePage) {
                        editable = true;
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) => Opacity(
                        opacity: _opacityAnimation.value + 0.75,
                        child: child,
                      ),
                      child: MyProfileForm(
                        enabled: editable,
                        formKey: _formKey,
                        defaultCurrencyController: _defaultCurrencyController,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        phoneNumberController: _phoneNumberController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyProfileForm extends StatelessWidget {
  MyProfileForm({
    @required GlobalKey<FormState> formKey,
    @required this.firstNameController,
    @required this.lastNameController,
    @required this.phoneNumberController,
    @required this.defaultCurrencyController,
    @required this.enabled,
  })  : _formKey = formKey,
        assert(formKey != null);
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController defaultCurrencyController;
  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  final _phoneNode = FocusNode();
  final _currencyNode = FocusNode();
  final bool enabled;
  final GlobalKey<FormState> _formKey;
  final _validator = Validator();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.044472681), // 40
            CustomTextFormField(
              currentNode: _firstNameNode,
              nextNode: _lastNameNode,
              textInputAction: TextInputAction.next,
              enabled: enabled,
              maxLines: 1,
              fieldController: firstNameController,
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
              enabled: enabled,
              maxLines: 1,
              fieldController: lastNameController,
              hintText: 'Last Name',
              prefixImage: 'assets/icons/auth_icons/lastName.svg',
              keyboardType: TextInputType.text,
              validator: _validator.validateCanBeEmptyText,
            ),
            SizedBox(height: screenHeight * 0.024459975), // 22
            CustomTextFormField(
              currentNode: _phoneNode,
              nextNode: _currencyNode,
              textInputAction: TextInputAction.next,
              enabled: enabled,
              maxLines: 1,
              fieldController: phoneNumberController,
              hintText: 'Phone Number',
              prefixImage: 'assets/icons/auth_icons/phone.svg',
              keyboardType: TextInputType.phone,
              validator: _validator.validatePhoneNumber,
              inputFormatters: isInternational
                  ? []
                  : [DialCodeFormatter(Locale('en', 'IN'))],
            ),
            SizedBox(height: screenHeight * 0.024459975), // 22
            CurrencyFormField(
              defaultCurrencyCodeController: defaultCurrencyController,
              currentNode: _currencyNode,
              enabled: enabled,
            )
          ],
        ),
      ),
    );
  }
}
