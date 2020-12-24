import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/screens/home_page/pages/notes_page/bloc/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CommentTile extends StatelessWidget {
  final String comment;
  final String commentId;
  final DateTime dateTime;
  CommentTile(
      {@required this.commentId,
      @required this.comment,
      @required this.dateTime})
      : assert(comment != null),
        assert(commentId != null),
        assert(dateTime != null);

  /// list[0] = date, list[1] = time
  List<String> _convertDateTime(DateTime dateTime) {
    final _localDt = dateTime.toLocal();
    final _newDt = DateFormat.yMMMEd().format(_localDt);
    final _time = DateFormat.jm().format(_localDt);
    return [_newDt.toString(), _time.toString()];
  }

  @override
  Widget build(BuildContext context) {
    final _dateTime = _convertDateTime(dateTime);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: kBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withOpacity(0.030),
            offset: Offset(0.0, 5.0),
            blurRadius: 10,
            spreadRadius: 0.04,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          comment,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: screenHeight * 0.017565438, // 14
              ),
        ),
        subtitle: Text(
          "${_dateTime[0] + ' | ' + _dateTime[1]}",
          style: Theme.of(context).textTheme.headline4.copyWith(
                fontSize: screenHeight * 0.012235818,
              ),
        ),
        trailing: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/misc/bin.svg',
            color: Theme.of(context).primaryIconTheme.color.withOpacity(0.50),
            semanticsLabel: "Delete note button",
            height: screenHeight * 0.0225,
            width: screenHeight * 0.0225,
          ),
          onPressed: () {
            BlocProvider.of<NotesBloc>(context).add(
              DeleteComment(commentId: commentId),
            );
          },
        ),
      ),
    );
  }
}
