import 'package:contri_app/sdk/models/expense_model/expense_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/addExpTextFields.dart';
import 'package:contri_app/ui/components/bottomBarItem.dart';
import 'package:contri_app/ui/components/bottom_button.dart';
import 'package:contri_app/ui/components/commentsDialogBox.dart';
import 'package:contri_app/ui/components/general_dialog.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/components/userTile_addExpPage.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:contri_app/ui/screens/edit_expense_page/bloc/editexp_bloc.dart';
import 'package:contri_app/ui/screens/edit_expense_page/comments_bloc/bloc/comments_bloc.dart';
import 'package:contri_app/ui/screens/edit_expense_page/date_bloc/bloc/date_bloc.dart';
import 'package:contri_app/ui/screens/edit_expense_page/group_name_bloc/bloc/groupname_bloc.dart';
import 'package:contri_app/ui/screens/edit_expense_page/splitDropdown_bloc/bloc/splitdropdown_bloc.dart';
import 'package:contri_app/ui/screens/home_page/home_page.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditExpensePage extends StatelessWidget {
  static const String id = "edit_expense_page";
  @override
  Widget build(BuildContext context) {
    final Expense args = ModalRoute.of(context).settings.arguments;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EditexpBloc(),
        ),
        BlocProvider(
          create: (context) =>
              DateBloc()..add(DateChanged(dateTime: DateTime.parse(args.date))),
        ),
        BlocProvider(
          create: (context) =>
              GroupnameBloc()..add(GroupNameChanged(groupId: args.groupId)),
        ),
        BlocProvider(
          create: (context) => CommentsBloc(),
        ),
        BlocProvider(
          create: (context) => SplitdropdownBloc()
            ..add(SplitDropdownRequested(initialValue: args.splitType)),
        ),
      ],
      child: EditExpMainBody(argument: args),
    );
  }
}

