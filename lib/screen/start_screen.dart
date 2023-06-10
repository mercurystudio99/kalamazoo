import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/utils/util.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Util.mainPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset('assets/start.svg'),
          const Padding(
            padding: EdgeInsets.only(bottom: 40.0),
          ),
          const Text(
            Util.startTitle,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
          ),
          const Text(
            Util.startSubTitle,
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
          ),
          const Text(
            Util.startContent,
            style: TextStyle(color: Colors.black12, fontSize: 12.0),
          ),
          const SizedBox(height: 50),
          ButtonTheme(
              minWidth: 200.0,
              height: 100.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5);
                    }
                    return null; // Use the component's default.
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled))
                      return Colors.blue;
                    return null; // Defer to the widget's default.
                  }),
                ),
                onPressed: () {},
                child: const Text(Util.buttonGetStarted),
              ))
        ],
      ),
    );
  }
}
