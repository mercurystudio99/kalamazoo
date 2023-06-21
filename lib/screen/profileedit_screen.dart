import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  XFile? image;

  final ImagePicker picker = ImagePicker();

  static const List<String> list = <String>['Male', 'Female'];
  String dropdownValue = list.first;
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email Address',
                          ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14)),
                          boxShadow: [
                            BoxShadow(
                              color: CustomColor.primaryColor.withOpacity(0.2),
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
                          value: dropdownValue,
                          hint: const Text('MM'),
                          borderRadius: BorderRadius.circular(10.0),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 16,
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
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
                              value: dropdownValue,
                              hint: const Text('MM'),
                              borderRadius: BorderRadius.circular(10.0),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
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
                              value: dropdownValue,
                              hint: const Text('MM'),
                              borderRadius: BorderRadius.circular(10.0),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
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
                              value: dropdownValue,
                              hint: const Text('MM'),
                              borderRadius: BorderRadius.circular(10.0),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
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
                              NavigationRouter.switchToHome(context);
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
