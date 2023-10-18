import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;

import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/key.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _searchController = TextEditingController();

  static String location = '';
  static List<Map<String, dynamic>> topMenuList = [];
  static List<Map<String, dynamic>> bestOffers = [];
  static List<Map<String, dynamic>> topBrands = [];
  static List<Map<String, dynamic>> list = [];
  static List<Map<String, dynamic>> carouselList = [];
  static List<Map<String, dynamic>> dailyspecials = [];
  static List<Map<String, dynamic>> searchResults = [];
  static List<String> categories = [];

  String _selectedTopMenu = '';
  int carouselIndicatorCurrent = 0;

  void _getOffer() {
    AppModel().getOffers(
        all: false,
        onSuccess: (List<Map<String, dynamic>> param) {
          bestOffers = param;
        });
  }

  void _getBrand() {
    AppModel().getBrands(
        all: false,
        onSuccess: (List<Map<String, dynamic>> param) {
          topBrands = param;
        });
  }

  void _getList() {
    AppModel().getListByTopMenu(
        topMenu: _selectedTopMenu,
        onSuccess: (List<Map<String, dynamic>> param) {
          list.clear();
          list = param;
          setState(() {});
        });
  }

  void _getDailySpecial() {
    AppModel().getDailySpecial(
      limit: 5,
      onSuccess: (List<Map<String, dynamic>> param) {
        dailyspecials.clear();
        dailyspecials = param;
        setState(() {});
      },
      onEmpty: () {
        dailyspecials.clear();
      },
    );
  }

  _onSearch(String text) async {
    searchResults.clear();
    if (text.isEmpty) {
      return;
    }

    for (var restaurant in list) {
      if (restaurant[RESTAURANT_BUSINESSNAME]
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        searchResults.add(restaurant);
      }
    }
    setState(() {});
  }

  String _getDistance(List<dynamic> geolocation) {
    double distance = Geolocator.distanceBetween(
        globals.latitude, globals.longitude, geolocation[0], geolocation[1]);
    distance = distance / 1000;
    return distance.toStringAsFixed(1);
  }

  Future<void> _onLocation(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
        logo: const Text(''),
        context: context,
        radius: 100000000,
        types: [],
        strictbounds: false,
        mode: Mode.overlay,
        language: "en",
        components: [Component(Component.country, "us")],
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: CustomColor.primaryColor)),
        ),
        apiKey: kGoogleApiKey);
    if (p != null) {
      final placeDetails = await GoogleMapsPlaces(apiKey: kGoogleApiKey)
          .getDetailsByPlaceId(p.placeId!);
      setState(() {
        location = placeDetails.result.formattedAddress!;
      });
    }
    if (p != null) getGeoInfo(p);
  }

  Future<void> getGeoInfo(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      globals.searchFullAddress = location;
      globals.searchPriority = globals.searchFullAddress
              .contains(placemarks[0].postalCode.toString())
          ? RESTAURANT_ZIP
          : RESTAURANT_CITY;
      globals.searchCity = placemarks[0].locality!;
      globals.searchZip = placemarks[0].postalCode.toString();
      if (_selectedTopMenu.isEmpty) {
        _getBrand();
        _getOffer();
      } else {
        _getList();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    location = globals.searchFullAddress;
    AppModel().getCategory(onSuccess: (Map<String, dynamic> param) {
      param.forEach((key, value) {
        if (value) categories.add(key);
      });
    });
    _getDailySpecial();
    _getBrand();
    _getOffer();
    AppModel().getTopMenu(
      onSuccess: (List<Map<String, dynamic>> param) {
        topMenuList = param;
        setState(() {});
      },
      onEmpty: () {},
    );
  }

  @override
  void dispose() {
    categories.clear();
    topBrands.clear();
    bestOffers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    carouselList = [
      {
        "title": Util.featured,
        "image":
            'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
        "bio": "Lorem ipsum dolor sit\n amet, consectetur adip\niscing elit.",
        "eventCaption": Util.buttonMore
      }
    ];
    for (var dailyspecial in dailyspecials) {
      carouselList.add({
        "title": Util.dailySpecial,
        "image": dailyspecial[DAILYSPECIAL_IMAGE_LINK],
        "bio": dailyspecial[DAILYSPECIAL_DESC],
        "eventCaption": Util.showAll
      });
    }

    final List<Widget> imageSliders = carouselList
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
                            Image.network(
                              item["image"],
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            const SizedBox(width: 10),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item["title"].toString().toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
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
                                                  Util.featured) {
                                                NavigationRouter
                                                    .switchToWebview(context);
                                              }
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
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: CustomColor.activeColor,
                                  size: 10,
                                ),
                                Text(
                                  '${_getDistance(element[RESTAURANT_GEOLOCATION])}km',
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      color: CustomColor.textDetailColor),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Icon(
                                  Icons.access_time,
                                  size: 10,
                                  color: CustomColor.textDetailColor,
                                ),
                                const Text(
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

    return Scaffold(
      body: Stack(
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
          Column(children: [
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
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          NavigationRouter.back(context);
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Location',
                            style:
                                TextStyle(color: CustomColor.textDetailColor),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                              TextButton(
                                  onPressed: () {
                                    _onLocation(context);
                                  },
                                  child: Text(
                                    location.length < 32
                                        ? location
                                        : '${location.substring(0, 32)}..',
                                    style: const TextStyle(color: Colors.white),
                                  ))
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
                    controller: _searchController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(),
                      hintText: 'Search Restaurant or Food...',
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 50,
                        minHeight: 2,
                      ),
                      prefixIcon: Icon(Icons.search_outlined, size: 24),
                    ),
                    onChanged: _onSearch,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Util.mainPadding),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          Util.categories,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
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
                            return categoryBox(
                                topmenu, CustomColor.primaryColor);
                          }).toList(),
                        ))),
              ]),
            ),
            if (_selectedTopMenu.isEmpty)
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
                      children: carouselList.asMap().entries.map((entry) {
                        return Container(
                          width:
                              (carouselIndicatorCurrent == entry.key ? 34 : 16),
                          height: 5.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: (carouselIndicatorCurrent == entry.key
                                  ? CustomColor.primaryColor
                                  : CustomColor.textDetailColor
                                      .withOpacity(0.5))),
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
                            TextButton(
                              onPressed: () {
                                globals.listTarget = 'brands';
                                NavigationRouter.switchToList(context);
                              },
                              child: const Text(
                                Util.seeAll,
                                style:
                                    TextStyle(color: CustomColor.activeColor),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                        height: 130,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: topBrands.map((brand) {
                                return brandBox(brand);
                              }).toList(),
                            ))),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Util.mainPadding),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              Util.homeBestOffers,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            TextButton(
                              onPressed: () {
                                globals.listTarget = 'offers';
                                NavigationRouter.switchToList(context);
                              },
                              child: const Text(
                                Util.seeAll,
                                style:
                                    TextStyle(color: CustomColor.activeColor),
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
            if (_selectedTopMenu.isNotEmpty)
              Expanded(
                child: ListBuilder(
                  isSelectionMode: false,
                  list: _searchController.text.trim().isEmpty
                      ? list
                      : searchResults,
                  onSelectionChange: (bool x) {},
                ),
              ),
          ]),
        ],
      ),
    );
  }

  Widget categoryBox(Map<String, dynamic> item, Color backgroundcolor) {
    return InkWell(
        onTap: () {
          setState(() {
            _selectedTopMenu = item[TOPMENU_ID];
          });
          _getList();
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

  Widget brandBox(Map<String, dynamic> brand) {
    return InkWell(
        onTap: () {
          AppModel().setRestaurant(
              restaurant: brand,
              onSuccess: () => NavigationRouter.switchToAbout(context));
        },
        child: Container(
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
                child: Image.network(
                  brand[RESTAURANT_IMAGE] ??
                      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(brand[RESTAURANT_BUSINESSNAME].toString().length < 10
                      ? brand[RESTAURANT_BUSINESSNAME].toString()
                      : '${brand[RESTAURANT_BUSINESSNAME].toString().substring(0, 10)}..'),
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
                      Text(
                        '${_getDistance(brand[RESTAURANT_GEOLOCATION])}km',
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
                              '4.8',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
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
              InkWell(
                  onTap: () {
                    AppModel().setFavourite(
                        restaurantID: brand[RESTAURANT_ID],
                        onSuccess: () {
                          setState(() {});
                        });
                  },
                  child: Icon(
                    globals.userFavourites.contains(brand[RESTAURANT_ID])
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    color: CustomColor.activeColor,
                  ))
            ],
          ),
        ));
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
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: SizedBox(
                  height: 160,
                  child: InkWell(
                      onTap: () {
                        globals.restaurantID = restaurant[RESTAURANT_ID];
                        NavigationRouter.switchToAbout(context);
                      },
                      child: Card(
                          color: (widget.isSelectionMode
                              ? CustomColor.primaryColor
                              : Colors.white),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          shadowColor:
                              CustomColor.primaryColor.withOpacity(0.2),
                          elevation: 8,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  child: restaurant[RESTAURANT_IMAGE] != null
                                      ? Image.network(
                                          restaurant[RESTAURANT_IMAGE],
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover)
                                      : Image.asset('assets/group.png',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (restaurant[RESTAURANT_BUSINESSNAME]
                                                    .toString()
                                                    .length <
                                                17)
                                            ? restaurant[
                                                RESTAURANT_BUSINESSNAME]
                                            : '${restaurant[RESTAURANT_BUSINESSNAME].toString().substring(0, 15)}..',
                                        style: TextStyle(
                                            color: (widget.isSelectionMode
                                                ? Colors.white
                                                : CustomColor.primaryColor),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      if (restaurant[RESTAURANT_ADDRESS] !=
                                          null)
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                Util.mainPadding * 2 -
                                                170,
                                            child: Text(
                                              (restaurant[RESTAURANT_ADDRESS]
                                                          .toString()
                                                          .trim()
                                                          .length <
                                                      100)
                                                  ? restaurant[
                                                      RESTAURANT_ADDRESS]
                                                  : '${restaurant[RESTAURANT_ADDRESS].toString().substring(0, 100)}...',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: (widget.isSelectionMode
                                                      ? Colors.white
                                                      : CustomColor
                                                          .textHeadColor)),
                                            )),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              Util.mainPadding * 2 -
                                              170,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  restaurant[RESTAURANT_ZIP],
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 15.0,
                                                      color: (widget
                                                              .isSelectionMode
                                                          ? Colors.white
                                                          : Colors.black),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        CustomColor.activeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: const [
                                                      Text(
                                                        '4.8',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.white,
                                                        size: 12,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ])),
                                    ])
                              ]))))));
        });
  }
}
