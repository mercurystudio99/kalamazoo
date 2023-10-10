import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List<bool> selectIndex = [false, false, false, false];

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
                      for (var i = 0; i < selectIndex.length; i++) {
                        if (selectIndex[i]) {
                          globals.userSubscription = i.toString();
                        }
                      }
                      NavigationRouter.switchToPayment(context);
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
}
