import 'dart:math';

import 'package:contri_app/sdk/functions/friends_functions.dart';
import 'package:contri_app/sdk/models/friend_model/friend_model.dart';
import 'package:contri_app/sdk/models/user_model/user_model.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/addExpTextFields.dart';
import 'package:contri_app/ui/components/addNewFriend.dart';
import 'package:contri_app/ui/components/bottomBarItem.dart';
import 'package:contri_app/ui/components/commentsDialogBox.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:contri_app/ui/components/userTile_addExpPage.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/validators.dart';
import 'package:contri_app/ui/screens/home_page/home_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/bloc/addexp_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/comments_bloc/bloc/comments_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/date_bloc/bloc/date_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/groupname_bloc/bloc/groupname_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/nameDropdown_bloc/bloc/namedropdown_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/splitDropdown_bloc/bloc/splitdropdown_bloc.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';
import 'package:flutter_svg/flutter_svg.dart';

ScreenArguments args;

class AddExpensePage extends StatelessWidget {
  static const String id = "add_expense_page";

  @override
  Widget build(BuildContext context) {
    // Arguments (if any)
    args = ModalRoute.of(context).settings.arguments;

    return BlocProvider(
      create: (context) => AddexpBloc()..add(AddexpRequested()),
      child: AddexpIntermediate(),
    );
  }
}

class AddexpIntermediate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AddexpBloc, AddexpState>(
      listener: (context, state) {
        if (state is RequestingAddExpMainPage) {
          Navigator.of(context).pushReplacementNamed(HomePage.id);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddexpIntermediateBody(),
            settings: RouteSettings(
              name: "add_expense_main_page",
            ),
          ));
        }
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}

class AddexpIntermediateBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddexpBloc(),
        ),
        BlocProvider(
          create: (context) => NamedropdownBloc()
            ..add(
                NameDropdownRequested(initialNameDropdownValue: args ?? null)),
        ),
        BlocProvider(
          create: (context) =>
              SplitdropdownBloc()..add(SplitDropdownRequested()),
        ),
        BlocProvider(
          create: (context) => DateBloc(),
        ),
        BlocProvider(
          create: (context) => GroupnameBloc(),
        ),
        BlocProvider(
          create: (context) => CommentsBloc(),
        ),
      ],
      child: AddExpMainBody(),
    );
  }
}

// ignore: must_be_immutable
class AddExpMainBody extends StatelessWidget {
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _newFriendFirstNameController = TextEditingController();
  final _newFriendLastNameController = TextEditingController();
  final _newFriendPhoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _addNewFriendFormKey = GlobalKey<FormState>();
  String _payeeUser = " ";
  DateTime _date = DateTime.now().toLocal();
  List<String> _comments = [];
  String _splitType;
  bool _isGroupExpense = false;
  int avatarIndex;

