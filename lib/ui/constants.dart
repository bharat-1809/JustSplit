import 'package:flutter/material.dart';

final kBorderRadius = BorderRadius.circular(7);

final kInputBorderStyle = OutlineInputBorder(
  borderRadius: kBorderRadius,
  borderSide: BorderSide(
    width: 1.0,
    color: Colors.grey[300].withOpacity(0.5),
  ),
);

final String kRazorpayKey = 'rzp_test_XACVmXwOI28T9l';

final String kAppVersion = "v1.0.1+110";

// The id of the dropdown item with name 'Add Friend' in add expenses page
// This is to ensure that if a user cancels the process of adding a friend then
// the expense should not be added
final String kAddFriendId = "add_friend";
