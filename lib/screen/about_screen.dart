import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> dishes = [
      "Steak",
      "Barbecue Ribs",
      "Steak",
      "Steak",
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('assets/group.png'),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Util.mainPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        NavigationRouter.back(context);
                      },
                    ),
                    const Text(
                      Util.about,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/group.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Royal Dine Restaurant'),
                    Container(
                      color: Colors.red,
                      child: Row(
                        children: const [
                          Text(
                            '5.3',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: Util.mainPadding),
                isThreeLine: false,
                leading: Container(
                  width: 50,
                  alignment: const Alignment(0, 0),
                  child: const Icon(Icons.phone_in_talk_outlined),
                ),
                title: const Text(
                  'Phone',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                subtitle: const Text(
                  '0123456789',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: Util.mainPadding),
                isThreeLine: false,
                leading: Container(
                  width: 50,
                  alignment: const Alignment(0, 0),
                  child: const Icon(Icons.email_outlined),
                ),
                title: const Text(
                  'E-mail',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                subtitle: const Text(
                  'royaldine247@gmail.com',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: Util.mainPadding),
                isThreeLine: false,
                leading: Container(
                  width: 50,
                  alignment: const Alignment(0, 0),
                  child: const Icon(Icons.location_on),
                ),
                trailing: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Open Map',
                      style: TextStyle(color: Colors.blue),
                    )),
                title: const Text(
                  'Location',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                subtitle: const Text(
                  'Kalamazoo, Michigan, USA',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Top Dishes'),
                    TextButton(
                        onPressed: () {
                          NavigationRouter.switchToMenu(context);
                        },
                        child: const Text(
                          'Full menu',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                ),
              ),
              SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: dishes.map((dish) {
                          return box(dish, Colors.deepOrangeAccent);
                        }).toList(),
                      ))),
            ],
          )
        ],
      ),
    );
  }

  Widget box(String title, Color backgroundcolor) {
    return Container(
        margin: const EdgeInsets.all(10),
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundcolor,
        ),
        alignment: Alignment.center,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 20)));
  }
}
