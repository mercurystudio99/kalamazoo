import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:kalamazoo/utils/util.dart';
import 'package:kalamazoo/utils/navigation_router.dart';
import 'package:kalamazoo/utils/color.dart';
import 'package:kalamazoo/models/app_model.dart';

class Registration2Screen extends StatefulWidget {
  const Registration2Screen({super.key});

  @override
  State<Registration2Screen> createState() => _Registration2ScreenState();
}

class _Registration2ScreenState extends State<Registration2Screen> {
  late final FirebaseMessaging _messaging;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _businessnameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final FocusNode _focusUser = FocusNode();
  final FocusNode _focusBusiness = FocusNode();
  final FocusNode _focusAddress = FocusNode();
  final FocusNode _focusPhone = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPass = FocusNode();

  bool _obscureText = true;
  bool _isCheckedPolicy = false;
  bool _checkConfirmPolicy = false;
  bool _showDaysHours = false;
  String _checkBusiness = '';
  bool _checkConfirmBusiness = false;

  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  List<Map<String, dynamic>> schedule = [
    {
      RESTAURANT_SCHEDULE_DAY: L_TUESDAY,
      RESTAURANT_SCHEDULE_STARTHOUR: L_START_HOUR,
      RESTAURANT_SCHEDULE_STARTMINUTE: L_START_MINUTE,
      RESTAURANT_SCHEDULE_ENDHOUR: L_END_HOUR,
      RESTAURANT_SCHEDULE_ENDMINUTE: L_END_MINUTE,
      RESTAURANT_SCHEDULE_ISWORKINGDAY: false
    },
    {
      RESTAURANT_SCHEDULE_DAY: L_WEDNESDAY,
      RESTAURANT_SCHEDULE_STARTHOUR: L_START_HOUR,
      RESTAURANT_SCHEDULE_STARTMINUTE: L_START_MINUTE,
      RESTAURANT_SCHEDULE_ENDHOUR: L_END_HOUR,
      RESTAURANT_SCHEDULE_ENDMINUTE: L_END_MINUTE,
      RESTAURANT_SCHEDULE_ISWORKINGDAY: true
    },
    {
      RESTAURANT_SCHEDULE_DAY: L_THURSDAY,
      RESTAURANT_SCHEDULE_STARTHOUR: L_START_HOUR,
      RESTAURANT_SCHEDULE_STARTMINUTE: L_START_MINUTE,
      RESTAURANT_SCHEDULE_ENDHOUR: L_END_HOUR,
      RESTAURANT_SCHEDULE_ENDMINUTE: L_END_MINUTE,
      RESTAURANT_SCHEDULE_ISWORKINGDAY: true
    },
    {
      RESTAURANT_SCHEDULE_DAY: L_FRIDAY,
      RESTAURANT_SCHEDULE_STARTHOUR: L_START_HOUR,
      RESTAURANT_SCHEDULE_STARTMINUTE: L_START_MINUTE,
      RESTAURANT_SCHEDULE_ENDHOUR: L_END_HOUR,
      RESTAURANT_SCHEDULE_ENDMINUTE: L_END_MINUTE,
      RESTAURANT_SCHEDULE_ISWORKINGDAY: true
    },
    {
      RESTAURANT_SCHEDULE_DAY: L_SATURDAY,
      RESTAURANT_SCHEDULE_STARTHOUR: L_START_HOUR,
      RESTAURANT_SCHEDULE_STARTMINUTE: L_START_MINUTE,
      RESTAURANT_SCHEDULE_ENDHOUR: L_END_HOUR,
      RESTAURANT_SCHEDULE_ENDMINUTE: L_END_MINUTE,
      RESTAURANT_SCHEDULE_ISWORKINGDAY: true
    },
    {
      RESTAURANT_SCHEDULE_DAY: L_SUNDAY,
      RESTAURANT_SCHEDULE_STARTHOUR: L_START_HOUR,
      RESTAURANT_SCHEDULE_STARTMINUTE: L_START_MINUTE,
      RESTAURANT_SCHEDULE_ENDHOUR: L_END_HOUR,
      RESTAURANT_SCHEDULE_ENDMINUTE: L_END_MINUTE,
      RESTAURANT_SCHEDULE_ISWORKINGDAY: true
    },
    {
      RESTAURANT_SCHEDULE_DAY: L_MONDAY,
      RESTAURANT_SCHEDULE_STARTHOUR: L_START_HOUR,
      RESTAURANT_SCHEDULE_STARTMINUTE: L_START_MINUTE,
      RESTAURANT_SCHEDULE_ENDHOUR: L_END_HOUR,
      RESTAURANT_SCHEDULE_ENDMINUTE: L_END_MINUTE,
      RESTAURANT_SCHEDULE_ISWORKINGDAY: false
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusUser.dispose();
    _focusBusiness.dispose();
    _focusAddress.dispose();
    _focusPhone.dispose();
    _focusEmail.dispose();
    _focusPass.dispose();
    super.dispose();
  }

  void setFCMToken() async {
    _messaging = FirebaseMessaging.instance;
    String? token = await _messaging.getToken();
    AppModel().setFCMToken(token: token ?? '', onSuccess: () {});
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return '\u26A0 Please enter your password';
    }
    if (value.length < 8) {
      return '\u26A0 The Password must be at least 8 characters.';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return '\u26A0 Please enter your email';
    }
    if (!(value.isNotEmpty && value.contains("@") && value.contains("."))) {
      return '\u26A0 The E-mail Address must be a valid email address.';
    }
    return null;
  }

  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return '\u26A0 Please enter your name';
    }
    return null;
  }

  String? _validateBusinessname(String value) {
    if (value.isEmpty) {
      return '\u26A0 Please enter business name';
    }
    return null;
  }

  String? _validateAddress(String value) {
    if (value.isEmpty) {
      return '\u26A0 Please enter address';
    }
    return null;
  }

  String? _validatePhone(String value) {
    if (value.isEmpty) {
      return '\u26A0 Please enter phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> scheduleView = [];
    for (var element in schedule) {
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
          if (_focusUser.hasFocus == false &&
              _focusBusiness.hasFocus == false &&
              _focusAddress.hasFocus == false &&
              _focusPhone.hasFocus == false &&
              _focusEmail.hasFocus == false &&
              _focusPass.hasFocus == false)
            Positioned(
                left: 0,
                bottom: MediaQuery.of(context).size.height * 0.2,
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: CustomColor.primaryColor.withOpacity(0.15),
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
          ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Util.mainPadding * 0.5),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: CustomColor.primaryColor,
                    ),
                    onPressed: () {
                      NavigationRouter.back(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
                child: Text(
                  Util.registerTitle,
                  style: TextStyle(
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Util.titleSize),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Util.mainPadding),
                child: Text(
                  Util.registerCaption,
                  style: TextStyle(
                      color: CustomColor.textDetailColor,
                      fontSize: Util.descriptionSize),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            controller: _usernameController,
                            focusNode: _focusUser,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Personal Name',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              return _validateUsername(value!);
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
                            controller: _businessnameController,
                            focusNode: _focusBusiness,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Business Name',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              return _validateBusinessname(value!);
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
                            controller: _addressController,
                            focusNode: _focusAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Add Address',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              return _validateAddress(value!);
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
                            controller: _phoneController,
                            focusNode: _focusPhone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone Number',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              return _validatePhone(value!);
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
                            controller: _emailController,
                            focusNode: _focusEmail,
                            keyboardType: TextInputType
                                .emailAddress, // Use email input type for emails.
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'you@example.com',
                              labelText: 'Email Address',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              return _validateEmail(value!);
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
                            controller: _passController,
                            focusNode: _focusPass,
                            obscureText:
                                _obscureText, // Use secure text for passwords.
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Password',
                                suffixIconConstraints: const BoxConstraints(
                                  minWidth: 50,
                                  minHeight: 2,
                                ),
                                suffixIcon: InkWell(
                                  onTap: _toggle,
                                  child: Icon(
                                      _obscureText
                                          ? Icons.remove_red_eye_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 24),
                                )),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              return _validatePassword(value!);
                            },
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
                          horizontal: Util.mainPadding * 0.5),
                      child: Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return (_checkConfirmBusiness
                                  ? CustomColor.activeColor
                                  : CustomColor.primaryColor);
                            }
                            return (_checkConfirmBusiness
                                ? CustomColor.activeColor
                                : CustomColor.primaryColor);
                          }),
                          value: (_checkBusiness == C_BREWERIES) ? true : false,
                          onChanged: (bool? value) {
                            setState(() {
                              _checkBusiness = C_BREWERIES;
                            });
                          },
                        ),
                        const Text(
                          'Brewery',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return (_checkConfirmBusiness
                                  ? CustomColor.activeColor
                                  : CustomColor.primaryColor);
                            }
                            return (_checkConfirmBusiness
                                ? CustomColor.activeColor
                                : CustomColor.primaryColor);
                          }),
                          value:
                              (_checkBusiness == 'Food Truck') ? true : false,
                          onChanged: (bool? value) {
                            setState(() {
                              _checkBusiness = 'Food Truck';
                            });
                          },
                        ),
                        const Text(
                          'Food Truck',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: Util.mainPadding * 0.5)
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Util.mainPadding * 0.5),
                      child: Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return (_checkConfirmBusiness
                                  ? CustomColor.activeColor
                                  : CustomColor.primaryColor);
                            }
                            return (_checkConfirmBusiness
                                ? CustomColor.activeColor
                                : CustomColor.primaryColor);
                          }),
                          value:
                              (_checkBusiness == C_RESTAURANTS) ? true : false,
                          onChanged: (bool? value) {
                            setState(() {
                              _checkBusiness = C_RESTAURANTS;
                            });
                          },
                        ),
                        const Text(
                          'Restaurant',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return (_checkConfirmBusiness
                                  ? CustomColor.activeColor
                                  : CustomColor.primaryColor);
                            }
                            return (_checkConfirmBusiness
                                ? CustomColor.activeColor
                                : CustomColor.primaryColor);
                          }),
                          value: (_checkBusiness == C_WINERIES) ? true : false,
                          onChanged: (bool? value) {
                            setState(() {
                              _checkBusiness = C_WINERIES;
                            });
                          },
                        ),
                        const Text(
                          'Winery',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: Util.mainPadding * 1.5)
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Util.mainPadding * 0.5),
                      child: Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return (_checkConfirmBusiness
                                  ? CustomColor.activeColor
                                  : CustomColor.primaryColor);
                            }
                            return (_checkConfirmBusiness
                                ? CustomColor.activeColor
                                : CustomColor.primaryColor);
                          }),
                          value: (_checkBusiness == 'Catering') ? true : false,
                          onChanged: (bool? value) {
                            setState(() {
                              _checkBusiness = 'Catering';
                            });
                          },
                        ),
                        const Text(
                          'Catering',
                          style: TextStyle(fontSize: 16),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding),
                      child: Stack(children: [
                        Container(
                          height: 54,
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
                              title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/amenities/amenities.png',
                                      scale: 0.8,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Amenities',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        NavigationRouter.switchToAmenities(
                                            context);
                                      },
                                      child: const Text(
                                        'Seen All',
                                        style: TextStyle(
                                            color: CustomColor.activeColor),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          NavigationRouter.switchToAmenities(
                                              context);
                                        },
                                        child: const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: CustomColor.activeColor)),
                                  ]),
                              contentPadding:
                                  const EdgeInsets.only(left: 15, right: 15),
                            ),
                          ]),
                        )
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: Util.mainPadding * 0.5),
                      child: Row(children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return (_checkConfirmPolicy
                                  ? CustomColor.activeColor
                                  : Colors.black.withOpacity(.32));
                            }
                            return (_checkConfirmPolicy
                                ? CustomColor.activeColor
                                : Colors.black);
                          }),
                          value: _isCheckedPolicy,
                          onChanged: (bool? value) {
                            setState(() {
                              _isCheckedPolicy = value!;
                            });
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'By Signing up, I agree to the ',
                                  style: GoogleFonts.poppins(
                                      color: CustomColor.textHeadColor,
                                      fontSize: Util.descriptionSize),
                                ),
                                TextSpan(
                                  text: 'term Of Service',
                                  style: GoogleFonts.poppins(
                                      color: CustomColor.textHeadColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Util.descriptionSize),
                                ),
                              ]),
                            ),
                            Text(
                              '& privacy Policy',
                              style: GoogleFonts.poppins(
                                  color: CustomColor.textHeadColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Util.descriptionSize),
                            )
                          ],
                        )
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: Util.registerQuestion,
                      style: GoogleFonts.poppins(
                          color: CustomColor.textDetailColor,
                          fontSize: Util.descriptionSize),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                        text: Util.loginTitle,
                        style: GoogleFonts.poppins(
                            color: CustomColor.primaryColor,
                            fontSize: Util.descriptionSize),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigationRouter.switchToLogin(context);
                          }),
                  ]),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: Util.mainPadding),
                child: SizedBox(
                    height: 50, //height of button
                    width: MediaQuery.of(context).size.width, //width of button
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
                        _checkConfirmBusiness = true;
                        if (_checkBusiness.isNotEmpty) {
                          _checkConfirmBusiness = false;
                        }

                        if (_isCheckedPolicy) {
                          _checkConfirmPolicy = false;
                          setState(() {});
                        } else {
                          _checkConfirmPolicy = true;
                          setState(() {});
                        }
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          if (_checkConfirmBusiness) return;
                          if (_checkConfirmPolicy) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          // sign up
                          AppModel().userExist(
                              email: _emailController.text.trim(),
                              onSuccess: (String id) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'The account already exists for that email.')),
                                );
                              },
                              onError: (String text) {
                                AppModel().registerRestaurant(
                                    email: _emailController.text.trim(),
                                    businessname:
                                        _businessnameController.text.trim(),
                                    address: _addressController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                    businessservice: _checkBusiness,
                                    city: 'Kalamazoo',
                                    state: 'MI',
                                    zip: '49001',
                                    schedule: schedule,
                                    onSuccess: (String id) {
                                      AppModel().ownerSignUp(
                                          restaurantId: id,
                                          restaurantService: _checkBusiness,
                                          name: _usernameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password: _passController.text.trim(),
                                          businessname: _businessnameController
                                              .text
                                              .trim(),
                                          address:
                                              _addressController.text.trim(),
                                          phone: _phoneController.text.trim(),
                                          onSuccess: () {
                                            setFCMToken();
                                            // Go to Restaurant
                                            NavigationRouter.switchToAbout(
                                                context);
                                          },
                                          onError: (String text) {
                                            // Show error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(content: Text(text)),
                                            );
                                          });
                                    });
                              });
                        }
                      },
                      child: const Text(
                        Util.buttonSignup,
                        style: TextStyle(
                            color: CustomColor.buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )),
              ),
              const SizedBox(height: 15),
              const Center(
                  child: Text(
                '\'Do You Need Help? Contact Us!\'',
                style: TextStyle(color: CustomColor.textDetailColor),
              )),
              const Center(
                  child: Text(
                'contactus@bestlocaleats.net',
                style: TextStyle(color: CustomColor.primaryColor, fontSize: 16),
              )),
              const SizedBox(
                height: Util.mainPadding,
              )
            ],
          )
        ],
      ),
    );
  }
}
