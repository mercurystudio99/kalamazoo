import 'package:kalamazoo/utils/constants.dart';

class User {
  // User info
  final String userId;
  final String userProfilePhoto;
  final String userFullname;
  final String userBusinessname;
  final String userGender;
  final int userBirthDay;
  final int userBirthMonth;
  final int userBirthYear;
  final String userPhoneNumber;
  final String userEmail;
  final String userPass;
  final String userLocation;
  final List<dynamic> userFavourites;
  final List<dynamic> userAmenities;
  final String userRole;
  final String userStatus;
  final bool userIsVerified;
  final DateTime userRegDate;
  final DateTime userLastLogin;

  // Constructor
  User({
    required this.userId,
    required this.userProfilePhoto,
    required this.userFullname,
    required this.userBusinessname,
    required this.userGender,
    required this.userBirthDay,
    required this.userBirthMonth,
    required this.userBirthYear,
    required this.userPhoneNumber,
    required this.userEmail,
    required this.userPass,
    required this.userLocation,
    required this.userFavourites,
    required this.userAmenities,
    required this.userRole,
    required this.userStatus,
    required this.userIsVerified,
    required this.userRegDate,
    required this.userLastLogin,
  });

  // factory user object
  factory User.fromDocument(Map<String, dynamic> doc) {
    return User(
      userId: doc[USER_ID],
      userProfilePhoto: doc[USER_PROFILE_PHOTO],
      userFullname: doc[USER_FULLNAME] ?? '',
      userBusinessname: doc[USER_BUSINESSNAME] ?? '',
      userGender: doc[USER_GENDER],
      userBirthDay: doc[USER_BIRTH_DAY],
      userBirthMonth: doc[USER_BIRTH_MONTH],
      userBirthYear: doc[USER_BIRTH_YEAR],
      userPhoneNumber: doc[USER_PHONE_NUMBER] ?? '',
      userEmail: doc[USER_EMAIL] ?? '',
      userPass: doc[USER_PASS] ?? '',
      userLocation: doc[USER_LOCATION] ?? '',
      userFavourites: doc[USER_FAVOURITIES] ?? [],
      userAmenities: doc[USER_AMENITIES] ?? [],
      userRole: doc[USER_ROLE] ?? '',
      userStatus: doc[USER_STATUS],
      userIsVerified: doc[USER_IS_VERIFIED] ?? false,
      userRegDate: doc[USER_REG_DATE].toDate(), // Firestore Timestamp
      userLastLogin: doc[USER_LAST_LOGIN].toDate(), // Firestore Timestamp
    );
  }
}
