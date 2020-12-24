import 'package:contri_app/ui/components/app_legalese.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';

void showLegaleseDialog({
  @required BuildContext context,
  @required String name,
  @required String subtitle,
  @required Widget icon,
}) {
  showDialog(
    context: context,
    builder: (context) => Container(
      width: screenWidth * 0.75,
      child: LegaleseDialog(
        icon: icon,
        name: name,
        subtitle: subtitle,
      ),
    ),
  );
}

class LegaleseDialog extends StatelessWidget {
  final Widget icon;
  final String name;
  final String subtitle;
  LegaleseDialog(
      {@required this.icon, @required this.name, @required this.subtitle})
      : assert(icon != null),
        assert(subtitle != null),
        assert(name != null);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ListBody(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconTheme(data: Theme.of(context).iconTheme, child: icon),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        name,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                TermsAndConditions(),
              ],
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("CLOSE"),
        ),
      ],
      scrollable: true,
    );
  }
}
