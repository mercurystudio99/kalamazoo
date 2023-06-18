import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
        () => NavigationRouter.switchToStart(context));
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
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                Util.splashCaption,
                style: TextStyle(
                    color: CustomColor.buttonTextColor, fontSize: 20.0),
              ),
            ),
          ),
          Center(
            child: SvgPicture.asset('assets/logo.svg'),
          ),
        ],
      ),
    );
  }
}