  @override
  Widget build(BuildContext context) {
    avatarIndex = Random().nextInt(expenseAvatars.length);

    return Scaffold(
      bottomNavigationBar: _buildBottomBar(context),
      appBar: _buildAppBar(
        context,
        onSaveTap: () {
          if (!_formKey.currentState.validate())
            return;
          else if (_payeeUser == kAddFriendId)
          // This ensures that expense is not added against a NULL user
          {
            context.showSnackBar('Oops!! No friend selected');
            return;
          } else {
            BlocProvider.of<AddexpBloc>(context).add(
              SaveButtonClicked(
                payerId: globalUser.id,
                payeeId: _payeeUser,
                expenseName: _descriptionController.text,
                amount: double.parse(_costController.text),
                dateTime: _date,
                splittingType: _splitType,
                isGroupExpense: _isGroupExpense,
                comments: _comments,
                photoUrl: expenseAvatars[avatarIndex],
              ),
            );
          }
        },
      ),
      body: BlocConsumer<AddexpBloc, AddexpState>(
        listener: (context, state) {
          if (state is AddexpFailure) {
            context.showSnackBar(state.message);
          } else if (state is AddExpInProgress) {
            showProgress(context);
          } else if (state is AddExpSuccess) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacementNamed(HomePage.id);
          }
        },
        builder: (context, state) {
          return BlocListener<DateBloc, DateState>(
            listener: (context, state) {
              if (state is DateState) {
                _date = state.dateTime;
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
                      "Add Expense",
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
                              SizedBox(width: screenWidth * 0.036458333), // 15
                              BlocConsumer<NamedropdownBloc, NamedropdownState>(
                                listener: (context, state) {
                                  if (state is NameDropdownChangeFailure) {
                                    context.showSnackBar(state.message);
                                  } else if (state is AddingNewFriend) {
                                    String newFriendId;
                                    showDialog(
                                      context: context,
                                      builder: (context) => AddNewFriendDialog(
                                        firstNameController:
                                            _newFriendFirstNameController,
                                        lastNameController:
                                            _newFriendLastNameController,
                                        phoneNumberController:
                                            _newFriendPhoneNumberController,
                                        formKey: _addNewFriendFormKey,
                                        onPressed: () async {
                                          if (!_addNewFriendFormKey.currentState
                                              .validate()) return;
                                          showProgress(context);
                                          final _friend = Friend(
                                            friend: User(
                                              firstName:
                                                  _newFriendFirstNameController
                                                      .text,
                                              lastName:
                                                  _newFriendLastNameController
                                                          .text ??
                                                      "",
                                              phoneNumber:
                                                  _newFriendPhoneNumberController
                                                      .text,
                                              defaultCurrency:
                                                  globalUser.defaultCurrency,
                                              pictureUrl: userAvatars[Random()
                                                  .nextInt(userAvatars.length)],
                                            ),
                                          );
                                          newFriendId = await FriendFunctions
                                              .createFriend(friend: _friend);
                                          await loadFriends();
                                          Navigator.of(context)
                                              .pop(); // for popping progress indicator
                                          Navigator.of(context)
                                              .pop(); // for popping dialog box

                                          inviteFriend(
                                            context: context,
                                            phoneNumber:
                                                _newFriendPhoneNumberController
                                                    .text,
                                            firstName:
                                                _newFriendFirstNameController
                                                    .text,
                                          );

                                          BlocProvider.of<NamedropdownBloc>(
                                                  context)
                                              .add(
                                            ChangeNameDropdown(
                                              newValue: newFriendId,
                                              dropdownList: [
                                                UserTile(
                                                  name:
                                                      '${_newFriendFirstNameController.text + " " + _newFriendLastNameController.text}',
                                                  id: newFriendId,
                                                  photoUrl: userAvatars[Random()
                                                      .nextInt(
                                                          userAvatars.length)],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else if (state is NameDropdownChanged) {
                                    _payeeUser = state.value;
                                    _isGroupExpense = false;
                                    for (var group in getCurrentGroups) {
                                      if (state.value == group.id) {
                                        _isGroupExpense = true;
                                        BlocProvider.of<SplitdropdownBloc>(
                                                context)
                                            .add(
                                          SplitDropdownRequested(
                                              isGroupExpense: true),
                                        );
                                        BlocProvider.of<GroupnameBloc>(context)
                                            .add(
                                          UpdateGroupName(newName: group.name),
                                        );
                                      }
                                    }

                                    if (!_isGroupExpense)
                                      BlocProvider.of<GroupnameBloc>(context)
                                          .add(
                                        UpdateGroupName(newName: "NO GROUP"),
                                      );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is NameDropdownChanged) {
                                    return DropdownButton(
                                      underline: Container(),
                                      value: state.value,
                                      items: state.dropdownList
                                          .map<DropdownMenuItem>(
                                              (item) => DropdownMenuItem(
                                                    value: item.id,
                                                    child: item,
                                                  ))
                                          .toList(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize: screenHeight *
                                                0.016677255, // 15
                                          ),
                                      onChanged: (newValue) {
                                        BlocProvider.of<NamedropdownBloc>(
                                                context)
                                            .add(ChangeNameDropdown(
                                          newValue: newValue,
                                          dropdownList: state.dropdownList,
                                        ));
                                      },
                                    );
                                  } else {
                                    return Text(" ");
                                  }
                                },
                              ),
                            ],
                          ),
                          AddExpForm(
                            formKey: _formKey,
                            descriptionTextController: _descriptionController,
                            costController: _costController,
                            avatarIndex: avatarIndex,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _comments
                                      .map<Padding>(
                                        (item) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  (screenHeight * 0.033354511) /
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
    );
  }
}

class AddExpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController descriptionTextController;
  final TextEditingController costController;
  final int avatarIndex;
  AddExpForm({
    @required this.formKey,
    @required this.descriptionTextController,
    @required this.costController,
    @required this.avatarIndex,
  });

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
            image: FirebaseImage(expenseAvatars[avatarIndex]),
            textController: descriptionTextController,
            validator: _validator.validateNonEmptyText,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: screenHeight * 0.027795426), // 25
          AddExpTextField(
            currencyImage: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/icons/misc/currency.svg',
                height: 0.036370412 * screenHeight,
                width: 0.036370412 * screenHeight,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
            currencyField: true,
            hintText: "0.0",
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
                      .add(DateChanged(newDateTime: _date ?? DateTime.now()));
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
                  "This feature is in production! Please wait for the developers to cook this recipie :)",
                );
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
                      AddNewComment(
                        newComment: commentsController.text,
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

Widget _buildAppBar(BuildContext context, {@required Function onSaveTap}) {
  return AppBar(
    leading: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        args == null
            ? Navigator.of(context).pushReplacementNamed(HomePage.id)
            : Navigator.of(context).pop();
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
