import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final double balance;
  final String name;
  final String photoUrl;
  final String subTitle;
  final String heroTag;
  final String id;
  final bool isThreeLine;

  /// The object that passes as an argument
  final ScreenArguments argObject;
  CustomTile(
      {@required this.name,
      this.subTitle,
      this.heroTag,
      this.id,
      this.isThreeLine,
      @required this.balance,
      @required this.photoUrl,
      this.argObject})
      : assert(name != null),
        assert(balance != null),
        assert(photoUrl != null);
  @override
  Widget build(BuildContext context) {
    final _youOwe = Text(
      "you owe",
      style: Theme.of(context).textTheme.subtitle1.copyWith(
            fontSize: screenHeight * 0.015565438,
          ),
    );
    final _owesYou = Text(
      "you are owed",
      style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontSize: screenHeight * 0.015565438,
          ),
    );

    Text _oweOrOwedText(double netBalance) {
      if (netBalance > 0)
        return _youOwe;
      else if (netBalance < 0)
        return _owesYou;
      else
        return Text(
          "Settled Up",
          style: Theme.of(context).textTheme.headline4.copyWith(
                fontSize: screenHeight * 0.015565438,
              ),
        );
    }

    Widget _showBalanceOrNot(double netBalance) {
      if (netBalance == 0.0)
        return Container(
          height: 0.0,
          width: 0.0,
        );
      else
        return Text(
          "$currencySymbol ${netBalance.abs().toStringAsFixed(2)}",
          style: netBalance > 0
              ? Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: screenHeight * 0.015565438,
                  )
              : Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: screenHeight * 0.015565438,
                  ),
        );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: kBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withOpacity(0.04),
            offset: Offset(0.0, 5.0),
            blurRadius: 10,
            spreadRadius: 0.1,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02, vertical: screenHeight * 0.010),
        title: Text(
          name,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: screenHeight * 0.016565438, // 14
              ),
        ),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 0.5,
              color: Theme.of(context).primaryColorDark.withOpacity(0.70),
            ),
          ),
          child: Hero(
            tag: heroTag,
            flightShuttleBuilder: (flightContext, animation, flightDirection,
                    fromHeroContext, toHeroContext) =>
                Material(
              child: toHeroContext.widget,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200.0),
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.tealAccent,
              radius: screenHeight * 0.027239517, // 24.5
              child: FadeInImage(
                placeholder: AssetImage('assets/icons/misc/loader.png'),
                image: FirebaseImage(
                  photoUrl,
                  cacheRefreshStrategy: CacheRefreshStrategy.NEVER,
                ),
              ),
            ),
          ),
        ),
        subtitle: subTitle != null
            ? Text(
                subTitle,
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: screenHeight * 0.012229987,
                      fontWeight: FontWeight.w400,
                    ),
              )
            : null,
        isThreeLine: isThreeLine ?? false,
        dense: false,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _oweOrOwedText(balance),
            _showBalanceOrNot(balance),
          ],
        ),
      ),
    );
  }
}
