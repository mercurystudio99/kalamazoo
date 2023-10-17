// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:overlay_support/overlay_support.dart';

import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // late int _totalNotifications;
  // late final FirebaseMessaging _messaging;
  // PushNotification? _notificationInfo;

  // void registerNotification() async {
  //   _messaging = FirebaseMessaging.instance;
  //   // 3. On iOS, this helps to take the user permissions
  //   NotificationSettings settings = await _messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     provisional: false,
  //     sound: true,
  //   );
  //   String? token = await _messaging.getToken();
  //   debugPrint(token);
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     debugPrint('User granted permission');
  //     // For handling the received notifications
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       // Parse the message received
  //       PushNotification notification = PushNotification(
  //         title: message.notification?.title,
  //         body: message.notification?.body,
  //         dataTitle: message.data['title'],
  //         dataBody: message.data['body'],
  //       );

  //       setState(() {
  //         _notificationInfo = notification;
  //         _totalNotifications++;
  //       });
  //       if (_notificationInfo != null) {
  //         // For displaying the notification as an overlay
  //         showSimpleNotification(
  //           Text(_notificationInfo!.title!),
  //           leading: NotificationBadge(totalNotifications: _totalNotifications),
  //           subtitle: Text(_notificationInfo!.body!),
  //           background: Colors.cyan.shade700,
  //           duration: const Duration(seconds: 2),
  //         );
  //       }
  //     });
  //   } else {
  //     debugPrint('User declined or has not accepted permission');
  //   }
  // }

  // For handling notification when the app is in terminated state
  // checkForInitialMessage() async {
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   if (initialMessage != null) {
  //     PushNotification notification = PushNotification(
  //       title: initialMessage.notification?.title,
  //       body: initialMessage.notification?.body,
  //     );
  //     setState(() {
  //       _notificationInfo = notification;
  //       _totalNotifications++;
  //     });
  //   }
  // }

  @override
  void initState() {
    // _totalNotifications = 0;

    // checkForInitialMessage();
    // // For handling notification when the app is in background
    // // but not terminated
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   PushNotification notification = PushNotification(
    //     title: message.notification?.title,
    //     body: message.notification?.body,
    //   );
    //   setState(() {
    //     _notificationInfo = notification;
    //     _totalNotifications++;
    //   });
    // });
    super.initState();
    // registerNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Util.mainPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/start.svg'),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          Text(
            Util.startTitle,
            style: GoogleFonts.poppins(
                color: CustomColor.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.0),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
          ),
          Text(
            Util.startSubTitle,
            style: GoogleFonts.poppins(
                color: CustomColor.textHeadColor,
                fontWeight: FontWeight.bold,
                fontSize: 22.0),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
          ),
          Text(
            Util.startContent,
            style: GoogleFonts.poppins(
                color: CustomColor.textDetailColor, fontSize: 13.0),
          ),
          // _notificationInfo != null
          //     ? Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
          //             style: const TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 16.0,
          //             ),
          //           ),
          //           const SizedBox(height: 8.0),
          //           Text(
          //             'BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
          //             style: const TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 16.0,
          //             ),
          //           ),
          //         ],
          //       )
          //     : Container(),
          // NotificationBadge(totalNotifications: _totalNotifications),
          const Spacer(),
          SizedBox(
              height: 50, //height of button
              width: MediaQuery.of(context).size.width, //width of button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(10)),
                    shadowColor: CustomColor.primaryColor,
                    padding:
                        const EdgeInsets.all(5) //content padding inside button
                    ),
                onPressed: () {
                  NavigationRouter.switchToLogin(context);
                },
                child: const Text(
                  Util.buttonGetStarted,
                  style: TextStyle(
                      color: CustomColor.buttonTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              )),
        ],
      ),
    ));
  }
}

// class NotificationBadge extends StatelessWidget {
//   final int totalNotifications;

//   const NotificationBadge({super.key, required this.totalNotifications});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40.0,
//       height: 40.0,
//       decoration: const BoxDecoration(
//         color: Colors.red,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             '$totalNotifications',
//             style: const TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PushNotification {
//   PushNotification({
//     this.title,
//     this.body,
//     this.dataTitle,
//     this.dataBody,
//   });

//   String? title;
//   String? body;
//   String? dataTitle;
//   String? dataBody;
// }
