import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kalamazoo/utils/authentication.dart';
import 'package:kalamazoo/utils/navigation_router.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});
  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () {
          // Login with google
          Authentication.signInWithGoogle(onSuccess: () {
            NavigationRouter.switchToHome(context);
          }, onError: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something Error!')),
            );
          });
          // setState(() {
          //   _isSigningIn = true;
          // });

          // User? user = await Authentication.signInWithGoogle(context: context);

          // setState(() {
          //   _isSigningIn = false;
          // });
          // if (user != null) {
          //   debugPrint('$user');
          //   // NavigationRouter.switchToHome(context);
          // } else {
          //   debugPrint('===== >_< ====');
          // }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
