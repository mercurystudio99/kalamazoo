import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/widget/processing.dart';
import 'package:kalamazoo/key.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String location = '';
  bool isSelectionMode = false;
  final _searchController = TextEditingController();

  static final List<Map<String, dynamic>> searchResults = [];
  static List<Map<String, dynamic>> restaurants = [];

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

  @override
  void initState() {
    super.initState();
    location = globals.searchFullAddress;
  }

  _onSearch(String text) async {
    searchResults.clear();
    if (text.isEmpty) {
      return;
    }

    for (var restaurant in restaurants) {
      if (restaurant[RESTAURANT_BUSINESSNAME]
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        searchResults.add(restaurant);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    restaurants.clear();
    searchResults.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: AppModel().getAllRestaurant(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          restaurants.clear();
          for (var doc in snapshot.data!.docs) {
            restaurants.add(doc.data());
          }
          return Stack(
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
                        horizontal: Util.mainPadding * 0.5, vertical: 10),
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
                        Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                boxShadow: [
                                  BoxShadow(
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.2),
                                    blurRadius: 8.0,
                                    offset: const Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                              padding:
                                  const EdgeInsets.only(left: 44.0, right: 8),
                              margin: const EdgeInsets.only(top: 15.0),
                              child: TextButton(
                                  onPressed: () {
                                    _onLocation(context);
                                  },
                                  child: Text(
                                    location.length < 32
                                        ? location
                                        : '${location.substring(0, 32)}..',
                                    style: const TextStyle(color: Colors.black),
                                  )),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 30.0, left: 12.0),
                              child: const Icon(
                                Icons.location_on,
                                color: CustomColor.activeColor,
                                size: 20.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: Util.mainPadding,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Util.mainPadding,
                        right: Util.mainPadding,
                        bottom: 20.0),
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      elevation: 8,
                      shadowColor: CustomColor.primaryColor.withOpacity(0.2),
                      child: TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
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
                  ),
                  Expanded(
                    child: ListBuilder(
                      isSelectionMode: isSelectionMode,
                      list: searchResults,
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
          );
        } else {
          return const Processing();
        }
      },
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
          return InkWell(
              onTap: () {
                AppModel().setRestaurant(
                    restaurant: widget.list[index],
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
                          child: (widget.list[index][RESTAURANT_IMAGE] != null)
                              ? Image.network(
                                  widget.list[index][RESTAURANT_IMAGE],
                                  height: 100,
                                  fit: BoxFit.cover)
                              : Image.asset(
                                  'assets/group.png',
                                  fit: BoxFit.cover,
                                )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _ArticleDescription(
                        title: widget.list[index][RESTAURANT_BUSINESSNAME],
                        subtitle: 'Coffee',
                        author: '50% OFF',
                        publishDate: 'UPTO',
                        readDuration: '100',
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        AppModel().setFavourite(
                            restaurantID: widget.list[index][RESTAURANT_ID],
                            onSuccess: () {
                              setState(() {});
                            });
                      },
                      icon: Icon(
                        globals.userFavourites
                                .contains(widget.list[index][RESTAURANT_ID])
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: CustomColor.activeColor,
                      ),
                    ),
                  ],
                ),
              ));
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
              title.length < 12 ? title : '${title.substring(0, 8)}...',
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
