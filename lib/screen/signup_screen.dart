import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/globals.dart' as global;
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late String userType = '';

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
          Positioned(
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                width: MediaQuery.of(context).size.height * 0.2,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomColor.primaryColor.withOpacity(0.1),
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
          Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.height * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomColor.primaryColor.withOpacity(0.1),
                      blurRadius: 30.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight:
                          Radius.circular(MediaQuery.of(context).size.width),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero),
                ),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              const Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Util.mainPadding * 0.5),
                      child: Text('Register as a Restaurant',
                          style: TextStyle(
                              color: CustomColor.primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)))),
              const Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Util.mainPadding * 0.5),
                      child: Text('Owner Or Customer',
                          style: TextStyle(
                              color: CustomColor.primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)))),
              const SizedBox(height: 80),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: Util.mainPadding / 2),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          userType = 'owner';
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: (userType == 'owner')
                                    ? CustomColor.primaryColor
                                    : Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(10, 10),
                                  color:
                                      CustomColor.primaryColor.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 1),
                            ],
                          ),
                          child: Card(
                              margin: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              child: Stack(children: [
                                Positioned(
                                    top: 10,
                                    right: 20,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width:
                                                  (userType == 'owner') ? 5 : 1,
                                              color: CustomColor.primaryColor),
                                          color: Colors.white),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(
                                        Util.mainPadding / 2),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Image.asset('assets/shopkeeper.png'),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'I am Restaurant Owner',
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ]))
                              ]))))),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: Util.mainPadding / 2),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          userType = 'customer';
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: (userType == 'customer')
                                    ? CustomColor.primaryColor
                                    : Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(10, 10),
                                  color:
                                      CustomColor.primaryColor.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 1),
                            ],
                          ),
                          child: Card(
                              margin: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              child: Stack(children: [
                                Positioned(
                                    top: 10,
                                    right: 20,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: (userType == 'customer')
                                                  ? 5
                                                  : 1,
                                              color: CustomColor.primaryColor),
                                          color: Colors.white),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(
                                        Util.mainPadding / 2),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Image.asset('assets/user.png'),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'I am customer',
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ]))
                              ]))))),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: Util.registerQuestion,
                      style: GoogleFonts.poppins(
                          color: CustomColor.textDetailColor,
                          fontSize: Util.descriptionSize),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                        text: Util.loginTitle,
                        style: GoogleFonts.poppins(
                            color: CustomColor.primaryColor,
                            fontSize: Util.descriptionSize),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigationRouter.switchToLogin(context);
                          }),
                  ]),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: Util.mainPadding),
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
                        if (userType.isEmpty) return;
                        global.userType = userType;
                        if (global.userType == 'customer') {
                          NavigationRouter.switchToRegistration(context);
                        } else {
                          NavigationRouter.switchToRegistration2(context);
                        }
                      },
                      child: const Text(
                        Util.buttonSignup,
                        style: TextStyle(
                            color: CustomColor.buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )),
              ),
              const SizedBox(height: 30),
            ],
          )
        ],
      ),
    );
  }
}
