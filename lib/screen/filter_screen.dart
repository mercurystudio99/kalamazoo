import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/utils/globals.dart' as global;
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/models/app_model.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late int distanceRange = 0;
  late String open = 'all';
  late List<Map<String, dynamic>> amenities = [];
  late final Map<String, dynamic> _isChecked = {};

  void _getAmenities() {
    AppModel().getAmenities(
      onSuccess: (List<Map<String, dynamic>> param) {
        amenities = param;
        for (var element in amenities) {
          _isChecked[element[AMENITY_ID]] =
              (global.searchAmenities.contains(element[AMENITY_ID]))
                  ? true
                  : false;
        }
        if (!mounted) return;
        setState(() {});
      },
      onEmpty: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    _getAmenities();
    distanceRange = global.searchDistanceRange;
    open = global.searchOpen;
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
          Positioned(
              left: 0,
              bottom: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                width: MediaQuery.of(context).size.height * 0.2,
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
              )),
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
              )),
          ListView(children: [
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
                    'Filter',
                    style: TextStyle(
                      color: CustomColor.primaryColor,
                      fontSize: 22.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      global.searchAmenities.clear();
                      global.searchDistanceRange = 0;
                      distanceRange = 0;
                      global.searchOpen = 'all';
                      open = 'all';
                      _getAmenities();
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: CustomColor.activeColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Text(
                'Distance Range',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: _distanceRangeSection(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Text(
                'Open or Not',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: _openSection(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: Text(
                'Amenities',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Util.mainPadding),
              child: _amenitySection(),
            ),
            const SizedBox(height: 10),
          ]),
        ],
      ),
    );
  }

  Widget _distanceRangeSection() {
    List<int> distanceRangeList = [1, 3, 5, 10];
    List<Widget> viewList = [];
    for (var range in distanceRangeList) {
      viewList.add(InkWell(
          onTap: () {
            setState(() {
              distanceRange = range;
            });
            global.searchDistanceRange = distanceRange;
          },
          child: Container(
            width: 80,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: distanceRange == range
                  ? CustomColor.primaryColor
                  : CustomColor.textDetailColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Text('$range mile',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          )));
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: viewList));
  }

  Widget _openSection() {
    List<Widget> viewList = [];
    viewList.add(InkWell(
        onTap: () {
          setState(() {
            open = 'open';
          });
          global.searchOpen = open;
        },
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: open == 'open'
                ? CustomColor.primaryColor
                : CustomColor.textDetailColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: const Text('Open',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15)),
        )));
    viewList.add(InkWell(
        onTap: () {
          setState(() {
            open = 'close';
          });
          global.searchOpen = open;
        },
        child: Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: open == 'close'
                ? CustomColor.primaryColor
                : CustomColor.textDetailColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: const Text('Close',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15)),
        )));
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: viewList));
  }

  Widget _amenitySection() {
    Size size = MediaQuery.of(context).size;

    List<String> amenityCategories = [];
    for (var amenity in amenities) {
      if (!amenityCategories.contains(amenity[AMENITY_TYPE]) &&
          amenity[AMENITY_TYPE] != null &&
          amenity[AMENITY_TYPE].toString().isNotEmpty) {
        amenityCategories.add(amenity[AMENITY_TYPE]);
      }
    }

    List<Widget> amenitiesView = [];
    for (var type in amenityCategories) {
      amenitiesView.add(
        SizedBox(
            width: size.width / 2,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(type,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)))),
      );

      amenitiesView.add(_subAmenitySection(type));
    }

    return SizedBox(
      width: size.width - Util.mainPadding * 2,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: amenitiesView),
    );
  }

  Widget _subAmenitySection(String type) {
    Size size = MediaQuery.of(context).size;
    List<Widget> lists = [];
    for (var item in amenities) {
      if (item[AMENITY_TYPE] != null && item[AMENITY_TYPE].toString() == type) {
        lists.add(SizedBox(
            width: size.width / 2 - Util.mainPadding,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 5,
                          spreadRadius: 1),
                    ],
                  ),
                  child: ColoredBox(
                      color: Colors.white,
                      child: Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          side: const BorderSide(color: Colors.white),
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return CustomColor.primaryColor;
                            }
                            return CustomColor.primaryColor;
                          }),
                          value: _isChecked[item[AMENITY_ID]],
                          onChanged: (bool? value) {
                            if (value == true) {
                              global.searchAmenities.add(item[AMENITY_ID]);
                            } else {
                              global.searchAmenities.remove(item[AMENITY_ID]);
                            }
                            setState(() {
                              _isChecked[item[AMENITY_ID]] = value!;
                            });
                          },
                        ),
                      )),
                ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/amenities/icon (${item[AMENITY_LOGO]}).png',
                ),
                const SizedBox(width: 5),
                Text(item[AMENITY_NAME].toString().length < 12
                    ? item[AMENITY_NAME]
                    : '${item[AMENITY_NAME].toString().substring(0, 10)}..')
              ]),
            )));
      }
    }

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
      width: size.width - Util.mainPadding * 2,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowList),
    );
  }
}
