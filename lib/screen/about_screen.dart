import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/utils/globals.dart' as global;
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/widget/processing.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Map<String, dynamic> menu = {};
  late List<Map<String, dynamic>> foods = [];
  late List<Map<String, dynamic>> amenities = [];
  late List<Map<String, dynamic>> categories = [];

  void _getCategories() {
    AppModel().getCategories(
      onSuccess: (List<Map<String, dynamic>> param) {
        categories = param;
        _getMenu();
      },
      onEmpty: () {},
    );
  }

  void _getMenu() {
    for (var food in foods) {
      if (food[MENU_CATEGORY] == null) continue;
      if (menu.containsKey(food[MENU_CATEGORY])) continue;
      for (var category in categories) {
        if (food[MENU_CATEGORY] == category[CATEGORY_ID]) {
          menu.addAll({category[CATEGORY_ID]: category[CATEGORY_NAME]});
          break;
        }
      }
    }
    setState(() {});
  }

  void _getFoods() {
    AppModel().getRestaurantFoodByID(
        onSuccess: (List<Map<String, dynamic>> param) {
          foods = param;
          _getCategories();
        },
        onError: (String value) {});
  }

  void _getAmenities() {
    AppModel().getAmenities(
      onSuccess: (List<Map<String, dynamic>> param) {
        amenities = param;
        setState(() {});
      },
      onEmpty: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    _getFoods();
    _getAmenities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: AppModel().getRestaurant(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                final Map<String, dynamic> restaurant =
                    snapshot.data!.docs[0].data();

                List<Widget> listView = [];
                listView.addAll([
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
                            NavigationRouter.switchToHome(context);
                          },
                        ),
                        const Text(
                          Util.about,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        restaurant[RESTAURANT_IMAGE] ??
                            'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (restaurant[RESTAURANT_BUSINESSNAME] != null)
                          Text(
                            restaurant[RESTAURANT_BUSINESSNAME],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        if (restaurant[RESTAURANT_RATING] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: CustomColor.activeColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  restaurant[RESTAURANT_RATING],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding),
                    isThreeLine: false,
                    leading: Container(
                      width: 50,
                      alignment: const Alignment(0, 0),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.phone_in_talk_outlined),
                    ),
                    title: const Text(
                      'Phone',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    subtitle: Text(
                      restaurant[RESTAURANT_PHONE] ?? '',
                      style: const TextStyle(
                          fontSize: 12.0, color: CustomColor.textDetailColor),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding),
                    isThreeLine: false,
                    leading: Container(
                      width: 50,
                      alignment: const Alignment(0, 0),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.email_outlined),
                    ),
                    title: const Text(
                      'E-mail',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    subtitle: Text(
                      restaurant[RESTAURANT_EMAIL] ?? '',
                      style: const TextStyle(
                          fontSize: 12.0, color: CustomColor.textDetailColor),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: Util.mainPadding),
                    isThreeLine: false,
                    leading: Container(
                      width: 50,
                      alignment: const Alignment(0, 0),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.location_on_outlined),
                    ),
                    trailing: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Open Map',
                          style: TextStyle(color: CustomColor.primaryColor),
                        )),
                    title: const Text(
                      'Location',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    subtitle: Text(
                      restaurant[RESTAURANT_ADDRESS] ?? '',
                      style: const TextStyle(
                          fontSize: 12.0, color: CustomColor.textDetailColor),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: Util.mainPadding, vertical: 5),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       const Text(
                  //         'Top Dishes',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold, fontSize: 18),
                  //       ),
                  //       TextButton(
                  //           onPressed: () {
                  //             NavigationRouter.switchToMenu(context);
                  //           },
                  //           child: const Text(
                  //             'Full menu',
                  //             style: TextStyle(
                  //                 color: CustomColor.primaryColor),
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //     height: 160,
                  //     child: FutureBuilder<
                  //             QuerySnapshot<Map<String, dynamic>>>(
                  //         future: AppModel().getFullMenu(),
                  //         builder: (context,
                  //             AsyncSnapshot<
                  //                     QuerySnapshot<Map<String, dynamic>>>
                  //                 snapshot) {
                  //           if (snapshot.hasData) {
                  //             List<Widget> dishView = [];
                  //             for (var menu in snapshot.data!.docs) {
                  //               dishView
                  //                   .add(box(menu.data(), Colors.white));
                  //             }
                  //             return SingleChildScrollView(
                  //                 scrollDirection: Axis.horizontal,
                  //                 child: Row(children: dishView));
                  //           } else {
                  //             return const Processing();
                  //           }
                  //         }))
                ]);

                listView.add(Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Util.mainPadding, 20, Util.mainPadding, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Menu',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'All ITEMS',
                            style: TextStyle(
                                color: CustomColor.textHeadColor,
                                fontWeight: FontWeight.bold),
                          )
                        ])));
                menu.forEach((key, value) {
                  listView.add(Padding(
                      padding: const EdgeInsets.all(0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: Util.mainPadding, vertical: 0),
                        title: Text(
                          value,
                          style: const TextStyle(
                              color: CustomColor.textDetailColor,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          global.menuCategory = key;
                          NavigationRouter.switchToMenu(context);
                        },
                      )));
                });

                listView.add(Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Util.mainPadding, 20, Util.mainPadding, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Daily Special',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ])));

                Widget widget = Padding(
                    padding: const EdgeInsets.all(0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: Util.mainPadding, vertical: 8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: CustomColor.primaryColor.withOpacity(0.2),
                              blurRadius: 8.0,
                            ),
                          ],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  // child: (restaurant[RESTAURANT_IMAGE] != null)
                                  //     ? Image.network(restaurant[RESTAURANT_IMAGE],
                                  //         height: 100, fit: BoxFit.cover)
                                  //     : Image.asset(
                                  //         'assets/group.png',
                                  //         fit: BoxFit.cover,
                                  //       )),
                                  child: Image.asset(
                                    'assets/group.png',
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 20),
                            //   child: _Description(
                            //     caption:
                            //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            //     discount: '50% OFF',
                            //     range: 'UPTO',
                            //     amount: '100',
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ));
                listView.add(widget);

                List<Widget> lists = [];
                for (var item in amenities) {
                  if (restaurant[RESTAURANT_AMENITIES] != null &&
                      restaurant[RESTAURANT_AMENITIES]
                          .contains(item[AMENITY_ID])) {
                    lists.add(SizedBox(
                        width: (MediaQuery.of(context).size.width -
                                Util.mainPadding * 2 -
                                10) /
                            3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Column(children: [
                            Image.asset(
                              'assets/amenities/icon (${item[AMENITY_LOGO]}).png',
                            ),
                            const SizedBox(height: 5),
                            Text(item[AMENITY_NAME],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: CustomColor.textDetailColor))
                          ]),
                        )));
                  }
                }
                if (lists.isNotEmpty) {
                  int rowCount = lists.length ~/ 3;
                  List<Widget> rowList = [];
                  for (int i = 0; i < rowCount + 1; i++) {
                    if (lists.length > 3 * (i + 1)) {
                      rowList.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: lists.sublist(3 * i, 3 * (i + 1))));
                    } else {
                      rowList.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: lists.sublist(3 * i, lists.length)));
                    }
                  }

                  listView.add(Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Util.mainPadding, 20, Util.mainPadding, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Amenities',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ])));
                  listView.add(Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Util.mainPadding, vertical: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width -
                            Util.mainPadding * 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: CustomColor.primaryColor.withOpacity(0.2),
                              blurRadius: 8.0,
                            ),
                          ],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: rowList),
                      )));
                }

                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/background.svg',
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.height * 0.25,
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color:
                                    CustomColor.primaryColor.withOpacity(0.1),
                                blurRadius: 30.0,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.circular(
                                    MediaQuery.of(context).size.width),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.circular(
                                    MediaQuery.of(context).size.width)),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.4,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: CustomColor.primaryColor.withOpacity(0.1),
                              blurRadius: 30.0,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.circular(
                                  MediaQuery.of(context).size.width),
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.zero),
                        ),
                      ),
                    ),
                    ListView(
                      children: listView,
                    )
                  ],
                );
              } else {
                return const Processing();
              }
            }));
  }

  Widget box(Map<String, dynamic> menu, Color backgroundcolor) {
    return Container(
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: 150,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: CustomColor.primaryColor.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: backgroundcolor,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            menu[MENU_PHOTO] != null
                ? Image.network(menu[MENU_PHOTO],
                    width: 80, height: 80, fit: BoxFit.cover)
                : Image.asset('assets/group.png'),
            Text(
                (menu[MENU_NAME].toString().length > 20)
                    ? '${menu[MENU_NAME].toString().substring(0, 16)}...'
                    : menu[MENU_NAME],
                style: const TextStyle(fontSize: 14))
          ],
        ));
  }
}
