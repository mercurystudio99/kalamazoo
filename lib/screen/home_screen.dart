import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  bool _setting = true;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    List<String> countries = [
      "Tea",
      "Samosa",
      "Sandwich",
      "Dosa",
      "Dessert",
      "Dessert"
    ];

    final List<Widget> widgetOptions = <Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _handleMenuButtonPressed,
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable: _advancedDrawerController,
                      builder: (_, value, __) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            value.visible ? Icons.clear : Icons.menu,
                            key: ValueKey<bool>(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Location'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          Text('Kalamazoo, Michigon'),
                        ],
                      )
                    ],
                  ),
                  const badges.Badge(
                    badgeContent: Text('1'),
                    child: Icon(Icons.notifications_outlined),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Util.mainPadding, vertical: 10.0),
              child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search Restaurant or Food...',
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 50,
                      minHeight: 2,
                    ),
                    prefixIcon: Icon(Icons.search_outlined, size: 24),
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value!.contains('\n')) {
                      NavigationRouter.switchToSearch(context);
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(Util.categories),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        Util.seeAll,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
                height: 100,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: countries.map((country) {
                        return box(country, Colors.deepOrangeAccent);
                      }).toList(),
                    ))),
          ]),
        ),
      ]),
      const Icon(
        Icons.camera,
        size: 150,
      ),
      Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('assets/group.png'),
          Container(
            padding: const EdgeInsets.all(Util.mainPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
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
                      Util.profileTitle,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: const BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 30.0,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/group.png'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'James Hawkins',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(Util.profileContact),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            Util.edit,
                            style: TextStyle(color: Colors.blue),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: const Alignment(0, 0),
                        child: const Icon(Icons.email_outlined),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Email Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('demo@gmail.com'),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: const Alignment(0, 0),
                        child: const Icon(Icons.location_on_outlined),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Location',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Kalamazoo, Michigan, USA'),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: const Alignment(0, 0),
                        child: const Icon(Icons.person_outline),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Gender',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Male'),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: const Alignment(0, 0),
                        child: const Icon(Icons.calendar_month),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Birth Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('30 August 2023'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      disabledGestures: true,
      openRatio: 0.75,
      openScale: 0.85,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.black38,
          iconColor: Colors.black38,
          child: Padding(
            padding: const EdgeInsets.all(Util.mainPadding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('assets/group.png'),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'User Name',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'demo@gmail.com',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.home_outlined,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.wallet_giftcard),
                  title: const Text('Offer & Promos'),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'My Account',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    )),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Name'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    NavigationRouter.switchToNotification(context);
                  },
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notification'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Setting'),
                  trailing: Switch(
                    // This bool value toggles the switch.
                    value: _setting,
                    // activeColor: Colors.red,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        _setting = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        body: Container(
          child: widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueAccent,
          iconSize: 40,
          elevation: 0,
          unselectedIconTheme: const IconThemeData(
            color: Colors.white,
          ),
          unselectedItemColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border_outlined),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.redAccent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget box(String title, Color backgroundcolor) {
    return Container(
        margin: const EdgeInsets.all(10),
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundcolor,
        ),
        alignment: Alignment.center,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 20)));
  }
}
