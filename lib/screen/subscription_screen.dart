import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/key.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List<bool> selectIndex = [false, false, false, false];
  List<int> money = [100, 250, 500, 1000];
  List<int> count = [1, 4, 10, 1];
  List<String> type = ['each', 'month', 'month', 'day'];
  Map<String, dynamic>? paymentIntentData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/background.svg',
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          Positioned(
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                width: MediaQuery.of(context).size.height * 0.2,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomColor.primaryColor.withOpacity(0.15),
                      blurRadius: 30.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight:
                          Radius.circular(MediaQuery.of(context).size.width),
                      bottomLeft: Radius.zero,
                      bottomRight:
                          Radius.circular(MediaQuery.of(context).size.width)),
                ),
              )),
          ListView(children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: Util.mainPadding * 0.5, right: Util.mainPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: CustomColor.primaryColor,
                      size: 28,
                    ),
                    onPressed: () {
                      NavigationRouter.back(context);
                    },
                  ),
                  InkWell(
                    onTap: () {
                      NavigationRouter.switchToNotification(context);
                    },
                    child: const badges.Badge(
                      badgeContent: Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Center(
                  child: Text(
                Util.subscriptionTitle,
                style: TextStyle(
                    color: CustomColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Util.titleSize),
              )),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4),
              child: const Center(
                  child: Text(
                Util.subscriptionDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColor.textDetailColor,
                    fontSize: Util.descriptionSize),
              )),
            ),
            const SizedBox(height: 20),
            InkWell(
                onTap: () {
                  setState(() {
                    selectIndex[0] = true;
                    selectIndex[1] = false;
                    selectIndex[2] = false;
                    selectIndex[3] = false;
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding / 2, vertical: 4),
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: CustomColor.primaryColor.withOpacity(0.2),
                          blurRadius: 8.0,
                        ),
                      ],
                      border: Border.all(
                          color: selectIndex[0]
                              ? CustomColor.primaryColor
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: Image.asset('assets/crown.png'),
                      title: const Text(
                        '1 x Push Notification',
                        style: TextStyle(
                            color: CustomColor.primaryColor, fontSize: 15),
                      ),
                      trailing: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text: '\$100.00',
                            style: TextStyle(
                                color: CustomColor.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          TextSpan(
                              text: '/each',
                              style: TextStyle(
                                  color: CustomColor.primaryColor,
                                  fontSize: 16)),
                        ]),
                      ),
                    ))),
            InkWell(
                onTap: () {
                  setState(() {
                    selectIndex[0] = false;
                    selectIndex[1] = true;
                    selectIndex[2] = false;
                    selectIndex[3] = false;
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding / 2, vertical: 4),
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: CustomColor.primaryColor.withOpacity(0.2),
                          blurRadius: 8.0,
                        ),
                      ],
                      border: Border.all(
                          color: selectIndex[1]
                              ? CustomColor.primaryColor
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: Image.asset('assets/crown.png'),
                      title: const Text(
                        '4 x Push Notification',
                        style: TextStyle(
                            color: CustomColor.primaryColor, fontSize: 15),
                      ),
                      trailing: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text: '\$250.00',
                            style: TextStyle(
                                color: CustomColor.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          TextSpan(
                              text: '/month',
                              style: TextStyle(
                                  color: CustomColor.primaryColor,
                                  fontSize: 16)),
                        ]),
                      ),
                    ))),
            InkWell(
                onTap: () {
                  setState(() {
                    selectIndex[0] = false;
                    selectIndex[1] = false;
                    selectIndex[2] = true;
                    selectIndex[3] = false;
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding / 2, vertical: 4),
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: CustomColor.primaryColor.withOpacity(0.2),
                          blurRadius: 8.0,
                        ),
                      ],
                      border: Border.all(
                          color: selectIndex[2]
                              ? CustomColor.primaryColor
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: Image.asset('assets/crown.png'),
                      title: const Text(
                        '10 x Push Notification',
                        style: TextStyle(
                            color: CustomColor.primaryColor, fontSize: 15),
                      ),
                      trailing: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text: '\$500.00',
                            style: TextStyle(
                                color: CustomColor.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          TextSpan(
                              text: '/month',
                              style: TextStyle(
                                  color: CustomColor.primaryColor,
                                  fontSize: 16)),
                        ]),
                      ),
                    ))),
            InkWell(
                onTap: () {
                  setState(() {
                    selectIndex[0] = false;
                    selectIndex[1] = false;
                    selectIndex[2] = false;
                    selectIndex[3] = true;
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding / 2, vertical: 4),
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: CustomColor.primaryColor.withOpacity(0.2),
                          blurRadius: 8.0,
                        ),
                      ],
                      border: Border.all(
                          color: selectIndex[3]
                              ? CustomColor.primaryColor
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: Image.asset('assets/crown.png'),
                      title: const Text(
                        'Unlimited Plan -\n1 Push Notification/day',
                        style: TextStyle(
                            color: CustomColor.primaryColor, fontSize: 15),
                      ),
                      trailing: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text: '\$1000.00   ',
                            style: TextStyle(
                                color: CustomColor.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ]),
                      ),
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 30.0, horizontal: Util.mainPadding),
              child: SizedBox(
                  height: 50, //height of button
                  width: MediaQuery.of(context).size.width, //width of button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10, //elevation of button
                        shape: RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: CustomColor.primaryColor,
                        padding: const EdgeInsets.all(
                            5) //content padding inside button
                        ),
                    onPressed: () {
                      int index = -1;
                      for (int i = 0; i < selectIndex.length; i++) {
                        if (selectIndex[i]) {
                          index = i;
                        }
                      }
                      if (index < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please choose one of the subscription plans.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        makePayment(index);
                      }
                    },
                    child: const Text(
                      Util.buttonSubscription,
                      style: TextStyle(
                          color: CustomColor.buttonTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  )),
            ),
            const SizedBox(height: 50)
          ]),
        ],
      ),
    );
  }

  void _setSubscription(int index) {
    AppModel().setSubscription(
      count: count[index],
      type: type[index],
      onSuccess: () {
        debugPrint('success!!!');
      },
      onError: (err) {},
    );
  }

  payFee() {
    try {
      //if you want to upload data to any database do it here
    } catch (e) {
      // exception while uploading data
    }
  }

  Future<void> makePayment(int index) async {
    int cost = money[index];
    try {
      paymentIntentData = await createPaymentIntent(
          cost.toString(), 'USD'); //json.decode(response.body);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'ANNIE'))
          .then((value) {
        debugPrint('===>>> $value');
      });
      displayPaymentSheet(index);
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('$s');
      }
    }
  }

  displayPaymentSheet(int index) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        payFee();
        _setSubscription(index);
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          debugPrint('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        }
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
      }
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        debugPrint('err charging user: ${err.toString()}');
      }
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
