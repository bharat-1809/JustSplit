import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';

class CustomTileList extends StatelessWidget {
  final List<Widget> childrenList;

  CustomTileList({@required this.childrenList}) : assert(childrenList != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
              offset: Offset(0.5, -1.5),
              color: Theme.of(context).primaryColorDark.withOpacity(0.2),
              blurRadius: 0.5),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(top: screenHeight * 0.044472681), // 40
        margin:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.048611111), // 20
        color: Colors.transparent,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: childrenList,
        ),
      ),
    );
  }
}
