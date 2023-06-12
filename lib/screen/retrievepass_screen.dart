import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';

class RetrievePassScreen extends StatefulWidget {
  const RetrievePassScreen({super.key});

  @override
  State<RetrievePassScreen> createState() => _RetrievePassScreenState();
}

class _RetrievePassScreenState extends State<RetrievePassScreen> {
  final _formKey = GlobalKey<FormState>();

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
                  Util.retrievePassTitle,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: Util.titleSize),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                const Text(
                  Util.retrievePassCaption,
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
                            labelText: 'Email Address',
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            _validateEmail(value!);
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
                                  NavigationRouter.switchToOTP(context);
                                }
                              },
                              child: const Text(
                                Util.buttonOTP,
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
