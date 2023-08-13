import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/utils/globals.dart' as globals;
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';

class AppModel extends Model {
  // Variables
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> users = [];

  String? retrieveEmail;
  String? retrieveID;
  Map<String, dynamic> categories = {};

  /// Create Singleton factory for [AppModel]
  ///
  static final AppModel _appModel = AppModel._internal();
  factory AppModel() {
    return _appModel;
  }
  AppModel._internal();
  // End
  EmailOTP myauth = EmailOTP();

  // user sign up method
  void userSignUp({
    required String name,
    required String email,
    required String password,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final docRef = _firestore.collection(C_USERS).doc();
    await docRef.set({
      USER_ID: docRef.id,
      USER_FULLNAME: name,
      USER_EMAIL: email,
      USER_PASS: password,
      USER_FAVOURITIES: [],
    });
    globals.userEmail = email;
    globals.userID = docRef.id;
    onSuccess();
  }

  // user sign in method
  void userSignIn({
    required String email,
    required String password,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    _firestore
        .collection(C_USERS)
        .where(USER_EMAIL, isEqualTo: email)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var docSnapshot in querySnapshot.docs) {
            if (docSnapshot.data()[USER_PASS] == password) {
              globals.userEmail = email;
              globals.userID = docSnapshot.id;
              if (docSnapshot.data()[USER_FAVOURITIES].isNotEmpty) {
                globals.userFavourites = docSnapshot.data()[USER_FAVOURITIES];
              }
              onSuccess();
            } else {
              onError('Wrong password provided for that user.');
            }
            break;
          }
        } else {
          onError('No user found for that email.');
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  // user exist method
  void userExist({
    required String email,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    _firestore
        .collection(C_USERS)
        .where(USER_EMAIL, isEqualTo: email)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          retrieveEmail = email;
          for (var docSnapshot in querySnapshot.docs) {
            retrieveID = docSnapshot.id;
            if (docSnapshot.data()[USER_FAVOURITIES].isNotEmpty) {
              globals.userFavourites = docSnapshot.data()[USER_FAVOURITIES];
            }
            globals.userPass = docSnapshot.data()[USER_PASS];
            break;
          }
          onSuccess();
        } else {
          onError('No user found for that email.');
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  // user send OTP method
  void sendOTP({
    required String email,
    // callback functions
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    myauth.setConfig(
        appEmail: "thebestlocaleats@gmail.com",
        appName: 'Thebestlocaleats',
        userEmail: email,
        otpLength: 4,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      onSuccess();
    } else {
      onError();
    }
  }

  // user verify OTP method
  void verifyOTP({
    required String otp,
    // callback functions
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    if (await myauth.verifyOTP(otp: otp) == true) {
      onSuccess();
    } else {
      onError();
    }
  }

  // user reset password method
  void userResetPassword({
    required String newPass,
    required String confirmPass,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    (newPass == confirmPass)
        ? _firestore
            .collection(C_USERS)
            .doc(retrieveID)
            .update({USER_PASS: newPass}).then((value) {
            globals.userEmail = retrieveEmail!;
            globals.userID = retrieveID!;
            onSuccess();
          }, onError: (e) => debugPrint("Error updating document $e"))
        : onError('Passwords must match.');
  }

  // search get method
  void getSearch({
    required String keyword,
    // callback functions
    required Function(List<Map<String, dynamic>>) onSuccess,
  }) {
    List<Map<String, dynamic>> results = [];
    _firestore
        .collection(C_RESTAURANTS)
        .where(RESTAURANT_BUSINESSNAME, isEqualTo: keyword)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var docSnapshot in querySnapshot.docs) {
            results.add(docSnapshot.data());
          }
          onSuccess(results);
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  // category method
  void getCategory({
    // callback functions
    required Function(Map<String, dynamic>) onSuccess,
  }) async {
    final snapshots =
        await _firestore.collection(C_APPINFO).doc('categories').get();
    categories = snapshots.data()!;
    onSuccess(categories);
  }

  void getData({
    // callback functions
    required Function(List<Map<String, dynamic>>) onSuccess,
  }) {
    // categories.forEach((key, value) {
    // if (value) {
    _firestore.collection(C_RESTAURANTS).limit(2).get().then(
      (querySnapshot) {
        List<Map<String, dynamic>> result = [];
        for (var snapshot in querySnapshot.docs) {
          result.add(snapshot.data());
        }
        onSuccess(result);
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
    // }
    // });
  }

  // favourite set method
  void setFavourite({
    required String restaurantID,
    // callback functions
    required VoidCallback onSuccess,
  }) {
    if (globals.userFavourites.contains(restaurantID)) {
      globals.userFavourites.remove(restaurantID);
    } else {
      globals.userFavourites.add(restaurantID);
    }

    _firestore
        .collection(C_USERS)
        .doc(globals.userID)
        .update({USER_FAVOURITIES: globals.userFavourites}).then(
            (value) => onSuccess(),
            onError: (e) => debugPrint("Error updating document $e"));
  }

  // favourites get method
  void getFavourites({
    // callback functions
    required Function(List<Map<String, dynamic>>) onSuccess,
  }) {
    List<Map<String, dynamic>> favourites = [];
    _firestore
        .collection(C_RESTAURANTS)
        .where(RESTAURANT_ID, whereIn: globals.userFavourites)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var docSnapshot in querySnapshot.docs) {
            favourites.add(docSnapshot.data());
          }
          onSuccess(favourites);
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  // profile save method
  void saveProfile({
    required String imageUrl,
    required String name,
    required String location,
    required String email,
    required String gender,
    required String birthYear,
    required String birthMonth,
    required String birthDate,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    _firestore.collection(C_USERS).doc(globals.userID).update({
      USER_PROFILE_PHOTO: imageUrl,
      USER_FULLNAME: name,
      USER_LOCATION: location,
      USER_EMAIL: email,
      USER_GENDER: gender,
      USER_BIRTH_YEAR: birthYear,
      USER_BIRTH_MONTH: birthMonth,
      USER_BIRTH_DAY: birthDate
    }).then((value) => onSuccess(),
        onError: (e) => debugPrint("Error updating document $e"));
  }

  // profile get method
  void getProfile({
    // callback functions
    required Function(Map<String, dynamic>) onSuccess,
  }) {
    _firestore
        .collection(C_USERS)
        .where(USER_EMAIL, isEqualTo: globals.userEmail)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          Map<String, dynamic> data = {};
          for (var docSnapshot in querySnapshot.docs) {
            data = docSnapshot.data();
            break;
          }
          onSuccess(data);
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  // restaurant ID set method
  void setRestaurant({
    required Map<String, dynamic> restaurant,
    // callback functions
    required VoidCallback onSuccess,
  }) {
    globals.restaurantID = restaurant[RESTAURANT_ID];
    globals.restaurantRating = restaurant[RESTAURANT_RATING] ?? 0;
    onSuccess();
  }

  // restaurant get method
  Future<QuerySnapshot<Map<String, dynamic>>> getAllRestaurant() async {
    return await _firestore.collection(C_RESTAURANTS).get();
  }

  // restaurant get method
  Future<QuerySnapshot<Map<String, dynamic>>> getRestaurant() async {
    return await _firestore
        .collection(C_RESTAURANTS)
        .where(RESTAURANT_ID, isEqualTo: globals.restaurantID)
        .get();
  }

  // menu ID set method
  void setMenuID({
    required String id,
    // callback functions
    required VoidCallback onSuccess,
  }) {
    globals.menuID = id;
    onSuccess();
  }

  // all menu get method
  Future<QuerySnapshot<Map<String, dynamic>>> getFullMenu() async {
    return await _firestore
        .collection(C_RESTAURANTS)
        .doc(globals.restaurantID)
        .collection(C_C_MENU)
        .get();
  }

  // one menu get method
  Future<DocumentSnapshot<Map<String, dynamic>>> getMenu() async {
    return await _firestore
        .collection(C_RESTAURANTS)
        .doc(globals.restaurantID)
        .collection(C_C_MENU)
        .doc(globals.menuID)
        .get();
  }
}
