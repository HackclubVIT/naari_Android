import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naariAndroid/constants/Database.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';



class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color(0xFFEFEFEF),
        body: Center(
          heightFactor: 4,
          child: _getTasks()
        ));
  }

  Widget _getTasks() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("Email", isEqualTo: "${user.email}").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var cont= snapshot.data.docs[0]["counter"];
            return Container(
                child: Text(
                  "AVAILABLE\n$cont",
                  textAlign: TextAlign.center,
                  style: kheroLogoText.copyWith( fontSize: 45,color: Color(0xFF535050)),)
            );
          } else {
            return Container();
          }
        });
  }
}