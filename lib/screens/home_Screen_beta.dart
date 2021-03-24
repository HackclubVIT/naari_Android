import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:naariAndroid/screens/calendar_page.dart';
import 'package:naariAndroid/screens/music_player.dart';
import 'package:naariAndroid/screens/settings.dart';
import 'experiment.dart';
import 'padcounter.dart';

class navBar extends StatefulWidget {
  static String id="home_View";
  final int pageid;
  const navBar({Key key, this.pageid}) : super(key: key);
  @override
  _navBarState createState() => _navBarState();
}

class _navBarState extends State<navBar> {

  final List<Widget> _children=[

    CalendarPage(),
    counter_Screen(),
    SliverHome(),
    MusicPlayer(),
    setting_Screen()
  ];


  int _selectedItemPosition=2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.pageid != null)
    {
      setState(() {
        _selectedItemPosition = widget.pageid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  if(FirebaseAuth.instance.currentUser != null || GoogleSignIn(scopes: ['email']).currentUser !=null ){
    print("Inside navabar");
    print(FirebaseAuth.instance.currentUser);
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          body: _children[_selectedItemPosition],

        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: snakebar(  (index){
            setState(() => _selectedItemPosition = index);print(_selectedItemPosition);
            print(index);

          }, _selectedItemPosition),
        )

      ],
    );
  }
  else{
    return Container(
      child: Text("CONTAINER"),
    );
  }

  }
}

