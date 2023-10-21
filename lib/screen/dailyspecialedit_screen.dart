import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/models/app_model.dart';

class DailySpecialEditScreen extends StatefulWidget {
  const DailySpecialEditScreen({super.key});

  @override
  State<DailySpecialEditScreen> createState() => _DailySpecialEditScreenState();
}

class _DailySpecialEditScreenState extends State<DailySpecialEditScreen> {
  final _storage = FirebaseStorage.instance;
  PlatformFile? _imageFile;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  static Map<String, dynamic> userInfo = {};

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

  void saveImage(
      {required VoidCallback onCallback,
      required Function(String) onError}) async {
    if (_imageFile != null && _descriptionController.text.trim().isNotEmpty) {
      Uint8List? fileBytes = _imageFile!.bytes;
      String filename =
          DateTime.now().millisecondsSinceEpoch.toString() + _imageFile!.name;
      var snapshot = await _storage
          .ref()
          .child('dailyspecial/$filename')
          .putData(fileBytes!);

      var url = await snapshot.ref.getDownloadURL();

      AppModel().setDailySpecial(
          imageLink: url.toString(),
          desc: _descriptionController.text.trim(),
          onSuccess: () {
            onCallback();
          });
    } else {
      onError('Please upload an image.');
    }
  }

  void save({
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    if (userInfo[USER_SUBSCRIPTION_TYPE] == null) {
      onError('Please choose Subscription Plan.');
    } else {
      if (userInfo[USER_SUBSCRIPTION_TYPE] == 'each' ||
          userInfo[USER_SUBSCRIPTION_TYPE] == 'month') {
        if (userInfo[USER_SUBSCRIPTION_COUNT] > 0) {
          AppModel().updateUserDailySpecial(
              count: userInfo[USER_SUBSCRIPTION_COUNT]--,
              onSuccess: () {
                saveImage(onCallback: () {
                  AppModel().getProfile(
                      onSuccess: (Map<String, dynamic> param) {
                    userInfo = param;
                  });
                  _descriptionController.text = '';
                  onSuccess();
                }, onError: (String text) {
                  onError(text);
                });
              });
        } else {
          onError('Please choose Subscription Plan.');
        }
      }
      if (userInfo[USER_SUBSCRIPTION_TYPE] == 'day') {
        int diff =
            DateTime.now().difference(userInfo[USER_SUBSCRIPTION_DATE]).inDays;
        if (diff > 0) {
          AppModel().updateUserDailySpecial(
              date: DateTime.now(),
              onSuccess: () {
                saveImage(onCallback: () {
                  AppModel().getProfile(
                      onSuccess: (Map<String, dynamic> param) {
                    userInfo = param;
                  });
                  _descriptionController.text = '';
                  onSuccess();
                }, onError: (String text) {
                  onError(text);
                });
              });
        } else {
          onError('You can upload only one Daily Special in a day.');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    AppModel().getProfile(onSuccess: (Map<String, dynamic> param) {
      userInfo = param;
    });
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
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Util.mainPadding * 0.5, vertical: 20),
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
              _imageFile != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_imageFile!.path!),
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Icon(
                        Icons.image,
                        size: MediaQuery.of(context).size.width / 4,
                      ),
                    ),
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Click here to upload an image!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: Util.mainPadding),
                          child: TextFormField(
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: CustomColor.primaryColor)),
                              labelText: 'Description',
                            ),
                            validator: (desc) {
                              if (desc?.isEmpty ?? true) {
                                return "Please enter a description.";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    shadowColor: CustomColor.primaryColor,
                                    padding: const EdgeInsets.all(
                                        5) //content padding inside button
                                    ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    save(onSuccess: () {
                                      _descriptionController.text = '';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Success')),
                                      );
                                    }, onError: (String text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(text)),
                                      );
                                    });
                                  }
                                },
                                child: const Text(
                                  'Send Daily Special',
                                  style: TextStyle(
                                      color: CustomColor.buttonTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              )),
                        ),
                      ]))
            ],
          )
        ],
      ),
    );
  }
}
