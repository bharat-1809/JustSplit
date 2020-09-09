import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupport {
 static Future<void> mailToSupport({@required String subject, String body}) async {
    final _supportUrl =
        'mailto:care.justsplit@gmail.com?subject=$subject&body=';
    if (await canLaunch(_supportUrl)) {
      await launch(_supportUrl);
    } else {
      throw "Couldn't send mail";
    }
  }

  static Future<void> sponserTheDev() async {
    final _sponserUrl = 'https://paypal.me/bsharma1809';
    if (await canLaunch(_sponserUrl)) {
      await launch(_sponserUrl);
    } else {
      throw "Couldn't open billdesk";
    }
  }
}
