import 'package:flutter/material.dart';
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
  final int listLength = 30;
  late List<bool> _selected;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _selected = List<bool>.generate(listLength, (_) => false);
  }

  @override
  void dispose() {
    _selected.clear();
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
              Expanded(
                child: ListBuilder(
                  isSelectionMode: isSelectionMode,
                  selectedList: _selected,
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
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final List<bool> selectedList;
  final Function(bool)? onSelectionChange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selectedList.length,
        itemBuilder: (_, int index) {
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    isThreeLine: false,
                    leading: Image.asset('assets/group.png'),
                    trailing: Text(
                      '5 Min ago',
                      style: TextStyle(
                          color: (widget.isSelectionMode
                              ? Colors.white
                              : CustomColor.textDetailColor),
                          fontSize: 10),
                    ),
                    title: Text(
                      'James Hawkins',
                      style: TextStyle(
                          color: (widget.isSelectionMode
                              ? Colors.white
                              : Colors.black),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    subtitle: Text(
                      'Lorem Ipsum is simply dummy text',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12.0,
                        color: (widget.isSelectionMode
                            ? Colors.white
                            : CustomColor.textDetailColor),
                      ),
                    ),
                  )));
        });
  }
}
