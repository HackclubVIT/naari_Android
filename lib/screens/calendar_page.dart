import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:naariAndroid/class/MLModel.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:naariAndroid/class/notifications.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

var _currentDate = new DateTime.now();
var Months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

class _CalendarPageState extends State<CalendarPage> {
  DateTime d1 = DateTime.now();
  SharedPreferences prefs;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool cycleOnset = false;
  double bmi;
  double cycleLen;
  int age;
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    prefs = await SharedPreferences.getInstance();
    bmi = prefs.getDouble("BMI") ?? 20.0;
    age = prefs.getInt("Age") ?? 25;
    cycleLen = prefs.getDouble("CycleLength") ?? 28.0;
    cycleOnset = prefs.getBool("periodBegun") ?? false;
    String ts = "", s1 = "";
    s1 = prefs.getString("d1") ?? "";
    // s2 = prefs.getString("d2") ?? "";

    if (s1 == "") {
      d1 = DateTime.now();
      // d2 = d1;
    }
    setState(() {
      d1 = DateTime.parse(s1);
      loading = false;
      // d2 = DateTime.parse(s2);
    });
    // calcDiff();
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select  Date',
      cancelText: 'Cancel',
      confirmText: 'Set',
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF008079),
            accentColor: const Color(0xFF008079),
            colorScheme: ColorScheme.light(primary: const Color(0xFF008079)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) return picked;
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          height: query.height,
          decoration: infoContainer,
          child: Center(
            child: Text("PERIOD TRACKER", style: headingStyle),
          ),
        ),
      ),
      body: ContainedTabBarView(
        tabs: [AutoSizeText('MAIN'), AutoSizeText('SETTING')],
        tabBarProperties: TabBarProperties(
            innerPadding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 8.0,
            ),
            indicator: ContainerTabIndicator(
              radius: BorderRadius.circular(16.0),
              color: Color(0xFFEFEFEF),
              borderWidth: 2.0,
              borderColor: Colors.transparent,
            ),
            labelColor: Color(0xFF1E7777),
            labelStyle: headingStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 15),
            unselectedLabelColor: Color(0xFF8CC4C4)),
        views: [
          Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Your Calendar",
                      style: headingStyle.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E7777),
                        letterSpacing: 1,
                      ),
                    ),
                  )),
              Expanded(
                flex: 21,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF006F6F), Color(0xFF00AAAA)]),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  margin: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0),
                  child: CalendarCarousel<Event>(
                    onCalendarChanged: (var x) {
                      this.setState(() {
                        this.setState(() => _currentDate = x);
                      });
                    },
                    // onDayPressed: (DateTime date, List<Event> events) {
                    //   this.setState(() => _currentDate = date);
                    // },
                    daysTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    weekDayFormat: WeekdayFormat.short,
                    weekdayTextStyle: TextStyle(color: Colors.white),
                    nextMonthDayBorderColor: Colors.white24,
                    nextDaysTextStyle: TextStyle(color: Colors.white60),
                    prevMonthDayBorderColor: Colors.white24,
                    prevDaysTextStyle: TextStyle(color: Colors.white60),
                    headerTextStyle: TextStyle(color: Colors.white),
                    headerText: Months[_currentDate.month - 1],
                    iconColor: Colors.white,
                    weekendTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    thisMonthDayBorderColor: Colors.grey,

                    customDayBuilder: (
                      /// you can provide your own build function to make custom day containers
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                    ) {
                      /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                      /// This way you can build custom containers for specific days only, leaving rest as default.

                      if (!loading) {
                        DateTime next = d1.add(Duration(days: cycleLen.round()));
                        if (day == next)
                          return Container(
                            constraints: BoxConstraints.expand(),
                            child: Center(
                                child: Text(
                              "${day.day}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                            decoration: BoxDecoration(color: Color.fromRGBO(40, 170, 170, 1), shape: BoxShape.circle, border: Border.all(color: Color.fromRGBO(0, 255, 255, 1))),
                          );
                      }

                      return null;
                    },
                    weekFormat: false,
                    // markedDateCustomShapeBorder: ,
                    todayButtonColor: Colors.tealAccent.withOpacity(0.3),
                    todayBorderColor: Colors.white,
                    // markedDatesMap: _markedDateMap,
                    height: 420.0,
                    // selectedDateTime: _currentDate,
                    daysHaveCircularBorder: true,

                    /// null for not rendering any border, true for circular border, false for rectangular border
                  ),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                  ))
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            color: Color(0xFFEFEFEF),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text("We will use this data to mark onset of your next cycle on Calendar", textAlign: TextAlign.center, style: kheroLogoText.copyWith(fontSize: 14, color: Color(0xFF535050))),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1, //,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BMI",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  bmi = double.parse(value.trim());
                                  prefs.setDouble("BMI", bmi);
                                  calculateAverageAndResetNotif();
                                },
                                initialValue: bmi.toString(),
                                cursorColor: Color(0xFF1F4F99),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  fillColor: Color(0xFFD2D2D2),
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Age",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  age = int.parse(value.trim());
                                  prefs.setInt("Age", age);
                                  calculateAverageAndResetNotif();
                                },
                                initialValue: age.toString(),
                                cursorColor: Color(0xFF1F4F99),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  fillColor: Color(0xFFD2D2D2),
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Text("Last but one period was on",
                //     style: kheroLogoText.copyWith(
                //         fontSize: 14, color: Color(0xFF535050))),
                // Text(" ${d1.day}-${d1.month}-${d1.year}",
                //     style: kheroLogoText.copyWith(
                //         fontSize: 23, color: Color(0xFF535050))),
                // SizedBox(height: 5),
                // ElevatedButton(
                //   style: ButtonStyle(
                //       backgroundColor:
                //           MaterialStateProperty.all<Color>(Color(0xFFEFEFEF)),
                //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //           RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(18.0),
                //         side: BorderSide(color: Colors.teal, width: 2),
                //       ))),
                //   onPressed: () async {
                //     DateTime rec = await selectDate(context);
                //     if (rec == null) return;
                //     setState(() {
                //       d1 = rec;
                //       calcDiff();
                //       prefs.setString(
                //           "d1", DateFormat("yyyy-MM-dd").format(d1));
                //     });
                //     if (prefs.getBool('periodReminder')) cycleBeginNotif();
                //   },
                //   child: Text(
                //     "Callibrate date",
                //     style: kheroLogoText.copyWith(
                //         fontSize: 15, color: Color(0xFF535050)),
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Last cycle onset: ", style: kheroLogoText.copyWith(fontSize: 14, color: Color(0xFF535050))),
                        Text("${d1.day}-${d1.month}-${d1.year}", style: kheroLogoText.copyWith(fontSize: 20, color: Color(0xFF535050))),
                      ],
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFEFEFEF)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.teal, width: 2),
                          ))),
                      onPressed: () async {
                        DateTime rec = await selectDate(context);
                        if (rec == null) return;
                        setState(() {
                          d1 = rec;
                          prefs.setString("d1", DateFormat("yyyy-MM-dd").format(d1));
                        });
                        if (prefs.getBool('periodReminder')) {
                          cancelNotif();
                          cycleBeginNotif();
                        }
                      },
                      child: Text(
                        "Callibrate date",
                        style: kheroLogoText.copyWith(fontSize: 15, color: Color(0xFF535050)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cycleOnset = !cycleOnset;
                      if (cycleOnset)
                        d1 = DateTime.now();
                    });
                    prefs.setBool("periodBegun", cycleOnset);
                    if (!cycleOnset) cancelNotif();
                    else prefs.setString("d1", DateFormat("yyyy-MM-dd").format(DateTime.now()));

                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E7777),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Text(
                      cycleOnset ? "My cycle has Ended" : "My cycle has Begun",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}
