import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    if (!(value.isNotEmpty && value.contains("@") && value.contains("."))) {
      return 'The E-mail Address must be a valid email address.';
    }
    return null;
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/background.svg',
                width: MediaQuery.of(context).size.width,
              ),
              Container(
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
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                Util.mainPadding, Util.mainPadding, Util.mainPadding, 0),
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  Util.loginTitle,
                  style: TextStyle(
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Util.titleSize),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                const Text(
                  Util.loginCaption,
                  style: TextStyle(
                      color: CustomColor.textDetailColor,
                      fontSize: Util.descriptionSize),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          keyboardType: TextInputType
                              .emailAddress, // Use email input type for emails.
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'you@example.com',
                            labelText: 'Email',
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            _validateEmail(value!);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextFormField(
                          obscureText:
                              _obscureText, // Use secure text for passwords.
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Passwords',
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 50,
                                minHeight: 2,
                              ),
                              suffixIcon: InkWell(
                                  onTap: _toggle,
                                  child: Icon(
                                      _obscureText
                                          ? Icons.remove_red_eye_outlined
                                          : Icons.visibility_off_outlined,
                                      color: CustomColor.textDetailColor,
                                      size: 24))),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            _validatePassword(value!);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              NavigationRouter.switchToRetrievePass(context);
                            },
                            child: const Text(
                              Util.loginForgotPassword,
                              style: TextStyle(
                                  color: CustomColor.textDetailColor,
                                  fontSize: Util.descriptionSize),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: SizedBox(
                            height: 50, //height of button
                            width: MediaQuery.of(context)
                                .size
                                .width, //width of button
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
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );
                                  NavigationRouter.switchToHome(context);
                                }
                              },
                              child: const Text(
                                Util.buttonLogin,
                                style: TextStyle(
                                    color: CustomColor.buttonTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Image.asset('assets/google.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Image.asset('assets/facebook.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Image.asset('assets/apple.png'),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: Util.loginQuestion,
                        style: GoogleFonts.poppins(
                            color: CustomColor.textDetailColor,
                            fontSize: Util.descriptionSize),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                          text: Util.registerTitle,
                          style: GoogleFonts.poppins(
                              color: CustomColor.primaryColor,
                              fontSize: Util.descriptionSize),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigationRouter.switchToRegistration(context);
                            }),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: Util.mainPadding,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
