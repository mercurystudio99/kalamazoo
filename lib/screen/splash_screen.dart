import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kalamazoo/utils/globals.dart' as global;
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/models/app_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final FirebaseMessaging _messaging;

  void setFCMToken() async {
    _messaging = FirebaseMessaging.instance;
    String? token = await _messaging.getToken();
    AppModel().setFCMToken(token: token ?? '', onSuccess: () {});
  }

  @override
  void initState() {
    super.initState();
    if (global.userEmail.isNotEmpty) {
      AppModel().userExist(
          email: global.userEmail,
          onSuccess: (String id) {
            global.userID = id;
            setFCMToken();
            if (global.userRole == Util.customer) {
              Timer(const Duration(seconds: 3),
                  () => NavigationRouter.switchToHome(context));
            } else {
              Timer(const Duration(seconds: 3),
                  () => NavigationRouter.switchToAbout(context));
            }
          },
          onError: (String text) {});
    } else {
      Timer(const Duration(seconds: 3),
          () => NavigationRouter.switchToStart(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: CustomColor.primaryColor,
            padding: const EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                Util.splashCaption,
                style: GoogleFonts.denkOne(
                    color: CustomColor.buttonTextColor, fontSize: 23),
              ),
            ),
          ),
          Center(
            child: Image.asset('assets/logo.png'),
          ),
        ],
      ),
    );
  }
}
