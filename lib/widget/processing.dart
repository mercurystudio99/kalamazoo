import 'package:flutter/material.dart';

class Processing extends StatelessWidget {
  // Variables
  final String? text;

  const Processing({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const MyCircularProgress(),
          const SizedBox(height: 10),
          Text(text ?? "Processing...", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 5),
          const Text("Please wait!", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class MyCircularProgress extends StatelessWidget {
  const MyCircularProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
    );
  }
}
