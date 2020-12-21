import 'dart:convert';

import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/logger.dart';
import 'package:contri_app/ui/components/customFormField.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:flutter/material.dart';

class CurrencyFormField extends StatefulWidget {
  final TextEditingController defaultCurrencyCodeController;
  final FocusNode currentNode;
  final bool enabled;
  final FocusNode nextNode;

  CurrencyFormField({
    @required this.defaultCurrencyCodeController,
    @required this.currentNode,
    @required this.enabled,
    this.nextNode,
  });
  @override
  _CurrencyFormFieldState createState() => _CurrencyFormFieldState();
}

class _CurrencyFormFieldState extends State<CurrencyFormField> {
  List<Currency> _currencies = [];
  final _validator = Validator();

  Future<void> _getCurrencyCodes() async {
    final _data = await getCurrencyData(context);
    List<Currency> _currList = [];
    _data.forEach((key, value) {
      _currList.add(
        Currency(
          name: value["name"],
          code: value["code"],
          symbol: value["symbol_native"],
        ),
      );
    });

    setState(() {
      _currencies = _currList;
    });
  }

  Widget _currencySelector() {
    return AlertDialog(
      scrollable: true,
      title: Text(
        "Select Currency",
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontSize: screenHeight * 0.0225),
      ),
      content: Container(
        width: screenWidth * 0.80,
        height: screenHeight * 0.80,
        child: ListView.builder(
          itemCount: _currencies.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 2.0,
              ),
              onTap: () {
                setState(() {
                  widget.defaultCurrencyCodeController.text =
                      _currencies[index].code;
                });

                Navigator.of(context).pop();
              },
              title: Text(
                _currencies[index].code,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: screenHeight * 0.0175,
                    ),
              ),
              subtitle: Text(
                _currencies[index].name,
              ),
              trailing: Text(
                _currencies[index].symbol,
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: screenHeight * 0.02,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await _getCurrencyCodes();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      textInputAction: TextInputAction.done,
      enabled: widget.enabled,
      maxLines: 1,
      currentNode: widget.currentNode,
      nextNode: widget.nextNode,
      textCapitalization: TextCapitalization.characters,
      suffix: IconButton(
        icon: Icon(Icons.arrow_drop_down),
        onPressed: () {
          logger.wtf("Currency Selector");
          showDialog(
            context: context,
            builder: (context) => _currencySelector(),
          );
        },
      ),
      fieldController: widget.defaultCurrencyCodeController,
      hintText: 'Default Currency Code',
      prefixImage: 'assets/icons/auth_icons/currency.svg',
      keyboardType: TextInputType.text,
      validator: _validator.validateNonEmptyText,
    );
  }
}

Future<Map<String, dynamic>> getCurrencyData(BuildContext context) async {
  final String _rawData = await DefaultAssetBundle.of(context).loadString(
    'assets/country_codes.json',
  );
  final Map<String, dynamic> _data = JsonDecoder().convert(_rawData);

  return _data;
}

String getCurrencySymbol(
    {@required Map<String, dynamic> currencyData, String currencyCode}) {
  final _currencyCode = currencyCode ?? globalUser.defaultCurrency;
  String _symbol;
  currencyData.forEach((key, value) {
    if (key == _currencyCode) {
      _symbol = value["symbol_native"];
    }
  });

  return _symbol ?? "\u20b9";
}

class Currency {
  const Currency({
    @required this.name,
    @required this.code,
    @required this.symbol,
  });
  final String code;
  final String name;
  final String symbol;

  Map<String, String> toJson() {
    return {
      "name": name,
      "code": code,
      "symbol": symbol,
    };
  }

  Currency.fromJson(Map<String, String> json)
      : name = json["name"],
        code = json["code"],
        symbol = json["symbol"];
}
