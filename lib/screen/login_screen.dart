import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

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
          Image.asset('assets/group.png'),
          Container(
            padding: const EdgeInsets.all(Util.mainPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  Util.loginTitle,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: Util.titleSize),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                const Text(
                  Util.loginCaption,
                  style: TextStyle(
                      color: Colors.black45, fontSize: Util.descriptionSize),
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
                          obscureText: true, // Use secure text for passwords.
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Passwords',
                              suffixIconConstraints: BoxConstraints(
                                minWidth: 50,
                                minHeight: 2,
                              ),
                              suffixIcon: InkWell(
                                  child: Icon(Icons.remove_red_eye_outlined,
                                      size: 24))),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            _validatePassword(value!);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          SizedBox(width: 10),
                          Text(
                            Util.loginForgotPassword,
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: Util.descriptionSize),
                          ),
                        ],
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
                                Util.buttonLogin,
                                style: TextStyle(
                                    color: Colors.white,
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
                          horizontal: 4.0, vertical: 4.0),
                      child: Image.asset('assets/group.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      child: Image.asset('assets/group.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      child: Image.asset('assets/group.png'),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: Util.loginQuestion,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: Util.descriptionSize),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                          text: Util.registerTitle,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: Util.descriptionSize),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigationRouter.switchToRegistration(context);
                            }),
                    ]),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
