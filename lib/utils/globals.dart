library globals;

import 'package:kalamazoo/utils/constants.dart';

String userID = "";
String userEmail = "";
String userPass = "";
String userRole = "";
List<dynamic> userFavourites = [];
List<dynamic> ownerAmenities = [];
String ownerBusinessID = "";
String ownerBusinessType = "";

String restaurantType = C_RESTAURANTS;
String restaurantID = "";
double restaurantRating = 0;
String menuCategory = "";
String menuID = "";
String listTarget = '';

String searchFullAddress = "Kalamazoo, MI, USA";
String searchCity = "Kalamazoo";
String searchZip = "";
String searchPriority = RESTAURANT_CITY;
String searchKeyword = '';
List<dynamic> searchAmenities = [];
int searchDistanceRange = 0;
String searchOpen = 'all';

double latitude = 0;
double longitude = 0;

List<Map<String, dynamic>> notifications = [];
