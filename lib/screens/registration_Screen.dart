import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:naariAndroid/screens/home_Screen.dart';
import 'package:naariAndroid/screens/home_Screen_beta.dart';
import 'package:naariAndroid/screens/sign_Screen.dart';
import 'package:naariAndroid/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class registration_Screen extends StatefulWidget {
  static String id = "registration_Screen";
  @override
  _registration_ScreenState createState() => _registration_ScreenState();
}

class _registration_ScreenState extends State<registration_Screen> {
  String fullName;
  String userName;
  String email;
  String password;
  String number;
  bool spinner = false;
  bool state = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitChasingDots(
        color: Color(0xFF004C4C),
        size: 30.0,
      ),
      inAsyncCall: spinner,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Paavya",
                            style: kheroLogoText.copyWith(
                                fontFamily: "Samarkan",
                                fontSize: 48,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          // Hero(
                          //   tag: "Logo",
                          //   child: Material(
                          //     color: Colors.transparent,
                          //     child: Text(
                          //       "Naari",
                          //       style: kheroLogoText.copyWith(
                          //           fontSize: 60, color: Colors.black),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),

                          Padding(
                            padding: signPadding,
                            child: TextFormField(
                              onChanged: (value) {
                                fullName = value;
                              },
                              cursorColor: curscol,
                              textAlign: TextAlign.center,
                              decoration: kTextStyle.copyWith(
                                  hintText: "Full "
                                      "Name"),
                              validator: fnameValidator,
                            ),
                          ),
                          sizedbox,
                          Padding(
                            padding: signPadding,
                            child: TextFormField(
                              onChanged: (value) {
                                userName = value;
                              },
                              cursorColor: curscol,
                              textAlign: TextAlign.center,
                              decoration: kTextStyle.copyWith(
                                  hintText: "Usernam"
                                      "e"),
                              validator: usernameValidator,
                            ),
                          ),
                          sizedbox,
                          Padding(
                            padding: signPadding,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  number = value;
                                },
                                cursorColor: curscol,
                                textAlign: TextAlign.center,
                                decoration: kTextStyle.copyWith(
                                    hintText: "Mobile "
                                        "No."),
                                validator: numberValidator),
                          ),
                          sizedbox,
                          Padding(
                            padding: signPadding,
                            child: TextFormField(
                                onChanged: (value) {
                                  email = value;
                                },
                                cursorColor: curscol,
                                textAlign: TextAlign.center,
                                decoration:
                                    kTextStyle.copyWith(hintText: "Email"),
                                validator: emailChecker),
                          ),
                          sizedbox,
                          Padding(
                            padding: signPadding,
                            child: Stack(
                              children: [
                                TextFormField(
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    obscureText: state,
                                    cursorColor: curscol,
                                    textAlign: TextAlign.center,
                                    decoration: kTextStyle.copyWith(
                                        hintText: "Password"),
                                    validator: passwordValidator),
                                Positioned(
                                  top: 10,
                                  right: 20,
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (state == false) {
                                            setState(() {
                                              state = true;
                                            });
                                          } else if (state == true) {
                                            setState(() {
                                              state = false;
                                            });
                                          }
                                        });
                                      },
                                      child: Icon(Icons.remove_red_eye)),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buttonWidget(
                            title: "Register",
                            onpressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  spinner = true;
                                });
                                var newuser =
                                    await auth.createUserWithEmailAndPassword(
                                        email: email, password: password);
//                                UserUpdateInfo updateInfo = UserUpdateInfo();
//                                updateInfo.displayName = _usernameController.text;
//                                user.updateProfile(updateInfo);
                                await auth.currentUser
                                    .updateProfile(displayName: fullName);
                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .add({
                                  'Full Name': "$fullName",
                                  "Username": "$userName",
                                  "Mobile no.": number,
                                  "Email": email,
                                  "counter": 0,
                                  "lastLogin": DateTime.now().toString(),
                                  "perday": 0
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('email', '$email');
                                prefs.setBool('periodBegun', false);
                                if (newuser != null) {
                                  Navigator.pushNamed(context, navBar.id);
                                }
                                setState(() {
                                  spinner = false;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          signUpRichText(
                              title: "Log In!",
                              text: "Already Have An Account? ",
                              onTap: () {
                                Navigator.popUntil(context,
                                    ModalRoute.withName(sign_Screen.id));
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: logoRichText(),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
