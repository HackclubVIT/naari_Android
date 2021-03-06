import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:naariAndroid/screens/sign_Screen.dart';

class welcome_Screen extends StatelessWidget {
  static String id = "welcome_screen";
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(context, sign_Screen.id, (r) => false);
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(),
                Container(
                  child: Container(
                    alignment: Alignment.center,
                    child: Image(
                        image: AssetImage("assets/images/mascot.png"),
                        height: MediaQuery.of(context).size.height - 200,
                        alignment: Alignment.center),
                    decoration: new BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFB1D8D8), Color(0xFF79B7B7)]),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 330.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitChasingDots(
                    color: Color(0xFF004C4C),
                    size: 30.0,
                  ),
                  Text(
                    "Paavya",
                    style: kheroLogoText.copyWith(
                        fontFamily: "Samarkan",
                        fontSize: 48,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  logoRichText()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
