import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/models/app_model.dart';
import 'package:kalamazoo/widget/processing.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isSelectionMode = false;
  final _searchController = TextEditingController();

  static List<Map<String, dynamic>> menu = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    menu.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: AppModel().getFullMenu(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          menu.clear();
          for (var doc in snapshot.data!.docs) {
            if (doc
                .data()[MENU_NAME]
                .toString()
                .toLowerCase()
                .contains(_searchController.text.trim().toLowerCase())) {
              menu.add(doc.data());
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
                        const Text(
                          Util.fullMenu,
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
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value!.contains('\n')) {}
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  if (menu.isNotEmpty)
                    Expanded(
                      child: ListBuilder(
                        isSelectionMode: isSelectionMode,
                        list: menu,
                        onSelectionChange: (bool x) {
                          setState(() {
                            isSelectionMode = x;
                          });
                        },
                      ),
                    ),
                  if (menu.isEmpty) const SizedBox(height: 50),
                  if (menu.isEmpty)
                    Center(
                      child: Image.asset('assets/group.png'),
                    ),
                  if (menu.isEmpty) const SizedBox(height: 30),
                  if (menu.isEmpty)
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
          final Map<String, dynamic> menu = widget.list[index];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: SizedBox(
                  height: 160,
                  child: InkWell(
                      onTap: () {
                        AppModel().setMenuID(
                            id: menu[MENU_ID],
                            onSuccess: () {
                              NavigationRouter.switchToItem(context);
                            });
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
                                  child: menu[MENU_PHOTO] != null
                                      ? Image.network(menu[MENU_PHOTO],
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
                                        (menu[MENU_NAME].toString().length < 18)
                                            ? menu[MENU_NAME]
                                            : '${menu[MENU_NAME].toString().substring(0, 15)}..',
                                        style: TextStyle(
                                            color: (widget.isSelectionMode
                                                ? Colors.white
                                                : CustomColor.primaryColor),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      if (menu[MENU_DESCRIPTION] != null)
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                Util.mainPadding * 2 -
                                                170,
                                            child: Text(
                                              (menu[MENU_DESCRIPTION]
                                                          .toString()
                                                          .length <
                                                      100)
                                                  ? menu[MENU_DESCRIPTION]
                                                  : '${menu[MENU_DESCRIPTION].toString().substring(0, 100)}...',
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
                                                  '\$${menu[MENU_PRICE]}',
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
