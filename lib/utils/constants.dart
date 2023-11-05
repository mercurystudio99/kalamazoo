// ignore_for_file: constant_identifier_names

const int L_START_HOUR = 8;
const int L_START_MINUTE = 0;
const int L_END_HOUR = 21;
const int L_END_MINUTE = 0;

const String L_MONDAY = "Monday";
const String L_TUESDAY = "Tuesday";
const String L_WEDNESDAY = "Wednesday";
const String L_THURSDAY = "Thursday";
const String L_FRIDAY = "Friday";
const String L_SATURDAY = "Saturday";
const String L_SUNDAY = "Sunday";

/// DATABASE COLLECTION NAMES USED IN APP
///
const String C_APPINFO = "AppInfo";
const String C_USERS = "Users";
const String C_RESTAURANTS = "Restaurants";
const String C_WINERIES = "Wineries";
const String C_BREWERIES = "Breweries";
const String C_AMENITIES = "Amenities";
const String C_TOPMENU = "TopMenus";
const String C_CATEGORIES = "Categories";
const String C_DAILYSPECIAL = "DailySpecial";
const String C_EVENTS = "Events";
const String C_C_MENU = "Menu";

/// DATABASE FIELDS FOR USER COLLECTION  ///
///
const String USER_ID = "user_id";
const String USER_PROFILE_PHOTO = "user_photo_link";
const String USER_FULLNAME = "user_fullname";
const String USER_BUSINESSNAME = "user_businessname";
const String USER_GENDER = "user_gender";
const String USER_BIRTH_DAY = "user_birth_day";
const String USER_BIRTH_MONTH = "user_birth_month";
const String USER_BIRTH_YEAR = "user_birth_year";
const String USER_PHONE_NUMBER = "user_phone_number";
const String USER_EMAIL = "user_email";
const String USER_PASS = "user_pass";
const String USER_LOCATION = "user_location";
const String USER_FAVOURITIES = "user_favourites";
const String USER_AMENITIES = "user_amenities";
const String USER_ROLE = "user_role";
const String USER_STATUS = "user_status";
const String USER_IS_VERIFIED = "user_is_verified";
const String USER_REG_DATE = "user_reg_date";
const String USER_LAST_LOGIN = "user_last_login";
const String USER_RESTAURANT_ID = "user_restaurant_id";
const String USER_SUBSCRIPTION_DATE = "user_subscription_date";
const String USER_SUBSCRIPTION_COUNT = "user_subscription_count";
const String USER_SUBSCRIPTION_TYPE = "user_subscription_type";
const String USER_FCM_TOKEN = "user_fcm_token";

const String RESTAURANT_ID = "id";
const String RESTAURANT_ADDRESS = "address";
const String RESTAURANT_BRAND = "brand";
const String RESTAURANT_BUSINESSNAME = "businessName";
const String RESTAURANT_CITY = "city";
const String RESTAURANT_EMAIL = "email";
const String RESTAURANT_GEOLOCATION = "geolocation";
const String RESTAURANT_PHONE = "phone";
const String RESTAURANT_IMAGE = "imageLink";
const String RESTAURANT_STATE = "state";
const String RESTAURANT_URL = "url";
const String RESTAURANT_ZIP = "zip";
const String RESTAURANT_RATING = "rating";
const String RESTAURANT_SCHEDULE = "schedule";
const String RESTAURANT_SCHEDULE_DAY = "day";
const String RESTAURANT_SCHEDULE_STARTHOUR = "startHour";
const String RESTAURANT_SCHEDULE_STARTMINUTE = "startMinute";
const String RESTAURANT_SCHEDULE_ENDHOUR = "endHour";
const String RESTAURANT_SCHEDULE_ENDMINUTE = "endMinute";
const String RESTAURANT_SCHEDULE_ISWORKINGDAY = "isWorkingDay";

const String RESTAURANT_AMENITIES = "amenities";
const String RESTAURANT_DISCOUNT = "discount";
const String RESTAURANT_MINCOST = "mincost";
const String RESTAURANT_CATEGORY = "category";

const String MENU_ID = "id";
const String MENU_NAME = "name";
const String MENU_PRICE = "price";
const String MENU_DESCRIPTION = "description";
const String MENU_PHOTO = "photoLink";
const String MENU_CATEGORY = "category";

const String AMENITY_ID = "id";
const String AMENITY_NAME = "name";
const String AMENITY_LOGO = "logo";
const String AMENITY_TYPE = "type";

const String TOPMENU_ID = "id";
const String TOPMENU_NAME = "name";
const String TOPMENU_IMAGE = "imgName";

const String CATEGORY_ID = "id";
const String CATEGORY_NAME = "name";

const String DAILYSPECIAL_ID = "id";
const String DAILYSPECIAL_IMAGE_LINK = "image_link";
const String DAILYSPECIAL_DESC = "description";
const String DAILYSPECIAL_ACTIVE = "active";
const String DAILYSPECIAL_BUSINESS_ID = "business_id";
const String DAILYSPECIAL_BUSINESS_TYPE = "business_type";

const String EVENT_ID = "id";
const String EVENT_TITLE = "title";
const String EVENT_DESC = "description";
const String EVENT_YEAR = "year";
const String EVENT_MONTH = "month";
const String EVENT_DATE = "date";
const String EVENT_MILLISECONDS = "milliseconds";
