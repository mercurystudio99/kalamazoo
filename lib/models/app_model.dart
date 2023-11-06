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

  String getSearchAreaKey() {
    return (globals.searchPriority == RESTAURANT_ZIP)
        ? globals.searchZip
        : globals.searchCity;
  }

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
      USER_ROLE: globals.userRole,
      USER_FAVOURITIES: [],
    });
    globals.userEmail = email;
    globals.userID = docRef.id;
    onSuccess();
  }

  void ownerSignUp({
    required String restaurantId,
    required String restaurantService,
    required String name,
    required String email,
    required String password,
    required String businessname,
    required String address,
    required String phone,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final docRef = _firestore.collection(C_USERS).doc();
    await docRef.set({
      USER_ID: docRef.id,
      USER_RESTAURANT_ID: restaurantId,
      USER_RESTAURANT_SERVICE: restaurantService,
      USER_FULLNAME: name,
      USER_EMAIL: email,
      USER_PASS: password,
      USER_BUSINESSNAME: businessname,
      USER_LOCATION: address,
      USER_PHONE_NUMBER: phone,
      USER_ROLE: globals.userRole,
      USER_FAVOURITIES: [],
      USER_AMENITIES: globals.ownerAmenities
    });
    globals.userEmail = email;
    globals.userID = docRef.id;
    globals.restaurantID = restaurantId;
    globals.ownerBusinessID = restaurantId;
    globals.restaurantType = restaurantService;
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
              globals.userRole = docSnapshot.data()[USER_ROLE];
              if (docSnapshot.data()[USER_FAVOURITIES].isNotEmpty) {
                globals.userFavourites = docSnapshot.data()[USER_FAVOURITIES];
              }
              if (docSnapshot.data()[USER_RESTAURANT_ID] != null &&
                  docSnapshot.data()[USER_RESTAURANT_ID].isNotEmpty) {
                globals.restaurantID = docSnapshot.data()[USER_RESTAURANT_ID];
                globals.ownerBusinessID =
                    docSnapshot.data()[USER_RESTAURANT_ID];
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
    required Function(String) onSuccess,
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
            if (docSnapshot.data()[USER_RESTAURANT_ID] != null &&
                docSnapshot.data()[USER_RESTAURANT_ID].isNotEmpty) {
              globals.restaurantID = docSnapshot.data()[USER_RESTAURANT_ID];
              globals.ownerBusinessID = docSnapshot.data()[USER_RESTAURANT_ID];
            }
            globals.userPass = docSnapshot.data()[USER_PASS];
            globals.userRole = docSnapshot.data()[USER_ROLE];
            break;
          }
          onSuccess(retrieveID!);
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

  // FCM token set method
  void setFCMToken({
    required String token,
    // callback functions
    required VoidCallback onSuccess,
  }) {
    _firestore
        .collection(C_USERS)
        .doc(globals.userID)
        .update({USER_FCM_TOKEN: token}).then((value) => onSuccess(),
            onError: (e) => debugPrint("Error updating document $e"));
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

  void getTopMenu({
    required Function(List<Map<String, dynamic>>) onSuccess,
    required VoidCallback onEmpty,
  }) async {
    final snapshots = await _firestore
        .collection(C_TOPMENU)
        .orderBy(TOPMENU_NAME, descending: false)
        .get();
    if (snapshots.docs.isEmpty) {
      onEmpty();
    } else {
      List<Map<String, dynamic>> list = [];
      for (var element in snapshots.docs) {
        list.add(element.data());
      }
      onSuccess(list);
    }
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

  void getOffers({
    required bool all,
    // callback functions
    required Function(List<Map<String, dynamic>>) onSuccess,
  }) {
    // categories.forEach((key, value) {
    // if (value) {
    if (all) {
      _firestore
          .collection(globals.restaurantType)
          .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
          .get()
          .then(
        (querySnapshot) {
          List<Map<String, dynamic>> result = [];
          for (var snapshot in querySnapshot.docs) {
            result.add(snapshot.data());
          }
          onSuccess(result);
        },
        onError: (e) => debugPrint("Error completing: $e"),
      );
    } else {
      _firestore
          .collection(globals.restaurantType)
          .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
          .limit(2)
          .get()
          .then(
        (querySnapshot) {
          List<Map<String, dynamic>> result = [];
          for (var snapshot in querySnapshot.docs) {
            result.add(snapshot.data());
          }
          onSuccess(result);
        },
        onError: (e) => debugPrint("Error completing: $e"),
      );
    }
    // }
    // });
  }

  void getBrands({
    required bool all,
    // callback functions
    required Function(List<Map<String, dynamic>>) onSuccess,
  }) {
    if (all) {
      _firestore
          .collection(globals.restaurantType)
          .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
          .where(RESTAURANT_BRAND, isEqualTo: true)
          .get()
          .then(
        (querySnapshot) {
          List<Map<String, dynamic>> result = [];
          for (var snapshot in querySnapshot.docs) {
            result.add(snapshot.data());
          }
          onSuccess(result);
        },
        onError: (e) => debugPrint("Error completing: $e"),
      );
    } else {
      _firestore
          .collection(globals.restaurantType)
          .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
          .where(RESTAURANT_BRAND, isEqualTo: true)
          .limit(2)
          .get()
          .then(
        (querySnapshot) {
          List<Map<String, dynamic>> result = [];
          for (var snapshot in querySnapshot.docs) {
            result.add(snapshot.data());
          }
          onSuccess(result);
        },
        onError: (e) => debugPrint("Error completing: $e"),
      );
    }
  }

  void getAmenities({
    required Function(List<Map<String, dynamic>>) onSuccess,
    required VoidCallback onEmpty,
  }) async {
    final snapshots = await _firestore
        .collection(C_AMENITIES)
        .orderBy(AMENITY_NAME, descending: false)
        .get();
    if (snapshots.docs.isEmpty) {
      onEmpty();
    } else {
      List<Map<String, dynamic>> list = [];
      for (var element in snapshots.docs) {
        list.add(element.data());
      }
      onSuccess(list);
    }
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
  Future<QuerySnapshot<Map<String, dynamic>>> getListRestaurant() async {
    if (globals.listTarget == 'brands') {
      return await _firestore
          .collection(globals.restaurantType)
          .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
          .where(RESTAURANT_BRAND, isEqualTo: true)
          .get();
    } else if (globals.listTarget == 'offers') {
      return await _firestore
          .collection(globals.restaurantType)
          .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
          .get();
    } else {
      return await _firestore
          .collection(globals.restaurantType)
          .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
          .get();
    }
  }

  // restaurant get method
  Future<QuerySnapshot<Map<String, dynamic>>> getSearchRestaurant() async {
    return await _firestore
        .collection(globals.restaurantType)
        .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
        .get();
  }

  // restaurant get method
  Future<QuerySnapshot<Map<String, dynamic>>> getRestaurant() async {
    return await _firestore
        .collection(globals.restaurantType)
        .where(RESTAURANT_ID, isEqualTo: globals.restaurantID)
        .get();
  }

  void getRestaurantProfile({
    required String businessId,
    required String businessService,
    // callback functions
    required Function(Map<String, dynamic>) onSuccess,
  }) {
    _firestore
        .collection(businessService)
        .where(RESTAURANT_ID, isEqualTo: businessId)
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

  void saveRestaurantProfile({
    required String imageUrl,
    required String businessservice,
    required String businessId,
    required List<Map<String, dynamic>> schedule,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    if (businessservice == C_RESTAURANTS ||
        businessservice == C_WINERIES ||
        businessservice == C_BREWERIES) {
      _firestore.collection(businessservice).doc(businessId).update({
        RESTAURANT_IMAGE: imageUrl,
        RESTAURANT_SCHEDULE: schedule,
      }).then((value) => onSuccess(),
          onError: (e) => debugPrint("Error updating document $e"));
    }
  }

  void getListByTopMenu({
    required String topMenu,
    // callback functions
    required Function(List<Map<String, dynamic>>) onSuccess,
  }) async {
    final snapshots = await _firestore
        .collection(globals.restaurantType)
        .where(RESTAURANT_CATEGORY, isEqualTo: topMenu)
        .where(globals.searchPriority, isEqualTo: getSearchAreaKey())
        .get();
    if (snapshots.docs.isNotEmpty) {
      List<Map<String, dynamic>> list = [];
      for (var element in snapshots.docs) {
        list.add(element.data());
      }
      onSuccess(list);
    }
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

  void saveMenu({
    required String imageUrl,
    required String name,
    required String price,
    required String desc,
    required String category,
    // VoidCallback functions
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    final docRef = _firestore
        .collection(globals.restaurantType)
        .doc(globals.restaurantID)
        .collection(C_C_MENU)
        .doc();
    if (category.isEmpty) {
      await docRef.set({
        MENU_ID: docRef.id,
        MENU_PHOTO: imageUrl,
        MENU_NAME: name,
        MENU_PRICE: price,
        MENU_DESCRIPTION: desc,
      });
    } else {
      await docRef.set({
        MENU_ID: docRef.id,
        MENU_PHOTO: imageUrl,
        MENU_NAME: name,
        MENU_PRICE: price,
        MENU_DESCRIPTION: desc,
        MENU_CATEGORY: category,
      });
    }
    onSuccess();
  }

  void getRestaurantFoodByID({
    // callback functions
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(String) onError,
  }) {
    _firestore
        .collection(C_RESTAURANTS)
        .doc(globals.restaurantID)
        .collection(C_C_MENU)
        .get()
        .then(
      (querySnapshot) {
        List<Map<String, dynamic>> result = [];
        for (var snapshot in querySnapshot.docs) {
          result.add(snapshot.data());
        }
        onSuccess(result);
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  void getCategories({
    required Function(List<Map<String, dynamic>>) onSuccess,
    required VoidCallback onEmpty,
  }) async {
    final snapshots = await _firestore
        .collection(C_CATEGORIES)
        .orderBy(CATEGORY_NAME, descending: false)
        .get();
    if (snapshots.docs.isEmpty) {
      onEmpty();
    } else {
      List<Map<String, dynamic>> list = [];
      for (var element in snapshots.docs) {
        list.add(element.data());
      }
      onSuccess(list);
    }
  }

  void setSubscription({
    required int count,
    required String type,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    _firestore.collection(C_USERS).doc(globals.userID).update({
      USER_SUBSCRIPTION_DATE: DateTime.now(),
      USER_SUBSCRIPTION_COUNT: count,
      USER_SUBSCRIPTION_TYPE: type,
    }).then((value) => onSuccess(),
        onError: (e) => debugPrint("Error updating document $e"));
  }

  void registerRestaurant({
    required String email,
    required String businessname,
    required String address,
    required String phone,
    required String businessservice,
    required String city,
    required String state,
    required String zip,
    required List<Map<String, dynamic>> schedule,
    // callback functions
    required Function(String) onSuccess,
  }) async {
    if (businessservice == C_RESTAURANTS ||
        businessservice == C_WINERIES ||
        businessservice == C_BREWERIES) {
      final docRef = _firestore.collection(businessservice).doc();
      await docRef.set({
        RESTAURANT_ID: docRef.id,
        RESTAURANT_ADDRESS: address,
        RESTAURANT_AMENITIES: globals.ownerAmenities,
        RESTAURANT_BUSINESSNAME: businessname,
        RESTAURANT_CATEGORY: '',
        RESTAURANT_CITY: city,
        RESTAURANT_EMAIL: email,
        RESTAURANT_GEOLOCATION: [0, 0],
        RESTAURANT_PHONE: phone,
        RESTAURANT_STATE: state,
        RESTAURANT_URL: '',
        RESTAURANT_ZIP: zip,
        RESTAURANT_SCHEDULE: schedule,
      });
      onSuccess(docRef.id);
    }
  }

  void getDailySpecial({
    int? limit,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required VoidCallback onEmpty,
  }) async {
    if (limit != null) {
      final snapshots = await _firestore
          .collection(C_DAILYSPECIAL)
          .where(DAILYSPECIAL_ACTIVE, isEqualTo: true)
          .limit(limit)
          .get();
      if (snapshots.docs.isEmpty) {
        onEmpty();
      } else {
        List<Map<String, dynamic>> list = [];
        for (var element in snapshots.docs) {
          list.add(element.data());
        }
        onSuccess(list);
      }
    } else {
      final snapshots = await _firestore
          .collection(C_DAILYSPECIAL)
          .where(DAILYSPECIAL_ACTIVE, isEqualTo: true)
          .get();
      if (snapshots.docs.isEmpty) {
        onEmpty();
      } else {
        List<Map<String, dynamic>> list = [];
        for (var element in snapshots.docs) {
          list.add(element.data());
        }
        onSuccess(list);
      }
    }
  }

  void setDailySpecial({
    required String imageLink,
    required String desc,
    // callback functions
    required VoidCallback onSuccess,
  }) async {
    final docRef = _firestore.collection(C_DAILYSPECIAL).doc();
    await docRef.set({
      DAILYSPECIAL_ID: docRef.id,
      DAILYSPECIAL_IMAGE_LINK: imageLink,
      DAILYSPECIAL_DESC: desc,
      DAILYSPECIAL_ACTIVE: false,
      DAILYSPECIAL_BUSINESS_ID: globals.ownerBusinessID,
      DAILYSPECIAL_BUSINESS_TYPE: globals.ownerBusinessType,
    });
    onSuccess();
  }

  void updateUserDailySpecial({
    int? count,
    DateTime? date,
    // callback functions
    required VoidCallback onSuccess,
  }) {
    if (count != null) {
      _firestore.collection(C_USERS).doc(globals.userID).update({
        USER_SUBSCRIPTION_COUNT: count,
      }).then((value) => onSuccess(),
          onError: (e) => debugPrint("Error updating document $e"));
    }
    if (date != null) {
      _firestore.collection(C_USERS).doc(globals.userID).update({
        USER_SUBSCRIPTION_DATE: date,
      }).then((value) => onSuccess(),
          onError: (e) => debugPrint("Error updating document $e"));
    }
  }

  void getEventBanners({
    required Function(List<String>) onSuccess,
  }) async {
    List<String> banners = [];
    final snapshots =
        await _firestore.collection(C_EVENTS).doc('banners').get();
    if (snapshots.data()!.isNotEmpty) {
      for (var item in snapshots.data()!['banners']) {
        banners.add(item);
      }
    }
    onSuccess(banners);
  }

  void getEventForMonth({
    required String year,
    required String month,
    required Function(List<Map<String, dynamic>>) onSuccess,
  }) async {
    final snapshots = await _firestore
        .collection(C_EVENTS)
        .where(EVENT_YEAR, isEqualTo: year)
        .where(EVENT_MONTH, isEqualTo: month)
        .get();
    if (snapshots.docs.isEmpty) {
      onSuccess([]);
    } else {
      List<Map<String, dynamic>> list = [];
      for (var element in snapshots.docs) {
        list.add(element.data());
      }
      onSuccess(list);
    }
  }
}
