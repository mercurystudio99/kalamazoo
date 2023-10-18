import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isSelectionMode = false;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < globals.notifications.length; i++) {
      globals.notifications[i]['seen'] = true;
    }
    notifications = globals.notifications.reversed.toList();
  }

  @override
  void dispose() {
    super.dispose();
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
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding * 0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        NavigationRouter.back(context);
                      },
                    ),
                    const Text(
                      Util.notification,
                      style: TextStyle(
                        color: CustomColor.primaryColor,
                        fontSize: 22.0,
                      ),
                    ),
                    const SizedBox(
                      width: Util.mainPadding,
                    ),
                  ],
                ),
              ),
              (globals.notifications.isEmpty)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100),
                      child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                            Icon(Icons.notifications_active,
                                size: 50, color: CustomColor.primaryColor),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'No notifications',
                              style: TextStyle(fontSize: 18),
                            ),
                          ])))
                  : Expanded(
                      child: ListBuilder(
                        isSelectionMode: isSelectionMode,
                        list: notifications,
                        onSelectionChange: (bool x) {
                          setState(() {
                            isSelectionMode = x;
                          });
                        },
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    super.key,
    required this.list,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final List<Map<String, dynamic>> list;
  final Function(bool)? onSelectionChange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (_, int index) {
          final notification = widget.list[index];
          int diff = DateTime.now().difference(notification['time']).inHours;
          String ago = '$diff Hour(s) ago';
          if (diff == 0) {
            diff = DateTime.now().difference(notification['time']).inMinutes;
            ago = '$diff Min(s) ago';
          }
          if (diff == 0) {
            diff = DateTime.now().difference(notification['time']).inSeconds;
            ago = '$diff Sec(s) ago';
          }

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Card(
                  color: (widget.isSelectionMode
                      ? CustomColor.primaryColor
                      : Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  shadowColor: CustomColor.primaryColor.withOpacity(0.2),
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    isThreeLine: false,
                    leading: CircleAvatar(
                        backgroundColor:
                            CustomColor.primaryColor.withOpacity(0.2),
                        child: const Icon(Icons.notifications_outlined,
                            color: CustomColor.primaryColor)),
                    trailing: Text(
                      ago,
                      style: TextStyle(
                          color: (widget.isSelectionMode
                              ? Colors.white
                              : CustomColor.textHeadColor),
                          fontSize: 12),
                    ),
                    title: Text(
                      notification['body'],
                      style: TextStyle(
                          color: (widget.isSelectionMode
                              ? Colors.white
                              : Colors.black),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    // subtitle: Text(
                    //   'Lorem Ipsum is simply dummy text',
                    //   style: TextStyle(
                    //     overflow: TextOverflow.ellipsis,
                    //     fontSize: 12.0,
                    //     color: (widget.isSelectionMode
                    //         ? Colors.white
                    //         : CustomColor.textDetailColor),
                    //   ),
                    // ),
                  )));
        });
  }
}
