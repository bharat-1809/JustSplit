import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/addNewFriend.dart';
import 'package:contri_app/ui/components/balanceCard.dart';
import 'package:contri_app/ui/components/custom_appBar.dart';
import 'package:contri_app/ui/components/progressIndicator.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/screens/detailed_expense_page/detail_expense_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/friends_page/bloc/friends_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendsPage extends StatelessWidget {
  static const String id = "friends_page";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsBloc()..add(FriendsPageRequested()),
      child: FriendsMainBody(),
    );
  }
}

class FriendsMainBody extends StatelessWidget {
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendsBloc, FriendsState>(
      listener: (context, state) {
        if (state is FriendsPageError) {
          context.showSnackBar(state.message);
        }

        if (state is FriendsPageLoading) {
          showProgress(context);
        }

        if (state is FriendsPageSuccess) {
          Navigator.of(context).pop();
          BlocProvider.of<FriendsBloc>(context).add(FriendsPageRequested());
          inviteFriend(
            context: context,
            phoneNumber: state.phoneNumber,
            firstName: state.firstName,
          );
        }
      },
      builder: (context, state) {
        if (state is FriendsPageLoaded) {
          return NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              CustomAppBar(
                height: screenHeight * 0.101181703, // 100
                expandableHeight: screenHeight * 0.221308767, // 280
                child: BalanceCard(),
              ),
            ],
            body: SmartRefresher(
              physics: BouncingScrollPhysics(),
              controller: _refreshController,
              onRefresh: () async {
                await initializeSdk;
                BlocProvider.of<FriendsBloc>(context)
                    .add(FriendsPageRequested());
                _refreshController.refreshCompleted();
              },
              child: Container(
                padding: EdgeInsets.only(top: 15),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      state.friendsList.length > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: state.friendsList
                                  .map(
                                    (item) => Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: kBorderRadius),
                                        color: Theme.of(context).cardColor,
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            DetailExpPage.id,
                                            arguments: ScreenArguments(
                                              friend: item.argObject.friend,
                                            ),
                                          );
                                        },
                                        child: item,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: screenHeight * 0.040236341),
                                SvgPicture.asset(
                                  'assets/illustrations/add_friend.svg',
                                  width: screenWidth * 0.80,
                                ),
                                SizedBox(height: screenHeight * 0.040236341),
                                Text(
                                  "Welcome! start adding friends from here\n",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  "👇",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                      SizedBox(height: screenHeight * 0.040236341),
                      Center(
                        child: NewFriendButton(),
                      ),
                      SizedBox(height: screenHeight * 0.058236341),
                    ],
                  ),
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

class NewFriendButton extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius,
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 0.75,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.014677255,
        horizontal: screenWidth * 0.0826618,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AddNewFriendDialog(
            onPressed: () {
              if (!formKey.currentState.validate()) return;
              BlocProvider.of<FriendsBloc>(context).add(
                AddNewFriend(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  defaultCurency: globalUser.defaultCurrency,
                  phoneNumber: phoneNumberController.text,
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            formKey: formKey,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            phoneNumberController: phoneNumberController,
          ),
        );
      },
      child: Text(
        "Add a Friend",
        style: Theme.of(context).textTheme.headline5.copyWith(
              fontSize: screenHeight * 0.016677255,
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }
}