// ignore: must_be_immutable
class EditExpMainBody extends StatelessWidget {
  final Expense argument;
  EditExpMainBody({@required this.argument});
  final _costTextController = TextEditingController();
  final _expNameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _comments = [];
  String _splitType;
  DateTime _dateTime;
  @override
  Widget build(BuildContext context) {
    // Sets initial value of text fields and comments
    _costTextController.text = argument.cost.abs().toString();
    _expNameTextController.text = argument.description;
    argument.comments.forEach((element) {
      _comments.add(element);
    });
    _dateTime = DateTime.parse(argument.date);

    return Scaffold(
      appBar: _buildAppBar(context, onSaveTap: () {
        if (!_formKey.currentState.validate()) return;
        BlocProvider.of<EditexpBloc>(context).add(
          SaveButtonClicked(
            oldExpense: argument,
            expenseId: argument.id,
            description: _expNameTextController.text,
            cost: double.parse(_costTextController.text),
            payeeId: argument.groupId == null ? argument.to : argument.groupId,
            isGroupExpense: argument.groupId != null,
            dateTime: _dateTime,
            comments: _comments,
            splitType: _splitType,
          ),
        );
      }),
      bottomNavigationBar: _buildBottomBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BottomButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => GeneralDialog(
                    title: "Delete Expense",
                    onPressed: () {
                      BlocProvider.of<EditexpBloc>(context).add(
                        DeleteExpense(expenseId: argument.id),
                      );

                      Navigator.of(dialogContext).pop();
                    },
                    content: "Do you really want to delete the expense?",
                    proceedButtonText: "Delete"),
              );
            },
            text: "Delete Expense",
            textColor: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: screenWidth * 0.035),
          BottomButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => GeneralDialog(
                    title: "Settle Up",
                    onPressed: () {
                      BlocProvider.of<EditexpBloc>(context).add(
                        SaveButtonClicked(
                          oldExpense: argument,
                          expenseId: argument.id,
                          description: _expNameTextController.text,
                          cost: 0.0, // SETTLE UP EXPENSE
                          payeeId: argument.groupId == null
                              ? argument.to
                              : argument.groupId,
                          isGroupExpense: argument.groupId != null,
                          dateTime: _dateTime,
                          comments: _comments,
                          splitType: _splitType,
                        ),
                      );

                      Navigator.of(dialogContext).pop();
                    },
                    content: "Do you want to settle up this expense?",
                    proceedButtonText: "Settle Up"),
              );
            },
            text: "Settle Up",
            textColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: Builder(
        builder: (context) => BlocConsumer<EditexpBloc, EditexpState>(
          listener: (context, state) {
            if (state is EditExpFailed) {
              context.showSnackBar(state.message);
            }
            if (state is EditExpLoading) {
              showProgress(context);
            }
            if (state is EditExpSuccess) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacementNamed(HomePage.id);
            }
          },
          builder: (context, state) {
            return BlocListener<DateBloc, DateState>(
              listener: (context, state) {
                if (state is DateState) {
                  _dateTime = state.dateTime;
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.055611111), // 20
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.027795426), // 25
                      Text(
                        "Edit Expense",
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: screenHeight * 0.033354511, // 30
                            ),
                      ),
                      SizedBox(height: screenHeight * 0.027795426), // 25
                      Container(
                        margin: EdgeInsets.only(
                            left: screenWidth * 0.017305556), // 10
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "With you and ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontSize:
                                            screenHeight * 0.016677255, // 15
                                      ),
                                ),
                                SizedBox(
                                    width: screenWidth * 0.036458333), // 15
                                Builder(
                                  builder: (context) {
                                    if (argument.groupId == null) {
                                      final friend = getCurrentFriends
                                          .firstWhere((element) =>
                                              element.id == argument.to);
                                      return UserTile(
                                        name:
                                            "${friend.friend.firstName + ' ' + friend.friend.lastName}",
                                        id: friend.id,
                                        photoUrl: friend.friend.pictureUrl ??
                                            "${expenseAvatars[0]}",
                                      );
                                    } else {
                                      // Updates the spliting type list when a group expense is selected
                                      BlocProvider.of<SplitdropdownBloc>(
                                              context)
                                          .add(
                                        SplitDropdownRequested(
                                            isGroupExpense: true),
                                      );
                                      final group = getCurrentGroups.firstWhere(
                                          (element) =>
                                              element.id == argument.groupId);
                                      return UserTile(
                                        name: group.name,
                                        id: group.id,
                                        photoUrl: group.pictureUrl ??
                                            "${expenseAvatars[0]}",
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                            AddExpForm(
                              pictureUrl: argument.pictureUrl,
                              formKey: _formKey,
                              descriptionTextController: _expNameTextController,
                              costController: _costTextController,
                            ),
                            SizedBox(height: screenHeight * 0.016677255),
                            RichText(
                              text: TextSpan(
                                text: "***",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: screenHeight * 0.011786429,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).errorColor,
                                    ),
                                children: [
                                  TextSpan(
                                    text:
                                        "  Split type is with respect to creator of expense",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize: screenHeight * 0.011786429,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color
                                              .withOpacity(0.75),
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            BlocBuilder<SplitdropdownBloc, SplitdropdownState>(
                                builder: (context, state) {
                              _splitType = state.value;

                              return DropdownButton(
                                value: state.value,
                                items: state.splitList
                                    .map<DropdownMenuItem>(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                fontSize:
                                                    screenHeight * 0.015565438,
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                underline: Container(),
                                onChanged: (value) {
                                  BlocProvider.of<SplitdropdownBloc>(context)
                                      .add(ChangeSplitDropdown(
                                    newValue: value,
                                    splitList: state.splitList,
                                  ));
                                },
                              );
                            }),
                            SizedBox(height: screenHeight * 0.027795426), // 25
                            Text(
                              "COMMENTS: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                    fontSize: screenHeight * 0.033354511 * 0.5,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color
                                        .withOpacity(0.75),
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            SizedBox(height: screenHeight * 0.020795426), // 25
                            BlocConsumer<CommentsBloc, CommentsState>(
                              listener: (context, state) {
                                _comments.add(state.comment);
                              },
                              builder: (context, state) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: screenWidth * 0.036458333), // 15
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: _comments
                                        .map<Padding>(
                                          (item) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: (screenHeight *
                                                        0.033354511) /
                                                    5),
                                            child: Text(
                                              "# $item",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                    fontSize: screenHeight *
                                                        0.015677255,
                                                  ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildAppBar(BuildContext context, {@required Function onSaveTap}) {
  return AppBar(
    leading: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
    actions: [
      FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onSaveTap,
        child: Center(
          child: Text(
            "SAVE",
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: screenHeight * 0.020012706, // 18
                ),
          ),
        ),
      )
    ],
  );
}

Widget _buildBottomBar(BuildContext context) {
  final commentsController = TextEditingController();
  final commentsFormKey = GlobalKey<FormState>();
  return BottomAppBar(
    color: Theme.of(context).primaryColor,
    child: Container(
      height: screenHeight * 0.066709022,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<DateBloc, DateState>(
            builder: (context, state) {
              return BottomBarItem(
                name: state.dateTime.day == DateTime.now().day
                    ? "TODAY"
                    : "${state.dateTime.day.toString() + ' / ' + state.dateTime.month.toString() + ' / ' + state.dateTime.year.toString()}",
                image: "assets/icons/bottom_bar/calendar.svg",
                onTap: () async {
                  DateTime _date = await showDatePicker(
                    context: context,
                    initialDate: state.dateTime,
                    firstDate: DateTime(2020, 1, 1, 12, 00),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: Theme.of(context).primaryColor,
                                primaryVariant: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.7),
                              )),
                      child: child,
                    ),
                  );
                  BlocProvider.of<DateBloc>(context)
                      .add(DateChanged(dateTime: _date ?? state.dateTime));
                },
              );
            },
          ),
          BlocBuilder<GroupnameBloc, GroupnameState>(
            builder: (context, state) {
              return BottomBarItem(
                name: state.groupName.toUpperCase(),
                image: "assets/icons/bottom_bar/group.svg",
                onTap: null,
              );
            },
          ),
          Builder(
            builder: (context) => BottomBarItem(
              name: "RECEIPT",
              image: "assets/icons/bottom_bar/receipt.svg",
              onTap: () {
                context.showSnackBar(
                    "This feature is in production! Please wait for the developers to cook this recipe :)");
              },
            ),
          ),
          BottomBarItem(
            name: "COMMENTS",
            image: "assets/icons/bottom_bar/notes.svg",
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AddCommentsBox(
                  onAddTap: () {
                    if (!commentsFormKey.currentState.validate()) return;
                    BlocProvider.of<CommentsBloc>(context).add(
                      CommentAdded(
                        comment: commentsController.text,
                      ),
                    );
                    commentsController.clear();
                    Navigator.of(dialogContext).pop();
                  },
                  onCancelTap: () {
                    Navigator.of(dialogContext).pop();
                  },
                  textController: commentsController,
                  formKey: commentsFormKey,
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

class AddExpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController descriptionTextController;
  final TextEditingController costController;
  final String pictureUrl;
  AddExpForm(
      {@required this.formKey,
      @required this.pictureUrl,
      @required this.descriptionTextController,
      @required this.costController});

  final _validator = Validator();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.027795426), // 25
          AddExpTextField(
            currencyField: false,
            hintText: "Enter a description",
            image: FirebaseImage(pictureUrl ?? expenseAvatars[0]),
            textController: descriptionTextController,
            validator: _validator.validateNonEmptyText,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: screenHeight * 0.027795426), // 25
          AddExpTextField(
            currencyField: true,
            hintText: "0.0",
            currencyImage: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/icons/misc/currency.svg',
                height: 0.036370412 * screenHeight,
                width: 0.036370412 * screenHeight,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
            keyboardType: TextInputType.number,
            textController: costController,
            validator: _validator.validateCost,
          ),
          SizedBox(height: screenHeight * 0.044472681), // 40
        ],
      ),
    );
  }
}
