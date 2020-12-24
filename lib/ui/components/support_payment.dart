import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/logger.dart';
import 'package:contri_app/ui/constants.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:contri_app/extensions/snackBar.dart';

Map<String, dynamic> razorpayOptionsIndia(
    {@required int amount, @required String sponserType}) {
  return {
    'key': kRazorpayKey,
    'amount': amount * 100,
    'name': 'JustSplit',
    'description': sponserType,
    'prefill': {
      'contact': '${globalUser.phoneNumber}',
      'email': '${globalUser.email}',
    },
    'external': {
      'wallets': ['paytm', 'paypal'],
    }
  };
}

Map<String, dynamic> razorpayOptionsInternational(
    {@required int amount, @required String sponserType}) {
  return {
    'key': kRazorpayKey,
    'amount': amount * 10,
    'currency': 'USD',
    'name': 'JustSplit',
    'description': sponserType,
    'prefill': {
      'contact': '${countryDetails.dialCode}${globalUser.phoneNumber}',
      'email': '${globalUser.email}',
    },
    'wallet': 'paypal',
  };
}

BuildContext scaffoldContext;

void initializeRazorpayListeners(BuildContext context) {
  scaffoldContext = context;
}

void handlePaymentSuccess(PaymentSuccessResponse response) {
  scaffoldContext.showSnackBar("SUCCESS: " + response.paymentId);
  logger.v("SUCCESS: " + response.paymentId);
}

void handlePaymentError(PaymentFailureResponse response) {
  scaffoldContext.showSnackBar(
      "ERROR: " + response.code.toString() + " - " + response.message);
  logger.wtf("ERROR: " + response.code.toString() + " - " + response.message);
}

void handleExternalWallet(ExternalWalletResponse response) {
  scaffoldContext.showSnackBar("EXTERNAL_WALLET: " + response.walletName);
}
