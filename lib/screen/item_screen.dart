import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/widget/processing.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  String _getDistance(List<dynamic> geolocation) {
    double distance = Geolocator.distanceBetween(
        globals.latitude, globals.longitude, geolocation[0], geolocation[1]);
    distance = distance / 1609.344;
    return distance.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: AppModel().getMenu(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Map<String, dynamic>? menu = snapshot.data!.data();
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Image.asset('assets/item_background.png')],
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.4,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: CustomColor.primaryColor.withOpacity(0.05),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
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
                          ),
                          onPressed: () {
                            NavigationRouter.back(context);
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            AppModel().setFavourite(
                                restaurantID: globals.restaurantID,
                                onSuccess: () {
                                  setState(() {});
                                });
                          },
                          icon: Icon(
                            globals.userFavourites
                                    .contains(globals.restaurantID)
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            color: CustomColor.activeColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 4, color: CustomColor.activeColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100))),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: menu![MENU_PHOTO] != null
                            ? Image.network(menu[MENU_PHOTO], fit: BoxFit.cover)
                            : Image.asset('assets/group.png',
                                fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        shadowColor: CustomColor.primaryColor.withOpacity(0.2),
                        elevation: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {},
                            ),
                            const Text(
                              '02',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: CustomColor.activeColor,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: Util.mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          (menu[MENU_NAME].toString().length > 30)
                              ? '${menu[MENU_NAME].toString().substring(0, 26)}...'
                              : menu[MENU_NAME],
                          style: const TextStyle(
                              color: CustomColor.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          '\$${menu[MENU_PRICE]}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: Util.mainPadding),
                    child: Text(
                      menu[MENU_DESCRIPTION] ?? '',
                      softWrap: true,
                      style: const TextStyle(
                          height: 1.5, color: CustomColor.textHeadColor),
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
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: CustomColor.activeColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${globals.restaurantRating}',
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
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Icon(
                          Icons.location_on,
                          color: CustomColor.activeColor,
                        ),
                        const Text(
                          '05.5km',
                          overflow: TextOverflow.ellipsis,
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
                          color: CustomColor.activeColor,
                        ),
                        const Text(
                          '15-20min',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: CustomColor.textDetailColor,
                          ),
                        ),
                      ],
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
