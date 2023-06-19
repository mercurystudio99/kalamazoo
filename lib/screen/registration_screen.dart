import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusUser = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPass = FocusNode();

  bool _obscureText = true;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusUser.dispose();
    _focusEmail.dispose();
    _focusPass.dispose();
    super.dispose();
  }

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
              if (_focusUser.hasFocus == false &&
                  _focusEmail.hasFocus == false &&
                  _focusPass.hasFocus == false)
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
                  Util.registerTitle,
                  style: TextStyle(
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Util.titleSize),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
                child: Text(
                  Util.registerCaption,
                  style: TextStyle(
                      color: CustomColor.textDetailColor,
                      fontSize: Util.descriptionSize),
                ),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: TextFormField(
                          focusNode: _focusUser,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'User Name',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: TextFormField(
                          focusNode: _focusEmail,
                          keyboardType: TextInputType
                              .emailAddress, // Use email input type for emails.
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'you@example.com',
                            labelText: 'Email Address',
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            _validateEmail(value!);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: TextFormField(
                          focusNode: _focusPass,
                          obscureText:
                              _obscureText, // Use secure text for passwords.
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Password',
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
                                    size: 24),
                              )),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            _validatePassword(value!);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding * 0.5),
                      child: Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.black.withOpacity(.32);
                            }
                            return Colors.black;
                          }),
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'By Signing up, I agree to the ',
                                  style: GoogleFonts.poppins(
                                      color: CustomColor.textHeadColor,
                                      fontSize: Util.descriptionSize),
                                ),
                                TextSpan(
                                  text: 'term Of Service',
                                  style: GoogleFonts.poppins(
                                      color: CustomColor.textHeadColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Util.descriptionSize),
                                ),
                              ]),
                            ),
                            Text(
                              '& privacy Policy',
                              style: GoogleFonts.poppins(
                                  color: CustomColor.textHeadColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Util.descriptionSize),
                            )
                          ],
                        )
                      ]),
                    ),
                  ],
                ),
              ),
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
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
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
