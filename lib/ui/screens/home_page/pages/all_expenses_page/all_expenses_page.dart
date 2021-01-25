import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/custom_appBar.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/screens/edit_expense_page/edit_expense_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/all_expenses_page/bloc/allexp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contri_app/extensions/snackBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllExpensesPage extends StatelessWidget {
  static const String id = "all_expenses_page";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllexpBloc()..add(AllexpRequested()),
      child: AllExpMainBody(),
    );
  }
}

class AllExpMainBody extends StatelessWidget {
  final _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllexpBloc, AllexpState>(
      listener: (context, state) {
        if (state is AllexpFailure) {
          context.showSnackBar(state.message);
        }
      },
      builder: (context, state) {
        if (state is AllexpLoaded) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              CustomAppBar(
                height: screenHeight * 0.080740823,
                expandableHeight: screenHeight * 0.125740823,
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      left: screenWidth * 0.050611111),
                  child: Text(
                    "All Expenses",
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: screenHeight * 0.033354511, // 30
                        ),
                  ),
                ),
              ),
            ],
            body: SmartRefresher(
              physics: BouncingScrollPhysics(),
              controller: _refreshController,
              onRefresh: () async {
                await initializeSdk;
                BlocProvider.of<AllexpBloc>(context).add(AllexpRequested());
                _refreshController.refreshCompleted();
              },
              child: state.expensesList.length > 0
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: SingleChildScrollView(
                        child: Column(
                          children: state.expensesList
                              .map<Padding>(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () =>
                                        Navigator.of(context).pushNamed(
                                      EditExpensePage.id,
                                      arguments: item.argObject.expense,
                                    ),
                                    child: item,
                                  ),
                                ),
                              )
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
                            'assets/illustrations/add_expense.svg',
                            width: screenWidth * 0.80,
                          ),
                          SizedBox(height: screenHeight * 0.040236341),
                          Text(
                            "You haven't added any expenses yet!\n",
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
