import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupport {
  static Future<void> mailToSupport({
    @required String subject,
    String body,
  }) async {
    final _supportUrl = "mailto:care.justsplit@gmail.com?subject=$subject&body=$body";
    //FIXME: The below code isn't working. There's a problem with canLaunch(). Untill its resolved
    // just work woth launch()
    // if (await canLaunch(_supportUrl)) {
    //   await launch(_supportUrl);
    // } else {
    //   throw "Couldn't send mail";
    // }
    await launch(_supportUrl);
  }

  static Future<void> sponserTheDev() async {
    final _sponserUrl = "https://paypal.me/bsharma1809";
    if (await canLaunch(_sponserUrl)) {
      await launch(_sponserUrl);
    } else {
      throw "Couldn't open billdesk";
    }
  }
}
