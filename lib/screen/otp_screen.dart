import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final FocusNode _focusOne = FocusNode();
  final FocusNode _focusTwo = FocusNode();
  final FocusNode _focusThree = FocusNode();
  final FocusNode _focusFour = FocusNode();

  // This is the entered code
  // It will be displayed in a Text widget
  String _otp = '';

  void _getOTPcode() {
    setState(() {
      _otp =
          _fieldOne.text + _fieldTwo.text + _fieldThree.text + _fieldFour.text;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusOne.dispose();
    _focusTwo.dispose();
    _focusThree.dispose();
    _focusFour.dispose();
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
          if (_focusOne.hasFocus == false &&
              _focusTwo.hasFocus == false &&
              _focusThree.hasFocus == false &&
              _focusFour.hasFocus == false)
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
          ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Util.mainPadding * 0.5),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: CustomColor.primaryColor,
                    ),
                    onPressed: () {
                      NavigationRouter.back(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
                child: Text(
                  Util.otpTitle,
                  style: TextStyle(
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Util.titleSize),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
                child: Text(
                  Util.otpCaption,
                  style: TextStyle(
                      color: CustomColor.textDetailColor,
                      fontSize: Util.descriptionSize),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Util.mainPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OtpInput(_fieldOne, _focusOne, true), // auto focus
                    OtpInput(_fieldTwo, _focusTwo, false),
                    OtpInput(_fieldThree, _focusThree, false),
                    OtpInput(_fieldFour, _focusFour, false)
                  ],
                ),
              ),
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
                        _getOTPcode();
                        AppModel().verifyOTP(
                            otp: _otp,
                            onSuccess: () {
                              Future(() {
                                NavigationRouter.switchToResetPass(context);
                              });
                            },
                            onError: () {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid OTP')),
                              );
                            });
                      },
                      child: const Text(
                        Util.buttonSubmit,
                        style: TextStyle(
                            color: CustomColor.buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )),
              ),
              const SizedBox(
                height: Util.mainPadding,
              )
            ],
          )
        ],
      ),
    );
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final bool autoFocus;

  const OtpInput(this.controller, this.focus, this.autoFocus, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        elevation: 5,
        shadowColor: Colors.black,
        child: TextField(
          focusNode: focus,
          autofocus: autoFocus,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: 1,
          cursorColor: Theme.of(context).primaryColor,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              counterText: '',
              hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }
}
