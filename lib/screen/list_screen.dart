import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/widget/processing.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _searchController = TextEditingController();

  static List<Map<String, dynamic>> topMenuList = [];
  String _selectedTopMenu = '';

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: AppModel().getListRestaurant(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> restaurants = [];
          for (var doc in snapshot.data!.docs) {
            if (doc
                .data()[RESTAURANT_BUSINESSNAME]
                .toString()
                .toLowerCase()
                .contains(_searchController.text.trim().toLowerCase())) {
              if (doc.data()[RESTAURANT_CATEGORY] != null &&
                  doc.data()[RESTAURANT_CATEGORY] == _selectedTopMenu) {
                restaurants.add(doc.data());
              }
              if (_selectedTopMenu.isEmpty) {
                restaurants.add(doc.data());
              }
            }
          }
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
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
                        Text(
                          globals.restaurantType,
                          style: const TextStyle(
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
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
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
                  if (restaurants.isNotEmpty)
                    Expanded(
                      child: ListBuilder(
                        isSelectionMode: false,
                        list: restaurants,
                        onSelectionChange: (bool x) {},
                      ),
                    ),
                  if (restaurants.isEmpty) const SizedBox(height: 50),
                  if (restaurants.isEmpty)
                    Center(
                      child: Image.asset('assets/group.png'),
                    ),
                  if (restaurants.isEmpty) const SizedBox(height: 30),
                  if (restaurants.isEmpty)
                    const Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Util.mainPadding * 2),
                            child: Text(Util.listEmpty,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: CustomColor.textDetailColor))))
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
                      onTap: () {},
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
