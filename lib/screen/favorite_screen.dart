import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _searchFavoriteController = TextEditingController();

  static List<Map<String, dynamic>> favourites = [];
  static final List<Map<String, dynamic>> _searchFavorites = [];

  bool isSelectionMode = false;

  _onSearchFavorite(String text) async {
    _searchFavorites.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var favorite in favourites) {
      if (favorite[RESTAURANT_BUSINESSNAME].contains(text)) {
        _searchFavorites.add(favorite);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (globals.userFavourites.isNotEmpty) {
      AppModel().getFavourites(onSuccess: (List<Map<String, dynamic>> param) {
        favourites = param;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    favourites.clear();
    _searchFavorites.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> list = (_searchFavorites.isNotEmpty ||
            _searchFavoriteController.text.isNotEmpty)
        ? _searchFavorites
        : favourites;
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
                      Util.favorite,
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
                padding: const EdgeInsets.only(
                    left: Util.mainPadding,
                    right: Util.mainPadding,
                    bottom: 20),
                child: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  elevation: 8,
                  shadowColor: CustomColor.primaryColor.withOpacity(0.2),
                  child: TextFormField(
                    controller: _searchFavoriteController,
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
                      if (value!.contains('\n')) {}
                      return null;
                    },
                    onChanged: _onSearchFavorite,
                  ),
                ),
              ),
              if (!(_searchFavoriteController.text.isNotEmpty &&
                      _searchFavorites.isEmpty ||
                  favourites.isEmpty))
                Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (_, int index) {
                          final Map<String, dynamic> restaurant = list[index];
                          return GestureDetector(
                            onTap: () {
                              AppModel().setRestaurant(
                                  restaurant: restaurant,
                                  onSuccess: () =>
                                      NavigationRouter.switchToAbout(context));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Util.mainPadding, vertical: 8),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: CustomColor.primaryColor
                                        .withOpacity(0.2),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        child: (restaurant[RESTAURANT_IMAGE] !=
                                                null)
                                            ? Image.network(
                                                restaurant[RESTAURANT_IMAGE],
                                                height: 100,
                                                fit: BoxFit.cover)
                                            : Image.asset(
                                                'assets/group.png',
                                                fit: BoxFit.cover,
                                              )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: _Description(
                                      title:
                                          restaurant[RESTAURANT_BUSINESSNAME],
                                      subtitle: 'Coffee',
                                      author: '50% OFF',
                                      publishDate: 'UPTO',
                                      readDuration: '100',
                                      geolocation:
                                          restaurant[RESTAURANT_GEOLOCATION],
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                      onTap: () {
                                        AppModel().setFavourite(
                                            restaurantID:
                                                restaurant[RESTAURANT_ID],
                                            onSuccess: () {
                                              if (globals
                                                  .userFavourites.isNotEmpty) {
                                                AppModel().getFavourites(
                                                    onSuccess: (List<
                                                            Map<String,
                                                                dynamic>>
                                                        param) {
                                                  favourites = param;
                                                  _searchFavorites.clear();
                                                  for (var favorite
                                                      in favourites) {
                                                    if (favorite[
                                                            RESTAURANT_BUSINESSNAME]
                                                        .contains(
                                                            _searchFavoriteController
                                                                .text)) {
                                                      _searchFavorites
                                                          .add(favorite);
                                                    }
                                                  }

                                                  setState(() {});
                                                });
                                              } else {
                                                favourites.clear();
                                                _searchFavorites.clear();
                                                setState(() {});
                                              }
                                            });
                                      },
                                      child: const Icon(
                                        Icons.bookmark,
                                        color: CustomColor.activeColor,
                                      ))
                                ],
                              ),
                            ),
                          );
                        })),
              if (_searchFavoriteController.text.isNotEmpty &&
                      _searchFavorites.isEmpty ||
                  favourites.isEmpty)
                const SizedBox(height: 50),
              if (_searchFavoriteController.text.isNotEmpty &&
                      _searchFavorites.isEmpty ||
                  favourites.isEmpty)
                Center(
                  child: Image.asset('assets/group.png'),
                ),
              if (_searchFavoriteController.text.isNotEmpty &&
                      _searchFavorites.isEmpty ||
                  favourites.isEmpty)
                const SizedBox(height: 30),
              if (_searchFavoriteController.text.isNotEmpty &&
                      _searchFavorites.isEmpty ||
                  favourites.isEmpty)
                const Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Util.mainPadding * 2),
                        child: Text(Util.listEmpty,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: CustomColor.textDetailColor))))
            ],
          ),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
    required this.readDuration,
    required this.geolocation,
  });

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;
  final List<dynamic> geolocation;

  String _getDistance(List<dynamic> geolocation) {
    double distance = Geolocator.distanceBetween(
        globals.latitude, globals.longitude, geolocation[0], geolocation[1]);
    distance = distance / 1609.344;
    return distance.toStringAsFixed(1);
  }

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
            Text(
              '${_getDistance(geolocation)}mi',
              style: const TextStyle(
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
