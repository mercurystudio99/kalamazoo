import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:kalamazoo/models/app_model.dart';

class ProfileEdit2Screen extends StatefulWidget {
  const ProfileEdit2Screen({super.key});

  @override
  State<ProfileEdit2Screen> createState() => _ProfileEdit2ScreenState();
}

class _ProfileEdit2ScreenState extends State<ProfileEdit2Screen> {
  XFile? image;
  XFile? image2;

  final ImagePicker picker = ImagePicker();
  final _storage = FirebaseStorage.instance;

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();

  static const List<String> listGender = <String>['Male', 'Female'];
  static List<String> listYear = [];
  static const List<String> listMonth = <String>[
    'January',
    'Febrary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  static List<String> listDate = [];

  String gender = '';
  String birthYear = '';
  String birthMonth = '';
  String birthDate = '';

  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  bool _showDaysHours = false;
  static Map<String, dynamic> profile = {};
  static Map<String, dynamic> profileRestaurant = {};

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  Future getImage2(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image2 = img;
    });
  }

  void _save(
      {required VoidCallback onCallback,
      required Function(String) onError}) async {
    if (image != null) {
      var imageFile = File(image!.path);
      //Upload to Firebase
      UploadTask uploadTask =
          _storage.ref().child('avatar/${globals.userID}').putFile(imageFile);
      await uploadTask.whenComplete(() async {
        var url = await _storage
            .ref()
            .child('avatar/${globals.userID}')
            .getDownloadURL();
        AppModel().saveProfile(
            imageUrl: url.toString(),
            name: _nameController.text.trim(),
            location: _locationController.text.trim(),
            email: _emailController.text.trim(),
            gender: gender,
            birthYear: birthYear,
            birthMonth: birthMonth,
            birthDate: birthDate,
            onSuccess: () {
              onCallback();
            },
            onError: (String text) {});
      });
    } else {
      onError("Please upload your image.");
    }
  }

  void _save2(
      {required VoidCallback onCallback,
      required Function(String) onError}) async {
    if (image2 != null && profile.isNotEmpty && profileRestaurant.isNotEmpty) {
      String service = '';
      if (profile[USER_RESTAURANT_SERVICE] == C_RESTAURANTS) {
        service = 'restaurant';
      }
      if (profile[USER_RESTAURANT_SERVICE] == C_BREWERIES) service = 'brewery';
      if (profile[USER_RESTAURANT_SERVICE] == C_WINERIES) service = 'winery';
      if (service.isEmpty) return;

      var imageFile = File(image2!.path);

      String filename =
          DateTime.now().millisecondsSinceEpoch.toString() + image2!.name;

      //Upload to Firebase
      UploadTask uploadTask =
          _storage.ref().child('$service/$filename').putFile(imageFile);
      await uploadTask.whenComplete(() async {
        var url =
            await _storage.ref().child('$service/$filename').getDownloadURL();

        List<Map<String, dynamic>> schedule = [];
        for (var element in profileRestaurant[RESTAURANT_SCHEDULE]) {
          schedule.add({
            RESTAURANT_SCHEDULE_DAY: element[RESTAURANT_SCHEDULE_DAY],
            RESTAURANT_SCHEDULE_STARTHOUR:
                element[RESTAURANT_SCHEDULE_STARTHOUR],
            RESTAURANT_SCHEDULE_STARTMINUTE:
                element[RESTAURANT_SCHEDULE_STARTMINUTE],
            RESTAURANT_SCHEDULE_ENDHOUR: element[RESTAURANT_SCHEDULE_ENDHOUR],
            RESTAURANT_SCHEDULE_ENDMINUTE:
                element[RESTAURANT_SCHEDULE_ENDMINUTE],
            RESTAURANT_SCHEDULE_ISWORKINGDAY:
                element[RESTAURANT_SCHEDULE_ISWORKINGDAY]
          });
        }
        AppModel().saveRestaurantProfile(
            imageUrl: url.toString(),
            businessservice: profile[USER_RESTAURANT_SERVICE],
            businessId: profile[USER_RESTAURANT_ID],
            schedule: schedule,
            onSuccess: () {
              onCallback();
            },
            onError: (String text) {});
      });
    } else {
      onError("Please upload your restaurant image.");
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return "\u26A0 Please enter your email";
    }
    if (!(value.isNotEmpty && value.contains("@") && value.contains("."))) {
      return '\u26A0 The E-mail Address must be a valid email address.';
    }
    return null;
  }

  void _getInformation() {
    AppModel().getProfile(onSuccess: (Map<String, dynamic> param) {
      profile = param;
      if (param[USER_ROLE] == Util.owner) {
        AppModel().getRestaurantProfile(
            businessId: param[USER_RESTAURANT_ID],
            businessService: param[USER_RESTAURANT_SERVICE],
            onSuccess: (Map<String, dynamic> param2) {
              profileRestaurant = param2;
              if (!mounted) return;
              setState(() {});
            });
      } else {
        if (!mounted) return;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getInformation();
    for (var i = 1950; i < 2024; i++) {
      listYear.add(i.toString());
    }
    for (var i = 1; i < 32; i++) {
      listDate.add(i.toString());
    }
    gender = listGender.first;
    birthMonth = listMonth.first;
    birthDate = listDate.first;
    birthYear = listYear.first;
  }

  @override
  void dispose() {
    listYear.clear();
    listDate.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> scheduleView = [];
    if (profileRestaurant.isNotEmpty &&
        profileRestaurant[RESTAURANT_SCHEDULE] != null) {
      for (var element in profileRestaurant[RESTAURANT_SCHEDULE]) {
        TimeOfDay startTime = TimeOfDay(
            hour: element[RESTAURANT_SCHEDULE_STARTHOUR],
            minute: element[RESTAURANT_SCHEDULE_STARTMINUTE]);
        TimeOfDay endTime = TimeOfDay(
            hour: element[RESTAURANT_SCHEDULE_ENDHOUR],
            minute: element[RESTAURANT_SCHEDULE_ENDMINUTE]);
        scheduleView.add(Padding(
            padding: const EdgeInsets.all(0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(element[RESTAURANT_SCHEDULE_DAY],
                  style: const TextStyle(
                      color: CustomColor.textDetailColor, fontSize: 16)),
              const Spacer(),
              if (element[RESTAURANT_SCHEDULE_ISWORKINGDAY])
                TextButton(
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                        initialEntryMode: entryMode,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              materialTapTargetSize: tapTargetSize,
                            ),
                            child: Directionality(
                              textDirection: textDirection,
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: use24HourTime,
                                ),
                                child: child!,
                              ),
                            ),
                          );
                        },
                      );
                      if (time != null) {
                        element[RESTAURANT_SCHEDULE_STARTHOUR] = time.hour;
                        element[RESTAURANT_SCHEDULE_STARTMINUTE] = time.minute;
                        setState(() {});
                      }
                    },
                    child: Text(startTime.format(context),
                        style: const TextStyle(
                            color: CustomColor.textDetailColor, fontSize: 16))),
              if (element[RESTAURANT_SCHEDULE_ISWORKINGDAY])
                const Text('-',
                    style: TextStyle(
                        color: CustomColor.textDetailColor, fontSize: 16)),
              if (element[RESTAURANT_SCHEDULE_ISWORKINGDAY])
                TextButton(
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                        initialEntryMode: entryMode,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              materialTapTargetSize: tapTargetSize,
                            ),
                            child: Directionality(
                              textDirection: textDirection,
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: use24HourTime,
                                ),
                                child: child!,
                              ),
                            ),
                          );
                        },
                      );
                      if (time != null) {
                        element[RESTAURANT_SCHEDULE_ENDHOUR] = time.hour;
                        element[RESTAURANT_SCHEDULE_ENDMINUTE] = time.minute;
                        setState(() {});
                      }
                    },
                    child: Text(endTime.format(context),
                        style: const TextStyle(
                            color: CustomColor.textDetailColor, fontSize: 16))),
              if (!element[RESTAURANT_SCHEDULE_ISWORKINGDAY])
                const Padding(
                  padding: EdgeInsets.only(right: 55),
                  child: Text('Closed',
                      style: TextStyle(
                          color: CustomColor.activeColor, fontSize: 16)),
                ),
              IconButton(
                  onPressed: () {
                    if (element[RESTAURANT_SCHEDULE_ISWORKINGDAY]) {
                      element[RESTAURANT_SCHEDULE_STARTHOUR] = L_START_HOUR;
                      element[RESTAURANT_SCHEDULE_STARTMINUTE] = L_START_MINUTE;
                      element[RESTAURANT_SCHEDULE_ENDHOUR] = L_END_HOUR;
                      element[RESTAURANT_SCHEDULE_ENDMINUTE] = L_END_MINUTE;
                    }
                    element[RESTAURANT_SCHEDULE_ISWORKINGDAY] =
                        !element[RESTAURANT_SCHEDULE_ISWORKINGDAY];
                    setState(() {});
                  },
                  icon: element[RESTAURANT_SCHEDULE_ISWORKINGDAY]
                      ? const Icon(Icons.close, color: Colors.black)
                      : const Icon(Icons.add, color: Colors.black))
            ])));
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding * 0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        NavigationRouter.back(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: Util.mainPadding),
                      child: Text(
                        'User Information',
                        style: TextStyle(
                            color: CustomColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          image != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      //to show image, you type like this.
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    getImage(ImageSource.gallery);
                                  },
                                  child: Image.asset('assets/camera.png'),
                                ),
                          GestureDetector(
                            onTap: () {
                              getImage(ImageSource.gallery);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                Util.profileUploadImg,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: Util.mainPadding),
                      child: Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8,
                          left: Util.mainPadding,
                          right: Util.mainPadding),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Your Name',
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: Util.mainPadding),
                      child: Text(
                        'Location',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8,
                          left: Util.mainPadding,
                          right: Util.mainPadding),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '****** ** *****',
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: Util.mainPadding),
                      child: Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8,
                          left: Util.mainPadding,
                          right: Util.mainPadding),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType
                              .emailAddress, // Use email input type for emails.
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email Address',
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            return _validateEmail(value!);
                          },
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: Util.mainPadding),
                      child: Text(
                        'Gender',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Util.mainPadding),
                      child: Stack(
                        children: [
                          Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    spreadRadius: 1),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14)),
                              child: DropdownButton<String>(
                                value: gender,
                                onChanged: (String? value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                                hint: const Center(
                                    child: Text(
                                  'Select gender',
                                  style: TextStyle(
                                      color: CustomColor.textDetailColor),
                                )),
                                // Hide the default underline
                                underline: Container(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                // The list of options
                                items: listGender
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              e,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ))
                                    .toList(),

                                // Customize the selected item
                                selectedItemBuilder: (BuildContext context) =>
                                    listGender
                                        .map((e) => Center(
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ))
                                        .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: Util.mainPadding),
                      child: Text(
                        'Birthday',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8,
                          left: Util.mainPadding,
                          right: Util.mainPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      CustomColor.primaryColor.withOpacity(0.2),
                                  blurRadius: 8.0,
                                  offset: const Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(left: 10, right: 8),
                            child: DropdownButton<String>(
                              underline: const SizedBox(
                                width: 1,
                              ),
                              value: birthMonth,
                              hint: const Text('MM'),
                              borderRadius: BorderRadius.circular(10.0),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              onChanged: (String? value) {
                                setState(() {
                                  birthMonth = value!;
                                });
                              },
                              items: listMonth.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      CustomColor.primaryColor.withOpacity(0.2),
                                  blurRadius: 8.0,
                                  offset: const Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(left: 10, right: 8),
                            child: DropdownButton<String>(
                              underline: const SizedBox(
                                width: 1,
                              ),
                              value: birthDate,
                              hint: const Text('DD'),
                              borderRadius: BorderRadius.circular(10.0),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              onChanged: (String? value) {
                                setState(() {
                                  birthDate = value!;
                                });
                              },
                              items: listDate.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      CustomColor.primaryColor.withOpacity(0.2),
                                  blurRadius: 8.0,
                                  offset: const Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(left: 10, right: 8),
                            child: DropdownButton<String>(
                              underline: const SizedBox(
                                width: 1,
                              ),
                              value: birthYear,
                              hint: const Text('YY'),
                              borderRadius: BorderRadius.circular(10.0),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              onChanged: (String? value) {
                                setState(() {
                                  birthYear = value!;
                                });
                              },
                              items: listYear.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: Util.mainPadding),
                      child: SizedBox(
                          height: 50, //height of button
                          width: MediaQuery.of(context)
                              .size
                              .width, //width of button
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10, //elevation of button
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(10)),
                                shadowColor: CustomColor.primaryColor,
                                padding: const EdgeInsets.all(
                                    5) //content padding inside button
                                ),
                            onPressed: () {
                              _save(onCallback: () {
                                // Go to Home
                                NavigationRouter.switchToHome(context);
                              }, onError: (String text) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(text)),
                                );
                              });
                            },
                            child: const Text(
                              Util.buttonSave,
                              style: TextStyle(
                                  color: CustomColor.buttonTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          )),
                    ),
                    const SizedBox(height: 15),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: Util.mainPadding),
                      child: Text(
                        'Restaurant Information',
                        style: TextStyle(
                            color: CustomColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          image2 != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      //to show image, you type like this.
                                      File(image2!.path),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    getImage2(ImageSource.gallery);
                                  },
                                  child: Image.asset('assets/camera.png'),
                                ),
                          GestureDetector(
                            onTap: () {
                              getImage2(ImageSource.gallery);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                Util.profileUploadImg,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
                      child: Stack(children: [
                        Container(
                          height: _showDaysHours ? 390 : 54,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 1),
                            ],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                          child: Column(children: [
                            ListTile(
                              title: const Text(
                                'Days/Hours',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                    _showDaysHours
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_right,
                                    color: Colors.black54),
                                onPressed: () {
                                  setState(() {
                                    _showDaysHours = !_showDaysHours;
                                  });
                                },
                              ),
                              contentPadding: const EdgeInsets.only(left: 15),
                            ),
                            // Show or hide the content based on the state
                            _showDaysHours
                                ? Container(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: scheduleView),
                                  )
                                : Container(),
                          ]),
                        )
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: Util.mainPadding),
                      child: SizedBox(
                          height: 50, //height of button
                          width: MediaQuery.of(context)
                              .size
                              .width, //width of button
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10, //elevation of button
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(10)),
                                shadowColor: CustomColor.primaryColor,
                                padding: const EdgeInsets.all(
                                    5) //content padding inside button
                                ),
                            onPressed: () {
                              _save2(onCallback: () {
                                // Go to Home
                                NavigationRouter.switchToHome(context);
                              }, onError: (String text) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(text)),
                                );
                              });
                            },
                            child: const Text(
                              Util.buttonSave,
                              style: TextStyle(
                                  color: CustomColor.buttonTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
