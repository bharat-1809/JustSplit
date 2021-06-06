import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    @required TextEditingController fieldController,
    @required String hintText,
    @required String prefixImage,
    @required TextInputType keyboardType,
    FocusNode currentNode,
    FocusNode nextNode,
    bool obscureText,
    bool enabled,
    Widget suffix,
    TextCapitalization textCsdktalization,
    List<TextInputFormatter> inputFormatters,
    @required TextInputAction textInputAction,
    @required String Function(String) validator,
    @required int maxLines,
  })  : _fieldController = fieldController,
        _hintText = hintText,
        _currentNode = currentNode,
        _nextNode = nextNode,
        _textInputAction = textInputAction,
        _keyboardType = keyboardType,
        _obscureText = obscureText,
        _prefixImage = prefixImage,
        _validator = validator,
        _maxLines = maxLines,
        _suffix = suffix,
        _textCsdktalization = textCsdktalization,
        _inputFormatters = inputFormatters,
        _enabled = enabled;

  final TextEditingController _fieldController;
  final String _hintText;
  final String _prefixImage;
  final TextInputType _keyboardType;
  final bool _obscureText;
  final String Function(String) _validator;
  final int _maxLines;
  final bool _enabled;
  final Widget _suffix;
  final TextInputAction _textInputAction;
  final FocusNode _currentNode;
  final FocusNode _nextNode;
  final List<TextInputFormatter> _inputFormatters;
  final TextCapitalization _textCsdktalization;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        focusNode: _currentNode,
        onFieldSubmitted: (value) {
          if (_currentNode != null) {
            _currentNode.unfocus();
            FocusScope.of(context).requestFocus(_nextNode);
          }
        },
        textInputAction: _textInputAction,
        enabled: _enabled ?? true,
        maxLines: _maxLines,
        controller: _fieldController,
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: _keyboardType,
        obscureText: _obscureText ?? false,
        validator: _validator,
        textCapitalization: _textCsdktalization ?? TextCapitalization.none,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.caption.copyWith(
              fontSize: screenHeight * 0.015565438, // 14
            ),
        inputFormatters: _inputFormatters,
        decoration: InputDecoration(
          suffixIcon: _suffix,
          border: kInputBorderStyle,
          focusedBorder: kInputBorderStyle,
          enabledBorder: kInputBorderStyle,
          hintStyle: Theme.of(context).textTheme.caption.copyWith(
                fontSize: screenHeight * 0.015565438, // 14
              ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.036458333,
              vertical: screenHeight * 0.021124524), // h=15, v=19
          hintText: _hintText,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.036458333), // 15
            child: SvgPicture.asset(
              _prefixImage,
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
