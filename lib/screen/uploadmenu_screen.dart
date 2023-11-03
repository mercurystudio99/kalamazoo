import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/models/app_model.dart';

class UploadMenuScreen extends StatefulWidget {
  const UploadMenuScreen({super.key});

  @override
  State<UploadMenuScreen> createState() => _UploadMenuScreenState();
}

class _UploadMenuScreenState extends State<UploadMenuScreen> {
  PlatformFile? _imageFile;
  final _storage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  static List<Map<String, dynamic>> categories = [];
  static List<String> listCategory = <String>['None'];
  String category = '';

  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.any,
    );
    if (result == null) return;
    setState(() {
      _imageFile = result.files.first;
    });
  }

  void _save(
      {required VoidCallback onCallback,
      required Function(String) onError}) async {
    if (_imageFile != null) {
      Uint8List? fileBytes = _imageFile!.bytes;
      String filename =
          DateTime.now().millisecondsSinceEpoch.toString() + _imageFile!.name;
      var snapshot =
          await _storage.ref().child('menu/$filename').putData(fileBytes!);

      var url = await snapshot.ref.getDownloadURL();

      String categoryID = '';
      for (var element in categories) {
        if (element[CATEGORY_NAME] == category) {
          categoryID = element[CATEGORY_ID];
        }
      }

      AppModel().saveMenu(
          imageUrl: url.toString(),
          name: _nameController.text.trim(),
          price: _priceController.text.trim(),
          desc: _descriptionController.text.trim(),
          category: categoryID,
          onSuccess: () {
            onCallback();
          },
          onError: () {});
    }
  }

  void _getFoodCategory() {
    AppModel().getCategories(
      onSuccess: (List<Map<String, dynamic>> param) {
        listCategory = <String>['None'];
        categories = param;
        for (var element in categories) {
          listCategory.add(element[CATEGORY_NAME]);
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
    category = listCategory.first;
    _getFoodCategory();
  }

  @override
  void dispose() {
    listCategory = <String>['None'];
    categories.clear();
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
          SingleChildScrollView(
              child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
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
                      'Upload Menu',
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
                    _imageFile != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_imageFile!.path!),
                                width: MediaQuery.of(context).size.width / 2,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 100,
                                color: Colors.grey[400]),
                          ),
                    TextButton(
                      onPressed: () {
                        getImage();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Click here to upload an image!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
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
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Title',
                            ),
                            validator: (title) {
                              if (title?.isEmpty ?? true) {
                                return "Please enter a menu title.";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
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
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Price',
                            ),
                            validator: (price) {
                              if (price?.isEmpty ?? true) {
                                return "Please enter a menu price.";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
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
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description',
                            ),
                            validator: (desc) {
                              if (desc?.isEmpty ?? true) {
                                return "Please enter a menu description.";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
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
                                value: category,
                                onChanged: (String? value) {
                                  setState(() {
                                    category = value!;
                                  });
                                },
                                hint: const Center(
                                    child: Text(
                                  'Select menu category',
                                  style: TextStyle(
                                      color: CustomColor.textDetailColor),
                                )),
                                // Hide the default underline
                                underline: Container(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                // The list of options
                                items: listCategory
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              e.length < 30
                                                  ? e
                                                  : '${e.substring(0, 28)}..',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ))
                                    .toList(),

                                // Customize the selected item
                                selectedItemBuilder: (BuildContext context) =>
                                    listCategory
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: Util.mainPadding),
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
                              if (_formKey.currentState!.validate()) {
                                _save(onCallback: () {
                                  _nameController.text = '';
                                  _priceController.text = '';
                                  _descriptionController.text = '';
                                  setState(() {});
                                }, onError: (String text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Upload Failed!')),
                                  );
                                });
                              }
                            },
                            child: const Text(
                              'Upload',
                              style: TextStyle(
                                  color: CustomColor.buttonTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
