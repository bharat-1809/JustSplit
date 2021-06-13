import 'package:contri_app/sdk/functions/friends_functions.dart';
import 'package:contri_app/ui/components/customPopMenuItem.dart';
import 'package:contri_app/ui/components/general_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FriendsOptionsPopButton extends StatelessWidget {
  final String friendId;
  final String friendName;
  final Function onRemove;
  final Function onReminder;

  FriendsOptionsPopButton({
    @required this.friendId,
    @required this.friendName,
    @required this.onRemove,
    @required this.onReminder,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).cardColor,
      ),
      itemBuilder: (_) {
        List<CustomPopItem> _items = [
          CustomPopItem(
            title: "Remove Friend",
          ),
          CustomPopItem(
            title: "Send Reminder",
          ),
        ];

        Iterable<PopupMenuItem> _list = _items.map((e) => PopupMenuItem(
              child: e,
              value: e.title.toLowerCase(),
            ));

        return _list.toList();
      },
      onSelected: (value) {
        if (value == "remove friend") {
          if (FriendFunctions.canDeleteFriend(id: friendId)) {
            showDialog(
              context: context,
              builder: (context) => GeneralDialog(
                title: "Remove $friendName ?",
                onPressed: onRemove,
                content:
                    "This will remove this user from your friends list, and delete any non-group expenses you two have shared.\n\nThey won't receive an email or push notification.",
                proceedButtonText: "REMOVE",
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => GeneralDialog(
                title: "You have shared groups",
                onPressed: () {
                  Navigator.of(context).pop();
                },
                content: 'You cannot delete this person from your friends list, as you have a shared group with them',
                    // Make this as the message when delete frined from group is avialble "If you wish to delete this person from your friends list, you will need to delete them from your groups, or remove the groups entirely.\n\nYou can access these settings by tapping on the group settings.",
                proceedButtonText: "OK",
                showCancel: false,
              ),
            );
          }
        } else if (value == "send reminder") {
          onReminder.call();
        }
      },
      tooltip: "Options",
    );
  }
}
