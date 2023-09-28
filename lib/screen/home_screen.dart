import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/widget/accordion.dart';
import 'package:kalamazoo/key.dart';

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
  bool isSelectionMode = false;
  bool _showDaysHours = false;
  static List<Map<String, dynamic>> favourites = [];

  static Map<String, dynamic> profile = {};

  final _searchFavoriteController = TextEditingController();
  static String location = '';

  static final List<Map<String, dynamic>> _searchFavorites = [];

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

  Future<void> _onLocation(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
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
    }
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
    location = globals.searchFullAddress;
    if (globals.userFavourites.isNotEmpty) {
      AppModel().getFavourites(onSuccess: (List<Map<String, dynamic>> param) {
        favourites = param;
      });
    }
    AppModel().getProfile(onSuccess: (Map<String, dynamic> param) {
      profile = param;
    });
  }

  @override
  void dispose() {
    favourites.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4 screens
    final List<Widget> widgetOptions = <Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding * 0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    const Spacer(),
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    TextButton(
                        onPressed: () {
                          _onLocation(context);
                        },
                        child: Text(
                          location.length < 20
                              ? location
                              : '${location.substring(0, 20)}..',
                          style: const TextStyle(color: Colors.black),
                        )),
                    const Spacer(),
                    const Icon(
                      Icons.sort,
                      color: Colors.black,
                    ),
                    const Text(
                      'Sort',
                      style: TextStyle(color: Colors.black),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.diamond,
                      color: Colors.black,
                    ),
                    const Text(
                      'Offer',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Util.mainPadding, vertical: 10),
                  child: Stack(children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        boxShadow: [
                          BoxShadow(
                              color: CustomColor.primaryColor.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 1),
                        ],
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(4),
                          border: const OutlineInputBorder(),
                          hintText: 'Search Restaurant or Food...',
                          hintStyle: const TextStyle(
                              color: CustomColor.textDetailColor),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 50,
                            minHeight: 2,
                          ),
                          prefixIcon:
                              const Icon(Icons.search_outlined, size: 24),
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset('assets/filter.png'))),
                      onFieldSubmitted: (value) async {
                        globals.searchKeyword = value;
                        await NavigationRouter.switchToSearch(context);
                        setState(() {
                          location = globals.searchFullAddress;
                        });
                      },
                    ),
                  ])),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Util.mainPadding, vertical: 5),
                  child: InkWell(
                      onTap: () => NavigationRouter.switchToMain(context),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: CustomColor.activeColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 12, 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'FEATURED',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    )
                                  ]))))),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Util.mainPadding, vertical: 10),
                child: Accordion(
                  contents: <String>[
                    'Breweries',
                    'Food Trucks',
                    'Restaurants',
                    'Wineries'
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
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
                          children: [
                            const Text(
                              'Business Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              profile[USER_BUSINESSNAME] ?? '',
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
                  title: const Text(Util.notification),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                if (profile[USER_ROLE] == Util.owner)
                  ListTile(
                    onTap: () {
                      NavigationRouter.switchToSubscription(context);
                    },
                    leading: const Icon(Icons.subscriptions_outlined),
                    title: const Text(Util.subscriptionTitle),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ListTile(
                  onTap: () {
                    NavigationRouter.switchToEvent(context);
                  },
                  leading: const Icon(Icons.calendar_month),
                  title: const Text(Util.event),
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
                    NavigationRouter.switchToTerms(context);
                  },
                  leading: const Icon(Icons.shield_sharp),
                  title: const Text(Util.termsTitle),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    NavigationRouter.switchToPolicy(context);
                  },
                  leading: const Icon(Icons.policy),
                  title: const Text(Util.policyTitle),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
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
