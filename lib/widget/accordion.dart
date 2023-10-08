import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final List<String> contents;
  final VoidCallback reloadFn;

  const Accordion({Key? key, required this.contents, required this.reloadFn})
      : super(key: key);
  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  // Show or hide the content
  bool _showDining = false;
  bool _showDailySpecial = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: CustomColor.primaryColor,
      elevation: 0,
      child: Column(children: [
        ListTile(
          leading: Image.asset('assets/daily_specials.png'),
          title: const Text(
            'Daily Specials',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: IconButton(
            icon: Icon(
                _showDailySpecial
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Colors.white),
            onPressed: () {
              setState(() {
                _showDailySpecial = !_showDailySpecial;
              });
            },
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
          onTap: () {},
        ),
        _showDailySpecial
            ? Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 12, 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                              onTap: () {},
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Happy Hour',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white)
                                  ]))),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                              onTap: () {},
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Kids Menu',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white)
                                  ]))),
                    ]),
              )
            : Container(),

        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(height: 1, color: Colors.white54)),
        ListTile(
          leading: Image.asset('assets/dining.png'),
          title: const Text(
            'Dining',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: IconButton(
            icon: Icon(
                _showDining
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Colors.white),
            onPressed: () {
              setState(() {
                _showDining = !_showDining;
              });
            },
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 5, 0, 10),
        ),
        // Show or hide the content based on the state
        _showDining
            ? Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 12, 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                              onTap: () {
                                globals.restaurantType = C_BREWERIES;
                                globals.listTarget = '';
                                NavigationRouter.switchToList(context);
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.contents[0],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    const Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white)
                                  ]))),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                              onTap: () {},
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.contents[1],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    const Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white)
                                  ]))),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                              onTap: () {
                                globals.restaurantType = C_RESTAURANTS;
                                globals.listTarget = '';
                                NavigationRouter.switchToList(context);
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.contents[2],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    const Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white)
                                  ]))),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                              onTap: () {
                                globals.restaurantType = C_WINERIES;
                                globals.listTarget = '';
                                NavigationRouter.switchToList(context);
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.contents[3],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    const Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white)
                                  ]))),
                    ]),
              )
            : Container(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(height: 1, color: Colors.white54)),
        ListTile(
          leading: Image.asset('assets/events.png'),
          title: const Text(
            ' Events',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right, color: Colors.white),
            onPressed: () {},
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
          onTap: () => NavigationRouter.switchToEvent(context),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(height: 1, color: Colors.white54)),
        ListTile(
          title: const Text(
            'Catering',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right, color: Colors.white),
            onPressed: () {},
          ),
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(height: 1, color: Colors.white54)),
        ListTile(
          leading: Image.asset('assets/new_places.png'),
          title: const Text(
            ' New Places',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right, color: Colors.white),
            onPressed: () {},
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
        ),
      ]),
    );
  }
}
