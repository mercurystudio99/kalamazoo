import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Util.mainPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset('assets/start.svg'),
          const Padding(
            padding: EdgeInsets.only(bottom: 40.0),
          ),
          const Text(
            Util.startTitle,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
          ),
          const Text(
            Util.startSubTitle,
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
          ),
          const Text(
            Util.startContent,
            style: TextStyle(color: Colors.black12, fontSize: 12.0),
          ),
          const SizedBox(height: 50),
          SizedBox(
              height: 50, //height of button
              width: MediaQuery.of(context).size.width, //width of button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.all(5) //content padding inside button
                    ),
                onPressed: () {
                  NavigationRouter.switchToLogin(context);
                },
                child: const Text(
                  Util.buttonGetStarted,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              )),
        ],
      ),
    );
  }
}
