import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';

class RetrievePassScreen extends StatefulWidget {
  const RetrievePassScreen({super.key});

  @override
  State<RetrievePassScreen> createState() => _RetrievePassScreenState();
}

class _RetrievePassScreenState extends State<RetrievePassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final FocusNode _focusEmail = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusEmail.dispose();
    super.dispose();
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return '\u26A0 Please enter your email.';
    }
    if (!(value.isNotEmpty && value.contains("@") && value.contains("."))) {
      return '\u26A0 The E-mail Address must be a valid email address.';
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
            ],
          ),
          if (_focusEmail.hasFocus == false)
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
                  Util.retrievePassTitle,
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
                  Util.retrievePassCaption,
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
                      child: Stack(
                        children: [
                          Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    spreadRadius: 1),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
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
                              return _validateEmail(value!);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: Util.mainPadding),
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
                                AppModel().userExist(
                                    email: _emailController.text.trim(),
                                    onSuccess: () {
                                      AppModel().sendOTP(
                                          email: _emailController.text.trim(),
                                          onSuccess: () {
                                            NavigationRouter.switchToOTP(
                                                context);
                                          },
                                          onError: () {
                                            // Show error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Oops, OTP send failed')),
                                            );
                                          });
                                    },
                                    onError: (String text) {
                                      // Show error message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(text)),
                                      );
                                    });
                              }
                            },
                            child: const Text(
                              Util.buttonOTP,
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
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
