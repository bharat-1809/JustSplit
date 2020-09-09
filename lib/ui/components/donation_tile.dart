import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';

class DonationTile extends StatelessWidget {
  final String name;
  final String description;
  final int amount;
  final Function onClick;
  DonationTile(
      {@required this.name,
      @required this.description,
      @required this.amount,
      @required this.onClick})
      : assert(name != null),
        assert(description != null),
        assert(amount != null);

  String _getLocalizedAmount(int amount) {
    if (!isInternational) {
      return "\u20b9${amount.toString()}";
    } else {
      return "\$${amount / 10}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      elevation: 2.0,
      shadowColor: Theme.of(context).primaryColorDark.withOpacity(0.15),
      color: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).cardColor.withBlue(60).withRed(25)
          : Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: kBorderRadius,
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListBody(
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline3.copyWith(
                          fontSize: screenHeight * 0.021,
                        ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontSize: screenHeight * 0.015,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _getLocalizedAmount(amount),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: screenHeight * 0.016,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
