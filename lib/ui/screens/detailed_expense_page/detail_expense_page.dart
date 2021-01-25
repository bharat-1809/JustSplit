import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/logger.dart';
import 'package:contri_app/global/storage_constants.dart';
import 'package:contri_app/ui/components/custom_appBar.dart';
import 'package:contri_app/ui/components/general_dialog.dart';
import 'package:contri_app/ui/components/friendOptionsPopButton.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/screens/detailed_expense_page/bloc/detailexp_bloc.dart';
import 'package:contri_app/ui/screens/edit_expense_page/edit_expense_page.dart';
import 'package:contri_app/ui/screens/home_page/home_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/add_expense_page.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:contri_app/extensions/snackBar.dart';

class DetailExpPage extends StatelessWidget {
  static const String id = "detail_exp_page";
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return BlocProvider(
      create: (context) => DetailexpBloc()
        ..add(DetailExpPageRequested(
            argObject: args, isGroupExpDetail: args.group != null),),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              AddExpensePage.id,
              arguments: ScreenArguments(
                friend: args.friend,
                group: args.group,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              'assets/icons/nav_bar/plus.svg',
              color: Theme.of(context).cardColor,
              semanticsLabel: "Add Expense Button",
              width: screenHeight * 0.035,
              height: screenHeight * 0.035,
            ),
          ),
        ),
        body: DetailExpMainBody(arguments: args),
      ),
    );
  }
}

class DetailExpMainBody extends StatelessWidget {
  final ScreenArguments arguments;
  DetailExpMainBody({this.arguments});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailexpBloc, DetailexpState>(
        listener: (context, state) {
      if (state is DetailExpFailure) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        context.showSnackBar(state.message);
      } else if (state is DetailExpLoading) {
        showProgress(context);
      } else if (state is DetailExpSuccess) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushReplacementNamed(DetailExpPage.id, arguments: arguments);
      } else if (state is DeleteGroupSuccess) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed(
          HomePage.id,
          arguments: ScreenArguments(homeIndex: 1),
        );
      } else if (state is DeleteFriendSuccess) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed(HomePage.id);
      }
    }, builder: (context, state) {
      if (state is DetailexpInitialState) {
        return Container(
          width: screenWidth,
          child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              CustomAppBar(
                height: 200,
                expandableHeight: 350,
                child: DetailExpUpperBody(),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).cardColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  arguments.friend != null
                      ? FriendsOptionsPopButton(
                          friendId: arguments.friend.id,
                          friendName:
                              "${arguments.friend.friend.firstName + " " + arguments.friend.friend.lastName}",
                          onRemove: () {
                            BlocProvider.of<DetailexpBloc>(context).add(
                              DeleteFriend(friendId: arguments.friend.id),
                            );
                          },
                          onReminder: () {
                            // TODO: Add the send reminder functionality
                            context.showSnackBar(
                              "This recipe is being cooked. Please wait for the developer to cook this recipe.",
                            );
                          },
                        )
                      : Container(),
                ],
              )
            ],
            body: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
              padding: EdgeInsets.only(top: 15),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: state.widgetList
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(bottom: 11),
                          child: FlatButton(
                            padding: EdgeInsets.all(0.0),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                EditExpensePage.id,
                                arguments: item.argObject.expense,
                              );
                            },
                            child: item,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        );
      } else
        return Container(
          height: 0.0,
          width: 0.0,
        );
    });
  }
}

class DetailExpUpperBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailexpBloc, DetailexpState>(
        builder: (context, state) {
      if (state is DetailexpInitialState) {
        return Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.05667725), // 15
              Material(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(
                      width: 1.5, color: Theme.of(context).cardColor),
                ),
                child: Hero(
                  tag: "${state.id}",
                  child: CircleAvatar(
                    radius: screenHeight * 0.050031766, // 45
                    backgroundColor: Theme.of(context).cardColor.withAlpha(150),
                    child: FadeInImage(
                      imageErrorBuilder: (context, error, stackTrace) {
                        logger.w("Error in fetching Firebase image");
                        logger.e(state.pictureUrl);
                        logger.e(error);
                        return Image(
                            image: FirebaseImage(
                                state.pictureUrl ?? userAvatars[2]));
                      },
                      placeholder: AssetImage('assets/icons/misc/loader.png'),
                      image: FirebaseImage(state.pictureUrl ?? userAvatars[2]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.016677255), // 15
              Text(
                state.name,
                style: Theme.of(context).textTheme.headline2.copyWith(
                      fontSize: screenHeight * 0.017789072,
                    ),
              ),
              Builder(
                builder: (context) {
                  if (state.phoneNumber != null)
                    return Text(
                      state.phoneNumber,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: screenHeight * 0.01211817,
                          ),
                    );
                  else
                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                },
              ),
              SizedBox(height: screenHeight * 0.0090077255), // 15
              Text(
                state.netBalance > 0.0
                    ? "You owe ${state.name.split(" ")[0]} ${currencySymbol + state.netBalance.abs().toStringAsFixed(2)}"
                    : '"${state.name.split(" ")[0]}" owes you Rs.${state.netBalance.abs().toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: screenHeight * 0.015565438,
                    ),
              ),
              SizedBox(height: screenHeight * 0.040472681), // 25
              RaisedButton(
                elevation: 2.0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.013341804,
                  horizontal: screenWidth * 0.097297324,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => GeneralDialog(
                      title:
                          state.isGroupExpDetail ? "Delete Group" : "Settle Up",
                      onPressed: () async {
                        state.isGroupExpDetail
                            ? BlocProvider.of<DetailexpBloc>(context).add(
                                DeleteGroup(groupId: state.id),
                              )
                            : BlocProvider.of<DetailexpBloc>(context).add(
                                SettleUpExpenses(userId: state.id),
                              );
                      },
                      content: state.isGroupExpDetail
                          ? "Are you sure you want to delete the ${state.name} group? This will delete all the expenses linked to the group"
                          : "Are you sure you want to settle up all non-group expenses with ${state.name}? You cannot restore them later",
                      proceedButtonText:
                          state.isGroupExpDetail ? "DELETE GROUP" : "SETTLE UP",
                    ),
                  );
                },
                child: Text(
                  state.isGroupExpDetail ? "Delete Group" : "SETTLE UP",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: screenHeight * 0.016677255,
                      ),
                ),
              ),
            ],
          ),
        );
      } else
        return Container(
          height: 0.0,
          width: 0.0,
        );
    });
  }
}
