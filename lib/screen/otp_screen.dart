import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';

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

  // This is the entered code
  // It will be displayed in a Text widget
  String? _otp;

  void _getOTPcode() {
    setState(() {
      _otp =
          _fieldOne.text + _fieldTwo.text + _fieldThree.text + _fieldFour.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('assets/group.png'),
          Container(
            padding: const EdgeInsets.all(Util.mainPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    NavigationRouter.switchToRetrievePass(context);
                  },
                ),
                const SizedBox(height: 50),
                const Text(
                  Util.otpTitle,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: Util.titleSize),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                const Text(
                  Util.otpCaption,
                  style: TextStyle(
                      color: Colors.black45, fontSize: Util.descriptionSize),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                // Implement 4 input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OtpInput(_fieldOne, true), // auto focus
                    OtpInput(_fieldTwo, false),
                    OtpInput(_fieldThree, false),
                    OtpInput(_fieldFour, false)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                      height: 50, //height of button
                      width:
                          MediaQuery.of(context).size.width, //width of button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 3, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(
                                5) //content padding inside button
                            ),
                        onPressed: () {
                          _getOTPcode();
                          NavigationRouter.switchToResetPass(context);
                        },
                        child: Text(
                          _otp ?? Util.buttonSubmit,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
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
    );
  }
}