// return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendar Page'),
//         centerTitle: true,
//       ),
//       body: ContainedTabBarView(
//         tabs: [Text('M A I N'), Text('S E T T I N G S')],
//         tabBarProperties: TabBarProperties(
//             innerPadding: const EdgeInsets.symmetric(
//               horizontal: 32.0,
//               vertical: 8.0,
//             ),
//             indicator: ContainerTabIndicator(
//               radius: BorderRadius.circular(16.0),
//               color: Colors.blue,
//               borderWidth: 2.0,
//               borderColor: Colors.black,
//             ),
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.grey[400]),
//         views: [
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16.0),
//             child: CalendarCarousel<Event>(
//               onDayPressed: (DateTime date, List<Event> events) {
//                 this.setState(() => _currentDate = date);
//               },
//               weekendTextStyle: TextStyle(
//                 color: Colors.red,
//               ),
//               thisMonthDayBorderColor: Colors.grey,
// //      weekDays: null, /// for pass null when you do not want to render weekDays
// //      headerText: Container( /// Example for rendering custom header
// //        child: Text('Custom Header'),
// //      ),
//               customDayBuilder: (
//                 /// you can provide your own build function to make custom day containers
//                 bool isSelectable,
//                 int index,
//                 bool isSelectedDay,
//                 bool isToday,
//                 bool isPrevMonthDay,
//                 TextStyle textStyle,
//                 bool isNextMonthDay,
//                 bool isThisMonthDay,
//                 DateTime day,
//               ) {
//                 /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
//                 /// This way you can build custom containers for specific days only, leaving rest as default.

//                 // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
//                 if (day.day == _currentDate) {
//                   return Center(
//                     child: Icon(Icons.local_airport),
//                   );
//                 } else {
//                   return null;
//                 }
//               },
//               weekFormat: false,
//               // markedDatesMap: _markedDateMap,
//               height: 420.0,
//               // selectedDateTime: _currentDate,
//               daysHaveCircularBorder: true,

//               /// null for not rendering any border, true for circular border, false for rectangular border
//             ),
//           ),
//           Container(color: Colors.green),
//         ],
//         onChange: (index) => print(index),
//       ),
//     );
