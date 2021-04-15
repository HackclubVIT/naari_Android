import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:naariAndroid/screens/sign_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class setting_Screen extends StatefulWidget {
  @override
  _setting_ScreenState createState() => _setting_ScreenState();
}

class _setting_ScreenState extends State<setting_Screen> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("INSIDE GENERAL");
    print(user);

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
              "GENERAL",
              style: kheroLogoText.copyWith(color: Color(0xFF535050)),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            settingsButton(
              title: "Profile Settings",
            ),
            settingsButton(
              title: "Notification Settings",
              widgetList: [
                Text("Turn off Pad Reminder"),
                Text("Turn off Period Reminder"),
                Text("Frequency of Period Reminder"),
              ],
            ),
            settingsButton(
              title: "Security",
            ),
            settingsButton(
              title: "Privacy",
            ),
            settingsButton(
              title: "About",
            ),
            settingsButton(
              title: "FAQs",
            ),
            settingsButton(
              title: "Contact Us",
            ),
            settingsButton(
              title: "Logout",
              special: true,
              on: () async{
                await _auth.signOut();
                GoogleSignIn(scopes: ['email']).signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                print(user);
                Navigator.pushNamed(context, sign_Screen.id);
              },
            )
          ],
        )),
      ),
    );
  }
}
