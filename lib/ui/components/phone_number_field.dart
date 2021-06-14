import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/theme/app_themes.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberField extends StatelessWidget {
  PhoneNumberField({
    Key key,
    @required this.phoneController,
    @required this.focusNode,
    this.hintText = 'Phone Number',
    this.nextFocusNode,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    String initialPhone,
  })  : initialPhoneNumber = !isInternational
            ? PhoneNumber(isoCode: 'IN', phoneNumber: initialPhone)
            : PhoneNumber(isoCode: 'US', phoneNumber: initialPhone),
        super(key: key);

  final TextEditingController phoneController;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool enabled;
  final TextInputAction textInputAction;
  final String hintText;
  final PhoneNumber initialPhoneNumber;
  final TextEditingController _numberController = TextEditingController();

  final _localDarkTheme = darkTheme.copyWith(
    textSelectionTheme: darkTheme.textSelectionTheme.copyWith(
      cursorColor: darkTheme.primaryColor,
    ),
    textTheme: darkTheme.textTheme.copyWith(
      subtitle1: darkTheme.textTheme.caption,
    ),
  );
  final _localLightTheme = lightTheme.copyWith(
    textSelectionTheme: lightTheme.textSelectionTheme.copyWith(
      cursorColor: lightTheme.primaryColor,
    ),
    textTheme: lightTheme.textTheme.copyWith(
      subtitle1: lightTheme.textTheme.caption,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).brightness == Brightness.dark ? _localDarkTheme : _localLightTheme,
      child: InternationalPhoneNumberInput(
        onInputChanged: (number) {
          phoneController.text = number.phoneNumber;
        },
        textFieldController: _numberController,
        focusNode: focusNode,
        onFieldSubmitted: (value) {
          if (focusNode != null) {
            focusNode.unfocus();
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        spaceBetweenSelectorAndTextField: 0.0,
        selectorTextStyle:
            Theme.of(context).textTheme.caption.copyWith(fontSize: screenHeight * 0.015565438),
        formatInput: true,
        initialValue: initialPhoneNumber,
        hintText: hintText,
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        textAlignVertical: TextAlignVertical.center,
        validator: Validator().validateShortPhoneNumber,
        isEnabled: enabled,
        cursorColor: Theme.of(context).primaryColor,
        keyboardAction: textInputAction,
        keyboardType: TextInputType.number,
        textStyle:
            Theme.of(context).textTheme.caption.copyWith(fontSize: screenHeight * 0.015565438),
        searchBoxDecoration: InputDecoration(
          labelText: 'Search by country name or dial code',
          labelStyle:
              Theme.of(context).textTheme.caption.copyWith(fontSize: screenHeight * 0.015565438),
          contentPadding: const EdgeInsets.all(8.0),
        ),
        inputDecoration: InputDecoration(
          border: kInputBorderStyle,
          focusedBorder: kInputBorderStyle,
          enabledBorder: kInputBorderStyle,
          hintStyle: Theme.of(context).textTheme.caption.copyWith(
                fontSize: screenHeight * 0.015565438, // 14
              ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.036458333,
              vertical: screenHeight * 0.021124524), // h=15, v=19
          hintText: hintText,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.036458333), // 15
            child: SvgPicture.asset(
              'assets/icons/auth_icons/phone.svg',
              color: Theme.of(context).primaryColor,
              height: screenWidth * 0.055902778, // 23
              width: screenWidth * 0.055902778, // 23
            ),
          ),
        ),
      ),
    );
  }
}
