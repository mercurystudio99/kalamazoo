import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';

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
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/start.svg'),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          Text(
            Util.startTitle,
            style: GoogleFonts.poppins(
                color: CustomColor.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 22.0),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
          ),
          Text(
            Util.startSubTitle,
            style: GoogleFonts.poppins(
                color: CustomColor.textHeadColor,
                fontWeight: FontWeight.bold,
                fontSize: 22.0),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
          ),
          Text(
            Util.startContent,
            style: GoogleFonts.poppins(
                color: CustomColor.textDetailColor, fontSize: 12.0),
          ),
          const SizedBox(height: 50),
          SizedBox(
              height: 50, //height of button
              width: MediaQuery.of(context).size.width, //width of button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(10)),
                    shadowColor: CustomColor.primaryColor,
                    padding:
                        const EdgeInsets.all(5) //content padding inside button
                    ),
                onPressed: () {
                  NavigationRouter.switchToLogin(context);
                },
                child: const Text(
                  Util.buttonGetStarted,
                  style: TextStyle(
                      color: CustomColor.buttonTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              )),
        ],
      ),
    );
  }
}
