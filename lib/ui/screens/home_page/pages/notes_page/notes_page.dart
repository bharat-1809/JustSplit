import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/commentsDialogBox.dart';
import 'package:contri_app/ui/components/custom_appBar.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/screens/home_page/pages/notes_page/bloc/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:contri_app/extensions/snackBar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// ITS PERSONAL COMMENTS PAGE. Just The sdk was made with comment as its name.
class NotesPage extends StatelessWidget {
  static const String id = "notes_page";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc()..add(CommentsRequested()),
      child: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesFailure) {
            context.showSnackBar(state.message);
          }
          if (state is NotesSuccess) {
            Navigator.of(context).pop();
            BlocProvider.of<NotesBloc>(context).add(CommentsRequested());
          }
          if (state is NotesLoading) {
            showProgress(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: NotesPageBody(),
          );
        },
      ),
    );
  }
}

class NotesPageBody extends StatelessWidget {
  final _refreshController = RefreshController();
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoaded) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              CustomAppBar(
                height: screenHeight * 0.080740823,
                expandableHeight: screenHeight * 0.125740823,
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.050611111),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notes",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                fontSize: screenHeight * 0.033354511, // 30
                              ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0.0),
                          tooltip: "Add Comment",
                          icon: SvgPicture.asset(
                            "assets/icons/nav_bar/plus.svg",
                            color: Theme.of(context).primaryIconTheme.color,
                            height: 27.5,
                            width: 27.5,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AddCommentsBox(
                                onAddTap: () {
                                  if (!_formKey.currentState.validate()) return;

                                  BlocProvider.of<NotesBloc>(context).add(
                                      AddComment(
                                          comment: _commentController.text));
                                  Navigator.of(dialogContext).pop();
                                },
                                onCancelTap: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                textController: _commentController,
                                formKey: _formKey,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: SmartRefresher(
              physics: BouncingScrollPhysics(),
              controller: _refreshController,
              onRefresh: () async {
                await initializeComments;
                BlocProvider.of<NotesBloc>(context).add(CommentsRequested());
                _refreshController.refreshCompleted();
              },
              child: state.commentList.length > 0
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03), // 20
                      child: SingleChildScrollView(
                        child: Column(
                          children: state.commentList
                              .map((item) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.005),
                                    child: item,
                                  ))
                              .toList(),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/illustrations/add_notes.svg',
                            width: screenWidth * 0.80,
                          ),
                          SizedBox(height: screenHeight * 0.040236341),
                          Text(
                            "You haven't added any notes yet!\n",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
