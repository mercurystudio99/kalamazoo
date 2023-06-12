import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  // Toggles the password show status
  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
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
                    NavigationRouter.switchToLogin(context);
                  },
                ),
                const SizedBox(height: 50),
                const Text(
                  Util.resetPassTitle,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: Util.titleSize),
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
                          obscureText:
                              _obscureText1, // Use secure text for passwords.
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'New Password',
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 50,
                                minHeight: 2,
                              ),
                              suffixIcon: InkWell(
                                onTap: _toggle1,
                                child: Icon(
                                    _obscureText1
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
                        child: TextFormField(
                          obscureText:
                              _obscureText2, // Use secure text for passwords.
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Confirm New Password',
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 50,
                                minHeight: 2,
                              ),
                              suffixIcon: InkWell(
                                onTap: _toggle2,
                                child: Icon(
                                    _obscureText2
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
                                  NavigationRouter.switchToLogin(context);
                                }
                              },
                              child: const Text(
                                Util.buttonSubmit,
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
              ],
            ),
          )
        ],
      ),
    );
  }
}