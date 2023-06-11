import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isChecked = false;

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
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('assets/group.png'),
          Container(
            padding: const EdgeInsets.all(Util.mainPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        NavigationRouter.switchToLogin(context);
                      },
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      Util.registerTitle,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: Util.titleSize),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                    ),
                    const Text(
                      Util.registerCaption,
                      style: TextStyle(
                          color: Colors.black45,
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
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'User Name',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextFormField(
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextFormField(
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
                                            ? Icons.visibility_off_outlined
                                            : Icons.remove_red_eye_outlined,
                                        size: 24),
                                  )),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                _validatePassword(value!);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
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
                                    text: const TextSpan(children: [
                                      TextSpan(
                                        text: 'By Signing up, I agree to the ',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: Util.descriptionSize),
                                      ),
                                      TextSpan(
                                        text: 'term Of Service',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Util.descriptionSize),
                                      ),
                                    ]),
                                  ),
                                  const Text(
                                    '& privacy Policy',
                                    style: TextStyle(
                                        color: Colors.black45,
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
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: Util.registerQuestion,
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: Util.descriptionSize),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                              text: Util.loginTitle,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: Util.descriptionSize),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  NavigationRouter.switchToLogin(context);
                                }),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                          height: 50, //height of button
                          width: MediaQuery.of(context)
                              .size
                              .width, //width of button
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
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );
                              }
                            },
                            child: const Text(
                              Util.buttonSignup,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
