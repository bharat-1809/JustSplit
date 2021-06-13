import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/scren_arguments.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/screens/home_page/bloc/home_bloc.dart';
import 'package:contri_app/ui/screens/home_page/drawer_screen.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/add_expense_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/bloc/addexp_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/all_expenses_page/all_expenses_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/all_expenses_page/bloc/allexp_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/friends_page/bloc/friends_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/friends_page/friends_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/groups_page/bloc/groups_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/groups_page/groups_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/notes_page/bloc/notes_bloc.dart';
import 'package:contri_app/ui/screens/home_page/pages/notes_page/notes_page.dart';
import 'package:contri_app/ui/screens/profile_page/profile_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final double xOffset = screenWidth * 0.60;
  final double yOffset = screenHeight * 0.2;
  final double minDragStartEdge = screenWidth * 0.4;
  final double maxDragStartEdge = screenWidth * 0.30;
  AnimationController _controller;
  bool _canBeDragged = false;
  DateTime _currentBackPressTime;

  void toogleDrawer() {
    if (_controller.isDismissed)
      open();
    else
      close();
  }

  void close() {
    _controller.reverse();
  }

  void open() {
    _controller.forward();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _controller.addStatusListener((status) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeColorNavBar = Theme.of(context).primaryColor;
    final inactiveColorNavBar = Theme.of(context).primaryColor.withAlpha(110);
    final middleButtonBgColor = Theme.of(context).primaryColor.withOpacity(0.85);
    final bgColorNavBar = Theme.of(context).cardColor;

    final _tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    Future<bool> _onWillPopScope() {
      DateTime _now = DateTime.now();

      if (_currentBackPressTime == null ||
          _now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
        _currentBackPressTime = _now;

        Fluttertoast.showToast(
          msg: "Press again to exit",
          textColor: Theme.of(context).textTheme.bodyText1.color,
          backgroundColor: Theme.of(context).backgroundColor,
        );

        return Future.value(false);
      }
      Fluttertoast.cancel();
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: () => _onWillPopScope(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                HomeBloc()..add(HomeEvent.fromIndex(args != null ? args.homeIndex : 0)),
          ),
          BlocProvider(create: (context) => FriendsBloc()),
          BlocProvider(create: (context) => GroupsBloc()),
          BlocProvider(create: (context) => AddexpBloc()),
          BlocProvider(create: (context) => AllexpBloc()),
          BlocProvider(create: (context) => NotesBloc()),
        ],
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            _tabController.animateTo(state.index);
          },
          builder: (context, state) {
            return GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Stack(
                children: <Widget>[
                  DrawerScreen(animationController: _controller),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      double xSlide = xOffset * _controller.value;
                      double ySlide = yOffset * _controller.value;
                      double scale = 1 - (_controller.value * 0.4);
                      return Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).primaryColor.withAlpha(10)
                                  : Theme.of(context).primaryColorDark.withOpacity(0.25),
                              offset: Offset(-15, 5.0),
                              blurRadius: 20.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        transform: Matrix4.translationValues(xSlide, ySlide, 0.0)..scale(scale),
                        child: Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _controller.isDismissed
                                ? null
                                : () {
                                    Feedback.forTap(context);
                                    close();
                                  },
                            child: IgnorePointer(
                              ignoring: !_controller.isDismissed,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  _controller.isDismissed ? 0.0 : _controller.value * 15.0,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: Theme.of(context).cardColor,
                                    automaticallyImplyLeading: false,
                                    leading: IconButton(
                                      icon: Icon(
                                        _controller.isDismissed ? Icons.dehaze : Icons.arrow_back,
                                      ),
                                      onPressed: () async {
                                        toogleDrawer();
                                      },
                                    ),
                                    actions: [
                                      IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 0.0,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(ProfilePage.id);
                                        },
                                        icon: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColorDark
                                                    .withOpacity(0.65),
                                                width: 1.0,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Hero(
                                              tag: "profile",
                                              child: CircleAvatar(
                                                backgroundColor: Colors.tealAccent,
                                                child: FadeInImage(
                                                  placeholder:
                                                      const AssetImage('assets/icons/misc/loader.png'),
                                                  image: FirebaseImage(globalUser.pictureUrl),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.009),
                                    ],
                                  ),
                                  body: TabBarView(
                                    physics: const NeverScrollableScrollPhysics(),
                                    controller: _tabController,
                                    children: [
                                      FriendsPage(),
                                      GroupsPage(),
                                      AddExpensePage(),
                                      AllExpensesPage(),
                                      NotesPage(),
                                    ],
                                  ),
                                  bottomNavigationBar: ConvexAppBar(
                                    top: -(0.018015883 * screenHeight),
                                    height: 55.0,
                                    curve: Curves.bounceInOut,
                                    color: inactiveColorNavBar,
                                    controller: _tabController,
                                    elevation: 3.5,
                                    onTap: (index) {
                                      BlocProvider.of<HomeBloc>(context)
                                          .add(HomeEvent.fromIndex(index));
                                    },
                                    backgroundColor: bgColorNavBar,
                                    style: TabStyle.fixedCircle,
                                    activeColor: activeColorNavBar,
                                    items: [
                                      TabItem(
                                        title: "Friends",
                                        icon: SvgPicture.asset(
                                          'assets/icons/nav_bar/friend.svg',
                                          color: inactiveColorNavBar,
                                        ),
                                        activeIcon: SvgPicture.asset(
                                          'assets/icons/nav_bar/friend.svg',
                                          color: activeColorNavBar,
                                        ),
                                      ),
                                      TabItem(
                                        title: "Groups",
                                        icon: SvgPicture.asset(
                                          'assets/icons/bottom_bar/group.svg',
                                          fit: BoxFit.fill,
                                          color: inactiveColorNavBar,
                                        ),
                                        activeIcon: SvgPicture.asset(
                                          'assets/icons/bottom_bar/group.svg',
                                          color: activeColorNavBar,
                                        ),
                                      ),
                                      TabItem(
                                        icon: CircleAvatar(
                                          backgroundColor: middleButtonBgColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: SvgPicture.asset(
                                              'assets/icons/nav_bar/plus.svg',
                                              color: bgColorNavBar,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TabItem(
                                        title: "Expenses",
                                        icon: SvgPicture.asset(
                                          'assets/icons/nav_bar/expense.svg',
                                          color: inactiveColorNavBar,
                                        ),
                                        activeIcon: SvgPicture.asset(
                                          'assets/icons/nav_bar/expense.svg',
                                          color: activeColorNavBar,
                                        ),
                                      ),
                                      TabItem(
                                        title: "Notes",
                                        icon: SvgPicture.asset(
                                          'assets/icons/nav_bar/notes.svg',
                                          color: inactiveColorNavBar,
                                        ),
                                        activeIcon: SvgPicture.asset(
                                          'assets/icons/nav_bar/notes.svg',
                                          color: activeColorNavBar,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _controller.isDismissed && details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight =
        _controller.isCompleted && details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / (screenWidth * 0.60);
      _controller.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (_controller.isDismissed || _controller.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity =
          details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;

      _controller.fling(velocity: visualVelocity);
    } else if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}
