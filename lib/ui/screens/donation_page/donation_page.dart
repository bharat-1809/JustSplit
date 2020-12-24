import 'package:contri_app/global/logger.dart';
import 'package:contri_app/ui/components/custom_appBar.dart';
import 'package:contri_app/ui/components/donation_items.dart';
import 'package:contri_app/ui/components/donation_tile.dart';
import 'package:contri_app/ui/components/support_payment.dart'
    as RazorpayHelper;
import 'package:contri_app/ui/global/utils.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DonationPage extends StatelessWidget {
  static const id = "donation_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) => DonationPageBody(),
      ),
    );
  }
}

class DonationPageBody extends StatefulWidget {
  @override
  _DonationPageBodyState createState() => _DonationPageBodyState();
}

class _DonationPageBodyState extends State<DonationPageBody> {
  final Razorpay _razorpay = Razorpay();

  Future<void> _openCheckout(
      {@required int amount, @required String sponserType}) async {
    try {
      if (!isInternational) {
        _razorpay.open(RazorpayHelper.razorpayOptionsIndia(
          amount: amount,
          sponserType: sponserType,
        ));
      } else {
        _razorpay.open(RazorpayHelper.razorpayOptionsInternational(
          amount: amount,
          sponserType: sponserType,
        ));
      }
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void initState() {
    RazorpayHelper.initializeRazorpayListeners(context);
    _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, RazorpayHelper.handlePaymentSuccess);
    _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR, RazorpayHelper.handlePaymentError);
    _razorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET, RazorpayHelper.handleExternalWallet);

    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        CustomAppBar(
          height: screenHeight * 0.080740823,
          expandableHeight: screenHeight * 0.100040823,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.050611111,
            ),
            child: Text(
              "Support Development",
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: screenHeight * 0.030354511, // 30
                  ),
            ),
          ),
        ),
      ],
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "You can support JustSplit by donating any amount that you can choose from below\nNot donating will not affect your experience",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: screenHeight * 0.015,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 7.0,
              children: donationItems
                  .map(
                    (item) => DonationTile(
                      name: item.name,
                      description: item.description,
                      amount: item.amount,
                      onClick: () async {
                        await _openCheckout(
                          amount: item.amount,
                          sponserType: item.name,
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
