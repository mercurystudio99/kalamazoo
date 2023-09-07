import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/widget/accordion.dart';

final List<Map<String, dynamic>> imgList = [
  {
    "title": Util.featured,
    "image": "assets/burger.png",
    "bio": "Lorem ipsum dolor sit\n amet, consectetur adip\niscing elit.",
    "eventCaption": Util.buttonMore
  },
  {
    "title": Util.dailySpecial,
    "image": "assets/plate.png",
    "bio": "Lorem ipsum dolor sit\n amet, consectetur adip\niscing elit.",
    "eventCaption": Util.showAll
  }
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _advancedDrawerController = AdvancedDrawerController();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  bool _setting = true;
  int _selectedIndex = 0;
  String _selectedTopMenu = '';
  bool isSelectionMode = false;
  bool _showDaysHours = false;
  int carouselIndicatorCurrent = 0;
  static List<String> categories = [];
  static List<Map<String, dynamic>> bestOffers = [];
  static List<Map<String, dynamic>> favourites = [];
  static List<Map<String, dynamic>> topMenuList = [];
  static Map<String, dynamic> profile = {};

  final _searchFavoriteController = TextEditingController();

  static final List<Map<String, dynamic>> _searchFavorites = [];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  _onSearchFavorite(String text) async {
    _searchFavorites.clear();
    if (text.isEmpty) {
      return;
    }

    for (var favorite in favourites) {
      if (favorite[RESTAURANT_BUSINESSNAME].contains(text)) {
        _searchFavorites.add(favorite);
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      if (globals.userFavourites.isNotEmpty) {
        AppModel().getFavourites(onSuccess: (List<Map<String, dynamic>> param) {
          favourites = param;
        });
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _setCredential() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('credential', '').then((bool success) {});
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    super.initState();
    initializeSelection();
    _getCurrentPosition();
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(position.latitude, position.longitude);
    // String output = 'No results found.';
    // if (placemarks.isNotEmpty) {
    //   output = placemarks[0].toString();
    // }
  }

  void initializeSelection() {
    AppModel().getCategory(onSuccess: (Map<String, dynamic> param) {
      param.forEach((key, value) {
        if (value) categories.add(key);
      });
      AppModel().getData(onSuccess: (List<Map<String, dynamic>> param) {
        bestOffers = param;
      });
    });
    if (globals.userFavourites.isNotEmpty) {
      AppModel().getFavourites(onSuccess: (List<Map<String, dynamic>> param) {
        favourites = param;
      });
    }
    AppModel().getTopMenu(
      onSuccess: (List<Map<String, dynamic>> param) {
        topMenuList = param;
        setState(() {});
        debugPrint("$topMenuList");
      },
      onEmpty: () {},
    );
    AppModel().getProfile(onSuccess: (Map<String, dynamic> param) {
      profile = param;
    });
  }

  @override
  void dispose() {
    favourites.clear();
    categories.clear();
    bestOffers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bestOffersView = [];
    for (var element in bestOffers) {
      Widget widget = SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Stack(children: [
          InkWell(
              onTap: () {
                AppModel().setRestaurant(
                    restaurant: element,
                    onSuccess: () => NavigationRouter.switchToAbout(context));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                shadowColor: CustomColor.primaryColor.withOpacity(0.2),
                elevation: 8,
                margin: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        element[RESTAURANT_IMAGE] ??
                            'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                element[RESTAURANT_BUSINESSNAME].length < 15
                                    ? element[RESTAURANT_BUSINESSNAME]
                                    : element[RESTAURANT_BUSINESSNAME]
                                            .substring(0, 12) +
                                        '...',
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                element[RESTAURANT_URL].length < 18
                                    ? element[RESTAURANT_URL]
                                    : element[RESTAURANT_URL].substring(0, 15) +
                                        '...',
                                style: const TextStyle(
                                    fontSize: 10.0,
                                    color: CustomColor.textDetailColor),
                              ),
                            ],
                          ),
                          if (element[RESTAURANT_RATING] != null)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: CustomColor.activeColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    element[RESTAURANT_RATING],
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (element[RESTAURANT_DISCOUNT] != null)
                                Text(
                                  '${element[RESTAURANT_DISCOUNT]}% OFF',
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      color: CustomColor.activeColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              if (element[RESTAURANT_MINCOST] != null)
                                Text(
                                  'UPTO \$${element[RESTAURANT_MINCOST]}',
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      color: CustomColor.textDetailColor),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: CustomColor.activeColor,
                                  size: 10,
                                ),
                                Text(
                                  '1.2km',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: CustomColor.textDetailColor),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.access_time,
                                  size: 10,
                                  color: CustomColor.textDetailColor,
                                ),
                                Text(
                                  '10min',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: CustomColor.textDetailColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              right: 10,
              top: 10,
              child: InkWell(
                  onTap: () {
                    AppModel().setFavourite(
                        restaurantID: element[RESTAURANT_ID],
                        onSuccess: () {
                          setState(() {});
                        });
                  },
                  child: Icon(
                    globals.userFavourites.contains(element[RESTAURANT_ID])
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    color: CustomColor.activeColor,
                  )))
        ]),
      );
      bestOffersView.add(widget);
    }

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF9E5),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: CustomColor.activeColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.circular(100)),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(children: [
                            const SizedBox(width: 30),
                            Image.asset(item["image"]),
                            const SizedBox(width: 10),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item["title"].toString().toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Util.titleSize)),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: item["bio"],
                                        style: GoogleFonts.poppins(
                                            color: CustomColor.textDetailColor,
                                            fontSize: Util.descriptionSize),
                                      )
                                    ]),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: SizedBox(
                                          height: 35, //height of button
                                          width: 100, //width of button
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation:
                                                    0, //elevation of button
                                                shape: RoundedRectangleBorder(
                                                    //to set border radius to button
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                padding: const EdgeInsets.all(
                                                    5) //content padding inside button
                                                ),
                                            onPressed: () {
                                              if (item["title"].toString() ==
                                                  Util.dailySpecial) {
                                                NavigationRouter
                                                    .switchToDailySpecial(
                                                        context);
                                              }
                                            },
                                            child: Text(
                                              item["eventCaption"]
                                                  .toString()
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  color: CustomColor
                                                      .buttonTextColor,
                                                  fontSize: 15),
                                            ),
                                          ))),
                                ])
                          ]))
                    ],
                  )),
            ))
        .toList();

    // 4 screens
    final List<Widget> widgetOptions = <Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
          color: CustomColor.primaryColor,
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: Util.mainPadding * 0.5, right: Util.mainPadding),
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
                          child: Image.asset(
                            'assets/menu.png',
                            key: ValueKey<bool>(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(color: CustomColor.textDetailColor),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          Text(
                            'Kalamazoo, Michigon',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigationRouter.switchToNotification(context);
                    },
                    child: const badges.Badge(
                      badgeContent: Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Util.mainPadding, vertical: 12.0),
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
                onTap: () {
                  NavigationRouter.switchToSearch(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      Util.categories,
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        Util.seeAll,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
                height: 70,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: topMenuList.map((topmenu) {
                        return categoryBox(topmenu, CustomColor.primaryColor);
                      }).toList(),
                    ))),
          ]),
        ),
        Expanded(
          child: ListView(
            children: [
              CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    autoPlay: true,
                    pageViewKey:
                        const PageStorageKey<String>('carousel_slider'),
                    onPageChanged: (index, reason) {
                      setState(() {
                        carouselIndicatorCurrent = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return Container(
                    width: (carouselIndicatorCurrent == entry.key ? 34 : 16),
                    height: 5.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: (carouselIndicatorCurrent == entry.key
                            ? CustomColor.primaryColor
                            : CustomColor.textDetailColor.withOpacity(0.5))),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding, vertical: 4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        Util.homeTopBrands,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          Util.seeAll,
                          style: TextStyle(color: CustomColor.activeColor),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                  height: 130,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          return brandBox(
                              category, categories.indexOf(category));
                        }).toList(),
                      ))),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Util.mainPadding),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        Util.homeBestOffers,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          Util.seeAll,
                          style: TextStyle(color: CustomColor.activeColor),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding, vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: bestOffersView),
              ),
            ],
          ),
        ),
      ]),
      // Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      //   Expanded(
      //     child: ListView(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.symmetric(
      //               horizontal: Util.mainPadding * 0.5),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               IconButton(
      //                 onPressed: _handleMenuButtonPressed,
      //                 icon: ValueListenableBuilder<AdvancedDrawerValue>(
      //                   valueListenable: _advancedDrawerController,
      //                   builder: (_, value, __) {
      //                     return AnimatedSwitcher(
      //                       duration: const Duration(milliseconds: 250),
      //                       child: Image.asset(
      //                         'assets/menu.png',
      //                         key: ValueKey<bool>(value.visible),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               ),
      //               const Spacer(),
      //               const Icon(
      //                 Icons.location_on,
      //                 color: Colors.red,
      //               ),
      //               const Text(
      //                 'Kalamazoo, Michigan, USA',
      //                 style: TextStyle(color: CustomColor.textDetailColor),
      //               ),
      //               const Spacer(),
      //               const Icon(
      //                 Icons.sort,
      //                 color: Colors.black,
      //               ),
      //               const Text(
      //                 'Sort',
      //                 style: TextStyle(color: Colors.black),
      //               ),
      //               const Spacer(),
      //               const Icon(
      //                 Icons.diamond,
      //                 color: Colors.black,
      //               ),
      //               const Text(
      //                 'Offer',
      //                 style: TextStyle(color: Colors.black),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Padding(
      //             padding: const EdgeInsets.symmetric(
      //                 horizontal: Util.mainPadding, vertical: 10),
      //             child: Stack(children: [
      //               Container(
      //                 height: 50,
      //                 decoration: BoxDecoration(
      //                   borderRadius:
      //                       const BorderRadius.all(Radius.circular(14)),
      //                   boxShadow: [
      //                     BoxShadow(
      //                         color: CustomColor.primaryColor.withOpacity(0.2),
      //                         blurRadius: 5,
      //                         spreadRadius: 1),
      //                   ],
      //                 ),
      //               ),
      //               TextFormField(
      //                 decoration: InputDecoration(
      //                     contentPadding: const EdgeInsets.all(4),
      //                     border: const OutlineInputBorder(),
      //                     hintText: 'Search Restaurant or Food...',
      //                     hintStyle: const TextStyle(
      //                         color: CustomColor.textDetailColor),
      //                     prefixIconConstraints: const BoxConstraints(
      //                       minWidth: 50,
      //                       minHeight: 2,
      //                     ),
      //                     prefixIcon:
      //                         const Icon(Icons.search_outlined, size: 24),
      //                     suffixIcon: IconButton(
      //                         onPressed: () {},
      //                         icon: Image.asset('assets/filter.png'))),
      //                 onTap: () {
      //                   NavigationRouter.switchToSearch(context);
      //                 },
      //               ),
      //             ])),
      //         const SizedBox(height: 10),
      //         Padding(
      //             padding: const EdgeInsets.symmetric(
      //                 horizontal: Util.mainPadding, vertical: 5),
      //             child: Container(
      //                 decoration: const BoxDecoration(
      //                   color: CustomColor.activeColor,
      //                   borderRadius: BorderRadius.all(Radius.circular(8)),
      //                 ),
      //                 child: Padding(
      //                     padding: const EdgeInsets.fromLTRB(15, 10, 12, 10),
      //                     child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: const [
      //                           Text(
      //                             'FEATURED',
      //                             style: TextStyle(
      //                                 color: Colors.white, fontSize: 20),
      //                           ),
      //                           Icon(
      //                             Icons.keyboard_arrow_down,
      //                             color: Colors.white,
      //                           )
      //                         ])))),
      //         const Padding(
      //           padding: EdgeInsets.symmetric(
      //               horizontal: Util.mainPadding, vertical: 10),
      //           child: Accordion(
      //             contents: <String>[
      //               'Breweries',
      //               'Food Trucks',
      //               'Restaurants',
      //               'Wineries'
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ]),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: <Widget>[
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     Padding(
      //       padding:
      //           const EdgeInsets.symmetric(horizontal: Util.mainPadding * 0.5),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           IconButton(
      //             icon: const Icon(Icons.arrow_back_ios),
      //             onPressed: () {
      //               _onItemTapped(0);
      //             },
      //           ),
      //           const Text(
      //             Util.favorite,
      //             style: TextStyle(
      //               color: CustomColor.primaryColor,
      //               fontSize: 22.0,
      //             ),
      //           ),
      //           const SizedBox(
      //             width: Util.mainPadding,
      //           ),
      //         ],
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.only(
      //           left: Util.mainPadding, right: Util.mainPadding, bottom: 20),
      //       child: Material(
      //         borderRadius: const BorderRadius.all(Radius.circular(14)),
      //         elevation: 8,
      //         shadowColor: CustomColor.primaryColor.withOpacity(0.2),
      //         child: TextFormField(
      //           controller: _searchFavoriteController,
      //           decoration: const InputDecoration(
      //             border: OutlineInputBorder(),
      //             hintText: 'Search Restaurant or Food...',
      //             prefixIconConstraints: BoxConstraints(
      //               minWidth: 50,
      //               minHeight: 2,
      //             ),
      //             prefixIcon: Icon(Icons.search_outlined, size: 24),
      //           ),
      //           autovalidateMode: AutovalidateMode.always,
      //           validator: (value) {
      //             if (value!.contains('\n')) {}
      //             return null;
      //           },
      //           onChanged: _onSearchFavorite,
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: ListBuilder(
      //         isSelectionMode: isSelectionMode,
      //         list: (_searchFavorites.isNotEmpty ||
      //                 _searchFavoriteController.text.isNotEmpty)
      //             ? _searchFavorites
      //             : favourites,
      //         onSelectionChange: (bool x) {
      //           setState(() {
      //             isSelectionMode = x;
      //           });
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 50),
          ]),
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 50),
          ]),
      Stack(
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
            ],
          ),
          Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.25,
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
                    topRight:
                        Radius.circular(MediaQuery.of(context).size.width),
                    bottomLeft: Radius.zero,
                    bottomRight:
                        Radius.circular(MediaQuery.of(context).size.width)),
              ),
            ),
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
                    topRight:
                        Radius.circular(MediaQuery.of(context).size.width),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero),
              ),
            ),
          ),
          ListView(
            children: [
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
                        _onItemTapped(0);
                      },
                    ),
                    const Text(
                      Util.profileTitle,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                margin: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30.0,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: (profile[USER_PROFILE_PHOTO] == null)
                          ? Container(color: Colors.blueGrey)
                          : Image.network(
                              profile[USER_PROFILE_PHOTO],
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        profile[USER_FULLNAME] ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 4.0, horizontal: Util.mainPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      Util.profileContact,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextButton(
                        onPressed: () {
                          NavigationRouter.switchToProfileEdit(context);
                        },
                        child: const Text(
                          Util.edit,
                          style: TextStyle(color: CustomColor.primaryColor),
                        )),
                  ],
                ),
              ),
              if (profile[USER_ROLE] == Util.customer)
                Expanded(
                    child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(Icons.email_outlined,
                              color: CustomColor.textDetailColor),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              profile[USER_EMAIL] ?? '',
                              style: const TextStyle(
                                  color: CustomColor.textDetailColor,
                                  fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(Icons.location_on_outlined,
                              color: CustomColor.textDetailColor),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(profile[USER_LOCATION] ?? '',
                                style: const TextStyle(
                                    color: CustomColor.textDetailColor,
                                    fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(Icons.person_outline,
                              color: CustomColor.textDetailColor),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gender',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(profile[USER_GENDER] ?? '',
                                style: const TextStyle(
                                    color: CustomColor.textDetailColor,
                                    fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(
                            Icons.calendar_month,
                            color: CustomColor.textDetailColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Birth Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                (profile[USER_BIRTH_DAY] == null ||
                                        profile[USER_BIRTH_MONTH] == null ||
                                        profile[USER_BIRTH_YEAR] == null)
                                    ? ''
                                    : '${profile[USER_BIRTH_DAY]} ${profile[USER_BIRTH_MONTH]} ${profile[USER_BIRTH_YEAR]}',
                                style: const TextStyle(
                                    color: CustomColor.textDetailColor,
                                    fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                ])),
              if (profile[USER_ROLE] == Util.owner)
                Expanded(
                    child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(Icons.cases_outlined,
                              color: CustomColor.textDetailColor),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Business Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '',
                              style: TextStyle(
                                  color: CustomColor.textDetailColor,
                                  fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(Icons.phone_outlined,
                              color: CustomColor.textDetailColor),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phone Number',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(profile[USER_PHONE_NUMBER] ?? '',
                                style: const TextStyle(
                                    color: CustomColor.textDetailColor,
                                    fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(Icons.location_on_outlined,
                              color: CustomColor.textDetailColor),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Full Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(profile[USER_LOCATION] ?? '',
                                style: const TextStyle(
                                    color: CustomColor.textDetailColor,
                                    fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(
                            Icons.email_outlined,
                            color: CustomColor.textDetailColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(profile[USER_EMAIL] ?? '',
                                style: const TextStyle(
                                    color: CustomColor.textDetailColor,
                                    fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          alignment: const Alignment(0, 0),
                          child: const Icon(
                            Icons.dinner_dining,
                            color: CustomColor.textDetailColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Service Category',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(children: const [
                              SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Brewery',
                                    style: TextStyle(
                                        color: CustomColor.textDetailColor,
                                        fontSize: 12),
                                  )),
                              SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Food Truck',
                                    style: TextStyle(
                                        color: CustomColor.textDetailColor,
                                        fontSize: 12),
                                  )),
                            ]),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: Util.mainPadding),
                    child: Stack(children: [
                      Container(
                        margin: const EdgeInsets.all(0),
                        child: Column(children: [
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              alignment: const Alignment(0, 0),
                              child: const Icon(
                                Icons.access_time,
                                color: CustomColor.textDetailColor,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            const Text(
                              'Business Day/Hours',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                _showDaysHours
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_right,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showDaysHours = !_showDaysHours;
                                });
                              },
                            ),
                          ]),
                          // Show or hide the content based on the state
                          _showDaysHours
                              ? Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text('Tuesday',
                                                      style: TextStyle(
                                                          color: CustomColor
                                                              .textDetailColor,
                                                          fontSize: 12)),
                                                  const Spacer(),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text('Closed',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .activeColor,
                                                            fontSize: 12)),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 22,
                                                      )),
                                                ])),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text('Wednesday',
                                                      style: TextStyle(
                                                          color: CustomColor
                                                              .textDetailColor,
                                                          fontSize: 12)),
                                                  const Spacer(),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 12)),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 22,
                                                      )),
                                                ])),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text('Thursday',
                                                      style: TextStyle(
                                                          color: CustomColor
                                                              .textDetailColor,
                                                          fontSize: 12)),
                                                  const Spacer(),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 12)),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 22,
                                                      )),
                                                ])),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text('Friday',
                                                      style: TextStyle(
                                                          color: CustomColor
                                                              .textDetailColor,
                                                          fontSize: 12)),
                                                  const Spacer(),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 12)),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 22,
                                                      )),
                                                ])),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text('Saturday',
                                                      style: TextStyle(
                                                          color: CustomColor
                                                              .textDetailColor,
                                                          fontSize: 12)),
                                                  const Spacer(),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 12)),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 22,
                                                      )),
                                                ])),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text('Sunday',
                                                      style: TextStyle(
                                                          color: CustomColor
                                                              .textDetailColor,
                                                          fontSize: 12)),
                                                  const Spacer(),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 12)),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 22,
                                                      )),
                                                ])),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text('Monday',
                                                      style: TextStyle(
                                                          color: CustomColor
                                                              .textDetailColor,
                                                          fontSize: 12)),
                                                  const Spacer(),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text('Closed',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .activeColor,
                                                            fontSize: 12)),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 22,
                                                      )),
                                                ])),
                                      ]),
                                )
                              : Container(),
                        ]),
                      )
                    ]),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
                      child: Center(
                          child: SizedBox(
                              height: 35, //height of button
                              width: MediaQuery.of(context).size.width *
                                  0.55, //width of button
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0, //elevation of button
                                    shape: RoundedRectangleBorder(
                                        //to set border radius to button
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.all(
                                        5) //content padding inside button
                                    ),
                                onPressed: () {},
                                child: Text(
                                  'UPLOAD MENU',
                                  style: TextStyle(
                                      color: CustomColor.buttonTextColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035),
                                ),
                              )))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
                      child: Center(
                          child: SizedBox(
                              height: 35, //height of button
                              width: MediaQuery.of(context).size.width *
                                  0.55, //width of button
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0, //elevation of button
                                    shape: RoundedRectangleBorder(
                                        //to set border radius to button
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.all(
                                        5) //content padding inside button
                                    ),
                                onPressed: () {},
                                child: Text(
                                  'PROMOTE YOUR BUSINESS',
                                  style: TextStyle(
                                      color: CustomColor.buttonTextColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035),
                                ),
                              )))),
                  const SizedBox(height: 30)
                ]))
            ],
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
      backdrop: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/background.svg',
            width: MediaQuery.of(context).size.width,
          ),
        ],
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
            color: CustomColor.primaryColor,
            blurRadius: 30.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: CustomColor.textDetailColor,
          iconColor: CustomColor.textDetailColor,
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
                            color: CustomColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'demo@gmail.com',
                          style: TextStyle(
                            color: CustomColor.textDetailColor,
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
                    color: CustomColor.activeColor,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: CustomColor.activeColor),
                  ),
                ),
                // ListTile(
                //   onTap: () {},
                //   leading: const Icon(Icons.wallet_giftcard),
                //   title: const Text('Offer & Promos'),
                // ),
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
                if (profile[USER_ROLE] == Util.owner)
                  ListTile(
                    onTap: () {
                      NavigationRouter.switchToSubscription(context);
                    },
                    leading: const Icon(Icons.subscriptions_outlined),
                    title: const Text('Subscription'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                // ListTile(
                //   onTap: () {},
                //   leading: const Icon(Icons.settings_outlined),
                //   title: const Text('Setting'),
                //   trailing: Switch(
                //     // This bool value toggles the switch.
                //     value: _setting,
                //     // activeColor: Colors.red,
                //     onChanged: (bool value) {
                //       // This is called when the user toggles the switch.
                //       setState(() {
                //         _setting = value;
                //       });
                //     },
                //   ),
                // ),
                ListTile(
                  onTap: () {
                    _setCredential();
                    NavigationRouter.switchToLogin(context);
                  },
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
          iconSize: 40,
          elevation: 0,
          unselectedIconTheme: const IconThemeData(
            color: Colors.white,
          ),
          unselectedItemColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: SvgPicture.asset((_selectedIndex == 0)
                    ? 'assets/footer/home-red.svg'
                    : 'assets/footer/home-white.svg'),
                label: 'Home',
                backgroundColor: CustomColor.primaryColor),
            BottomNavigationBarItem(
                icon: SvgPicture.asset((_selectedIndex == 1)
                    ? 'assets/footer/browse-red.svg'
                    : 'assets/footer/browse-white.svg'),
                label: 'Browse',
                backgroundColor: CustomColor.primaryColor),
            BottomNavigationBarItem(
                icon: SvgPicture.asset((_selectedIndex == 2)
                    ? 'assets/footer/rewards-red.svg'
                    : 'assets/footer/rewards-white.svg'),
                label: 'Rewards',
                backgroundColor: CustomColor.primaryColor),
            BottomNavigationBarItem(
                icon: SvgPicture.asset((_selectedIndex == 3)
                    ? 'assets/footer/account-red.svg'
                    : 'assets/footer/account-white.svg'),
                label: 'Account',
                backgroundColor: CustomColor.primaryColor),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: CustomColor.activeColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget categoryBox(Map<String, dynamic> item, Color backgroundcolor) {
    return InkWell(
        onTap: () {
          setState(() {
            _selectedTopMenu = item[TOPMENU_ID];
          });
        },
        child: Container(
            margin:
                const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 12),
            width: 65,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
              color: _selectedTopMenu == item[TOPMENU_ID]
                  ? CustomColor.activeColor
                  : backgroundcolor,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/topmenu/${item[TOPMENU_IMAGE]}.png",
                    width: 25, height: 25),
                Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                        item[TOPMENU_NAME].toString().length <= 10
                            ? item[TOPMENU_NAME].toString()
                            : '${item[TOPMENU_NAME].toString().substring(0, 8)}..',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10))),
              ],
            )));
  }

  Widget brandBox(String title, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.all(4),
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: CustomColor.primaryColor.withOpacity(0.2),
            blurRadius: 8.0,
          ),
        ],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Image.asset(
                'assets/group.png',
                fit: BoxFit.cover,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Mc Donald\'S'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/dish.svg'),
                  const Text(
                    'Burger',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: CustomColor.textDetailColor,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.location_on,
                    color: CustomColor.activeColor,
                    size: 12,
                  ),
                  const Text(
                    '1.2km',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: CustomColor.textDetailColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: CustomColor.activeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          '4.8',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Icon(
                    Icons.access_time,
                    size: 12,
                  ),
                  const Text(
                    '10min',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: CustomColor.textDetailColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.bookmark_border_outlined,
            color: CustomColor.activeColor,
          ),
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
          final Map<String, dynamic> restaurant = widget.list[index];
          return GestureDetector(
            onTap: () {
              AppModel().setRestaurant(
                  restaurant: restaurant,
                  onSuccess: () => NavigationRouter.switchToAbout(context));
            },
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: (restaurant[RESTAURANT_IMAGE] != null)
                            ? Image.network(restaurant[RESTAURANT_IMAGE],
                                height: 100, fit: BoxFit.cover)
                            : Image.asset(
                                'assets/group.png',
                                fit: BoxFit.cover,
                              )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _ArticleDescription(
                      title: restaurant[RESTAURANT_BUSINESSNAME],
                      subtitle: 'Coffee',
                      author: '50% OFF',
                      publishDate: 'UPTO',
                      readDuration: '100',
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.bookmark,
                    color: CustomColor.activeColor,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
    required this.readDuration,
  });

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title.length < 14 ? title : '${title.substring(0, 10)}...',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Icon(
              Icons.center_focus_strong,
              color: Colors.green,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/dish.svg'),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.0,
                color: CustomColor.textDetailColor,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: CustomColor.activeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Text(
                    '5.3',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 12,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.location_on,
              color: CustomColor.activeColor,
              size: 12,
            ),
            const Text(
              '1.2km',
              style: TextStyle(
                fontSize: 12.0,
                color: CustomColor.textDetailColor,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            const Icon(
              Icons.access_time,
              size: 12,
            ),
            const Text(
              '10min',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.0,
                color: CustomColor.textDetailColor,
              ),
            ),
          ],
        ),
        Text(
          author,
          style: const TextStyle(
              color: CustomColor.activeColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        Text(
          '$publishDate  $readDuration',
          style:
              const TextStyle(color: CustomColor.textDetailColor, fontSize: 10),
        )
      ],
    );
  }
}
