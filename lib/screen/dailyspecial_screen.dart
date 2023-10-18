import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/utils/constants.dart';

import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/models/app_model.dart';

class DailySpecialScreen extends StatefulWidget {
  const DailySpecialScreen({super.key});

  @override
  State<DailySpecialScreen> createState() => _DailySpecialScreenState();
}

class _DailySpecialScreenState extends State<DailySpecialScreen> {
  late List<Map<String, dynamic>> dailyspecials = [];

  void _getDailySpecial() {
    AppModel().getDailySpecial(
      onSuccess: (List<Map<String, dynamic>> param) {
        dailyspecials = param;
        setState(() {});
      },
      onEmpty: () {
        dailyspecials.clear();
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getDailySpecial();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          ListView(
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
                      Util.dailySpecial,
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
              const SizedBox(height: 30),
              _listing(),
              const SizedBox(height: 30),
            ],
          )
        ],
      ),
    );
  }

  Widget _listing() {
    Size size = MediaQuery.of(context).size;
    List<Widget> lists = dailyspecials.map((item) {
      return SizedBox(
          width: size.width / 2,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Util.mainPadding / 2, vertical: 10),
              child: Stack(children: [
                InkWell(
                    onTap: () {},
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
                              item[DAILYSPECIAL_IMAGE_LINK],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Column(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: const [
                          //           // if (element[RESTAURANT_DISCOUNT] != null)
                          //           Text(
                          //             // '${element[RESTAURANT_DISCOUNT]}% OFF',
                          //             '50% OFF',
                          //             style: TextStyle(
                          //                 fontSize: 14.0,
                          //                 color: CustomColor.activeColor,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //           // if (element[RESTAURANT_MINCOST] != null)
                          //           Text(
                          //             // 'UPTO \$${element[RESTAURANT_MINCOST]}',
                          //             'UPTO \$100',
                          //             style: TextStyle(
                          //                 fontSize: 12.0,
                          //                 color: CustomColor.textDetailColor),
                          //           ),
                          //         ],
                          //       ),
                          //       // if (element[RESTAURANT_RATING] != null)
                          //       Container(
                          //         padding:
                          //             const EdgeInsets.symmetric(horizontal: 4),
                          //         decoration: BoxDecoration(
                          //           color: CustomColor.activeColor,
                          //           borderRadius: BorderRadius.circular(10),
                          //         ),
                          //         child: Row(
                          //           children: const [
                          //             Text(
                          //               '4.2',
                          //               // element[RESTAURANT_RATING],
                          //               style: TextStyle(
                          //                   color: Colors.white, fontSize: 12),
                          //             ),
                          //             Icon(
                          //               Icons.star,
                          //               color: Colors.white,
                          //               size: 12,
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                item[DAILYSPECIAL_DESC],
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    color: CustomColor.textDetailColor),
                              )),
                        ],
                      ),
                    )),
                // Positioned(
                //     right: 10,
                //     top: 10,
                //     child: InkWell(
                //         onTap: () {},
                //         child: const Icon(
                //           // globals.userFavourites.contains(element[RESTAURANT_ID])
                //           //     ? Icons.bookmark
                //           //     : Icons.bookmark_outline,
                //           Icons.bookmark,
                //           color: CustomColor.activeColor,
                //         )))
              ])));
    }).toList();

    int rowCount = lists.length ~/ 2;
    List<Widget> rowList = [];
    for (int i = 0; i < rowCount + 1; i++) {
      if (lists.length > 2 * (i + 1)) {
        rowList.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: lists.sublist(2 * i, 2 * (i + 1))));
      } else {
        rowList.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: lists.sublist(2 * i, lists.length)));
      }
    }

    return SizedBox(
      width: size.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowList),
    );
  }
}
