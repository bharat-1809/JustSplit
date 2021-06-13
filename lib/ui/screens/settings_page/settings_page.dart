import 'package:contri_app/sdk/functions/messaging_functions.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/ui/components/changePasswordDialog.dart';
import 'package:contri_app/ui/components/customAbout.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/theme/app_themes.dart';
import 'package:contri_app/ui/global/theme/bloc/theme_bloc.dart';
import 'package:contri_app/ui/screens/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  static const id = "settings_page";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme;
  bool _showNotification;

  Future<bool> getNotificationStatus() async {
    final _prefs = await SharedPreferences.getInstance();
    final _notificationStatus = _prefs.getBool('showNotifications');

    return _notificationStatus ?? true;
  }

  Future<void> updateNotificationStatus(bool showNotifications) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool("showNotifications", showNotifications);

    setState(() {
      _showNotification = showNotifications;
    });

    if (showNotifications) {
      NotificationHandler.uploadDeviceToken(userId: globalUser.id);
    } else {
      NotificationHandler.clearDeviceToken(userId: globalUser.id);
    }
  }

  @override
  void initState() {
    super.initState();

    getNotificationStatus().then(
      (value) => setState(() {
        _showNotification = value ?? true;
      }),
    );
  }

  @override
  void didChangeDependencies() {
    _isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "Settings",
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: screenHeight * 0.035354511,
                      ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SettingsTile(
                      title: "My Profile",
                      leadingIcon: "assets/icons/auth_icons/firstName.svg",
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: screenHeight * 0.020022247,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(ProfilePage.id);
                      },
                    ),
                    SizedBox(height: screenHeight * 0.011123471),
                    SettingsTile(
                      title: "Change Password",
                      leadingIcon: "assets/icons/auth_icons/lock.svg",
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: screenHeight * 0.020022247,
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => ChangePasswordDialog(),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.011123471),
                    SettingsTile(
                      title: "Dark Theme",
                      leadingIcon: "assets/icons/misc/theme.svg",
                      trailing: Switch(
                        value: _isDarkTheme,
                        onChanged: (newVal) {
                          setState(
                            () {
                              BlocProvider.of<ThemeBloc>(context).add(
                                ThemeChanged(
                                  appTheme: _isDarkTheme
                                      ? AppTheme.Light
                                      : AppTheme.Dark,
                                ),
                              );
                              _isDarkTheme = newVal;
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.011123471),
                    SettingsTile(
                      title: "Show Notifications",
                      leadingIcon: "assets/icons/misc/notification.svg",
                      trailing: Switch(
                        value: _showNotification ?? true,
                        onChanged: (notificationStatus) async {
                          updateNotificationStatus(notificationStatus);
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.011123471 * 3),
                    Divider(
                      thickness: 1.2,
                      indent: 15.0,
                      endIndent: 15.0,
                    ),
                    SizedBox(height: screenHeight * 0.011123471),
                    SettingsTile(
                      title: "Terms and Privacy Policy",
                      leadingIcon: "assets/icons/misc/privacy.svg",
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: screenHeight * 0.020022247,
                      ),
                      onTap: () async {
                        await launch('https://contri-app.web.app');
                      },
                    ),
                    SizedBox(height: screenHeight * 0.011123471),
                    SettingsTile(
                      title: "App Info",
                      leadingIcon: "assets/icons/misc/info.svg",
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: screenHeight * 0.020022247,
                      ),
                      onTap: () {
                        showCustomAboutDialog(
                          context: context,
                          applicationIcon: SvgPicture.asset(
                            "assets/icons/misc/JustSplit_logo_v3-08.svg",
                            width: 50.0,
                            height: 50.0,
                          ),
                          applicationVersion: kAppVersion,
                          applicationName: "JustSplit",
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final Widget trailing;
  final String leadingIcon;
  final String title;
  final Function onTap;
  SettingsTile(
      {@required this.title,
      @required this.leadingIcon,
      @required this.trailing,
      this.onTap})
      : assert(title != null),
        assert(leadingIcon != null),
        assert(trailing != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: kBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorDark.withOpacity(0.05),
            offset: Offset(0.0, 5.0),
            blurRadius: 10,
            spreadRadius: 0.09,
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: kBorderRadius,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.007,
        ),
        leading: SvgPicture.asset(
          leadingIcon,
          color: Theme.of(context).primaryIconTheme.color,
          width: 25.0,
          height: 25.0,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: screenHeight * 0.016,
              ),
        ),
        trailing: trailing,
      ),
    );
  }
}
