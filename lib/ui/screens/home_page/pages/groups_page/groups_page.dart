import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/balanceCard.dart';
import 'package:contri_app/ui/components/custom_appBar.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/screens/detailed_expense_page/detail_expense_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/groups_page/bloc/groups_bloc.dart';
import 'package:contri_app/ui/screens/new_group_page/new_group_page.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupsPage extends StatelessWidget {
  static const String id = "groups_page";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsBloc()..add(GroupsRequested()),
      child: GroupsMainBody(),
    );
  }
}

class GroupsMainBody extends StatelessWidget {
  final _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsState>(
      listener: (context, state) {
        if (state is GroupsFailure) {
          context.showSnackBar(state.message);
        }
      },
      builder: (context, state) {
        if (state is GroupsLoaded) {
          return Scaffold(
            body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                CustomAppBar(
                  height: screenHeight * 0.101181703, // 100
                  expandableHeight: screenHeight * 0.221308767, // 280
                  child: BalanceCard(),
                ),
              ],
              body: SmartRefresher(
                physics: const BouncingScrollPhysics(),
                controller: _refreshController,
                onRefresh: () async {
                  await initializeSdk;
                  BlocProvider.of<GroupsBloc>(context).add(GroupsRequested());
                  _refreshController.refreshCompleted();
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        state.groupsList.length + state.settledGroupsList.length > 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    for (var tile in state.groupsList)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 11),
                                        child: FlatButton(
                                          padding: const EdgeInsets.all(0.0),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              DetailExpPage.id,
                                              arguments:
                                                  ScreenArguments(group: tile.argObject.group),
                                            );
                                          },
                                          child: tile,
                                        ),
                                      ),
                                    const SizedBox(height: 5.0),
                                    ExpandablePanel(
                                      header: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 12.0,
                                        ),
                                        child: Text(
                                          'Settled Groups',
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                      ),
                                      expanded: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (var tile in state.settledGroupsList)
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 11),
                                              child: FlatButton(
                                                padding: const EdgeInsets.all(0.0),
                                                onPressed: () {
                                                  Navigator.of(context).pushNamed(
                                                    DetailExpPage.id,
                                                    arguments: ScreenArguments(
                                                      group: tile.argObject.group,
                                                    ),
                                                  );
                                                },
                                                child: tile,
                                              ),
                                            ),
                                        ],
                                      ),
                                      theme: ExpandableThemeData(
                                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                                        hasIcon: true,
                                        useInkWell: false,
                                        iconColor: Theme.of(context).primaryIconTheme.color,
                                      ),
                                    ),
                                  ])
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
                                    "You don't have any groups yet!\n",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: "Start adding here ",
                                      style: Theme.of(context).textTheme.bodyText1,
                                      children: [
                                        TextSpan(
                                          text: "👇",
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: screenHeight * 0.052236341),
                        Center(
                          child: NewGroupButton(),
                        ),
                        SizedBox(height: screenHeight * 0.052236341),
                      ],
                    ),
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

class NewGroupButton extends StatelessWidget {
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
          builder: (context) => NewGroupPage(),
        );
      },
      child: Text(
        "Create a New Group",
        style: Theme.of(context).textTheme.headline5.copyWith(
              fontSize: screenHeight * 0.016677255,
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }
}
