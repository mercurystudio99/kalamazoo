import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final List<bool> _isCheckedBusiness = <bool>[false, false, false, false];
  bool _checkConfirmBusiness = false;

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
              const SizedBox(height: 80),
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
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Tuesday',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    const Spacer(),
                                                    const Text(
                                                        'Closed          ',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .activeColor,
                                                            fontSize: 16)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.edit_outlined,
                                                            color:
                                                                Colors.black)),
                                                  ])),
                                          Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Wednesday',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    const Spacer(),
                                                    const Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.edit_outlined,
                                                            color:
                                                                Colors.black)),
                                                  ])),
                                          Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Thursday',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    const Spacer(),
                                                    const Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.edit_outlined,
                                                            color:
                                                                Colors.black)),
                                                  ])),
                                          Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Friday',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    const Spacer(),
                                                    const Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.edit_outlined,
                                                            color:
                                                                Colors.black)),
                                                  ])),
                                          Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Saturday',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    const Spacer(),
                                                    const Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.edit_outlined,
                                                            color:
                                                                Colors.black)),
                                                  ])),
                                          Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Sunday',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    const Spacer(),
                                                    const Text(
                                                        '8:00 AM - 9:00 PM',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.edit_outlined,
                                                            color:
                                                                Colors.black)),
                                                  ])),
                                          Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Monday',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .textDetailColor,
                                                            fontSize: 16)),
                                                    const Spacer(),
                                                    const Text(
                                                        'Closed          ',
                                                        style: TextStyle(
                                                            color: CustomColor
                                                                .activeColor,
                                                            fontSize: 16)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.edit_outlined,
                                                            color:
                                                                Colors.black)),
                                                  ])),
                                        ]),
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
                          value: _isCheckedBusiness[0],
                          onChanged: (bool? value) {
                            setState(() {
                              _isCheckedBusiness[0] = value!;
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
                          value: _isCheckedBusiness[1],
                          onChanged: (bool? value) {
                            setState(() {
                              _isCheckedBusiness[1] = value!;
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
                          value: _isCheckedBusiness[2],
                          onChanged: (bool? value) {
                            setState(() {
                              _isCheckedBusiness[2] = value!;
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
                          value: _isCheckedBusiness[3],
                          onChanged: (bool? value) {
                            setState(() {
                              _isCheckedBusiness[3] = value!;
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
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                            child: SizedBox(
                                height: 35, //height of button
                                width: MediaQuery.of(context).size.width *
                                    0.5, //width of button
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0, //elevation of button
                                      shape: RoundedRectangleBorder(
                                          //to set border radius to button
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.all(
                                          5) //content padding inside button
                                      ),
                                  onPressed: () {},
                                  child: const Text(
                                    'UPLOAD MENU',
                                    style: TextStyle(
                                        color: CustomColor.buttonTextColor,
                                        fontSize: 14.0),
                                  ),
                                )))),
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
                              title: const Text(
                                'Amenities',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.keyboard_arrow_right,
                                    color: Colors.black54),
                                onPressed: () {},
                              ),
                              contentPadding: const EdgeInsets.only(left: 15),
                            ),
                          ]),
                        )
                      ]),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(
                            child: SizedBox(
                                height: 35, //height of button
                                width: MediaQuery.of(context).size.width *
                                    0.5, //width of button
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0, //elevation of button
                                      shape: RoundedRectangleBorder(
                                          //to set border radius to button
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              5) //content padding inside button
                                      ),
                                  onPressed: () {},
                                  child: const Text(
                                    'PROMOTE YOUR BUSINESS',
                                    style: TextStyle(
                                        color: CustomColor.buttonTextColor,
                                        fontSize: 14.0),
                                  ),
                                )))),
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
                        for (var element in _isCheckedBusiness) {
                          if (element) {
                            _checkConfirmBusiness = false;
                          }
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
                              onSuccess: () {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'The account already exists for that email.')),
                                );
                              },
                              onError: (String text) {
                                AppModel().userSignUp(
                                    name: _usernameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passController.text.trim(),
                                    onSuccess: () {
                                      // Go to Home
                                      NavigationRouter.switchToHome(context);
                                    },
                                    onError: (String text) {
                                      // Show error message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(text)),
                                      );
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
