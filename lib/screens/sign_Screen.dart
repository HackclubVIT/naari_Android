import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:naariAndroid/screens/home_Screen.dart';
import 'package:naariAndroid/screens/home_Screen_beta.dart';
import 'package:naariAndroid/screens/registration_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sign_Screen extends StatefulWidget {
  static String id = "sign_Screen";
  @override
  _sign_ScreenState createState() => _sign_ScreenState();
}

class _sign_ScreenState extends State<sign_Screen> {
  String email;
  String password;
  String number;
  bool isInvalidLogin = false;
  bool spinner = false;
  bool state = true;
  bool absorb = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("User after logout");
    print(user);
  }

  bool _isLoggedIn = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitChasingDots(
        color: Color(0xFF004C4C),
        size: 30.0,
      ),
      inAsyncCall: spinner,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Form(
              key: _formKey,
              child: Stack(
                children: [
                  //if things go wrong remove stack and add expanded and change singlechilscroll to col
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Paavya",
                                  style: kheroLogoText.copyWith(
                                      fontFamily: "Samarkan",
                                      fontSize: 52,
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
                                //           fontSize: 70, color: Colors.black),
                                //       textAlign: TextAlign.center,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04),
                                Padding(
                                  padding: signPadding,
                                  child: Visibility(
                                    child: Center(
                                      child: Text(
                                        "Invalid email/password",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    visible: isInvalidLogin,
                                  ),
                                ),
                                Padding(
                                  padding: signPadding,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    cursorColor: curscol,
                                    textAlign: TextAlign.center,
                                    decoration: kTextStyle,
                                    validator: emailChecker,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
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
                                        validator: passwordValidator,
                                      ),
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
                                  height: 5,
                                ),
                                buttonWidget(
                                  title: "Login",
                                  onpressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        spinner = true;
                                      });
                                      try {
                                        var user = await auth
                                            .signInWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString('email', '$email');
                                        if (user != null) {
                                          Navigator.pushNamed(
                                              context, navBar.id);
                                        }
                                      } on Exception {
                                        setState(() {
                                          spinner = false;
                                          isInvalidLogin = true;
                                        });
                                      }
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                signUpRichText(
                                  title: "Sign Up!",
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, registration_Screen.id);
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "OR",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SignInButton(
                                  Buttons.Google,
                                  text: "Sign up with Google",
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 5,
                                  onPressed: () async {
                                    setState(() {
                                      spinner = true;
                                    });
                                    final GoogleSignInAccount
                                        googleSignInAccount =
                                        await _googleSignIn.signIn();
                                    final GoogleSignInAuthentication
                                        googleSignInAuthentication =
                                        await googleSignInAccount
                                            .authentication;

                                    final AuthCredential credential =
                                        GoogleAuthProvider.credential(
                                      accessToken: googleSignInAuthentication
                                          .accessToken,
                                      idToken:
                                          googleSignInAuthentication.idToken,
                                    );

                                    print(_googleSignIn.currentUser);
                                    print(credential);
                                    var user = _googleSignIn.currentUser;

                                    final UserCredential authResult =
                                        await FirebaseAuth.instance
                                            .signInWithCredential(credential);
                                    final User users = authResult.user;
                                    print("Users:");
                                    print(users);
                                    print("FIREBASEUsers:");
                                    print(FirebaseAuth.instance.currentUser);
                                    _getTasks(users.email, users.phoneNumber,
                                        users.displayName);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('email', '${users.email}');
                                    if (users != null)
                                      Navigator.pushNamed(context, navBar.id);
                                    else
                                      setState(() {
                                        spinner = false;
                                      });
                                  },
                                )
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: logoRichText(),
                      ))
                ],
              )),
        ),
      ),
    );
  }

  _getTasks(String email, String phone, String name) async {
    print("INSIDE FUNCTION PLEASE");
    print(email);
    FirebaseFirestore.instance
        .collection('Users')
        .where("Email", isEqualTo: "$email")
        .get()
        .then((value) {
      print("Inside value");
      if (value.docs.isEmpty) {
        print("User doesnt exist");

        FirebaseFirestore.instance.collection('Users').add({
          'Full Name': "$name",
          "Username": "$name",
          "Mobile no.": "$phone",
          "Email": "$email",
          "counter": 0,
          "lastLogin": DateTime.now().toString(),
          "perday": 0
        });
      } else
        print("user does exits");
    });
    StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where("Email", isEqualTo: "$email")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            print("INSIDE SNAPSHOT HAS DATA");

            return null;
          } else {
            print("INSIDE SNAPSHOT HAS NO DATA");
            FirebaseFirestore.instance.collection('Users').add({
              'Full Name': "$name",
              "Username": "$name",
              "Mobile no.": "$phone",
              "Email": "$email",
              "counter": 0,
              "lastLogin": DateTime.now().toString(),
              "perday": 0
            });
            return null;
          }
        });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('periodBegun', false);
  }
}
