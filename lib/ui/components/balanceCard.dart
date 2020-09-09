import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _greenGradient = LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primaryVariant,
      ],
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    );
    final _redGradient = LinearGradient(
      colors: [
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.secondaryVariant,
      ],
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    );

    Text _displayBalance(double netBalance) {
      String _text;
      if (netBalance > 0)
        _text =
            "You owe $currencySymbol ${netBalance.abs().toStringAsFixed(2)}";
      else if (netBalance < 0)
        _text =
            "You are owed $currencySymbol ${netBalance.abs().toStringAsFixed(2)}";
      else
        _text = "You are all Settled Up";

      return Text(
        _text,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: screenHeight * 0.018012706,
            ),
      );
    }

    return Container(
      width: screenWidth * 0.925402778,
      height: screenHeight * 0.210133418, // 189
      child: Container(
        height: screenHeight * 0.210133418, // 189
        // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.036458333), // 15
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.030458333 * 2),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          gradient: totalBalance > 0.0 ? _redGradient : _greenGradient,
          boxShadow: [
            BoxShadow(
              color: totalBalance > 0.0
                  // I owe this much {balance}, so if balance > 0, i owe else if balance < 0, i am owed
                  ? Theme.of(context)
                      .colorScheme
                      .secondaryVariant
                      .withOpacity(0.25)
                  : Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity(0.25),
              blurRadius: 15.0,
              offset: Offset(3.0, 5.0),
              spreadRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi",
              style: Theme.of(context).textTheme.headline2.copyWith(
                    fontSize: screenHeight * 0.027795426, // 25
                  ),
            ),
            Text(
              globalUser.firstName,
              style: Theme.of(context).textTheme.headline2.copyWith(
                    fontSize: screenHeight * 0.027795426, // 25
                  ),
            ),
            SizedBox(height: screenHeight * 0.031013596), // 35
            Text(
              "Total Balance",
              style: Theme.of(context).textTheme.headline2.copyWith(
                    fontSize: screenHeight * 0.019512706, // 18
                  ),
            ),
            SizedBox(height: screenHeight * 0.001),
            _displayBalance(totalBalance),
          ],
        ),
      ),
    );
  }
}
