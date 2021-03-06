import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarty/models/routineModel.dart';
import 'package:smarty/screens/routines_pages/current_routine_page.dart';

class CurrentRoutines extends StatefulWidget {
  @override
  _CurrentRoutinesState createState() => _CurrentRoutinesState();
}

class _CurrentRoutinesState extends State<CurrentRoutines> {
  @override
  Widget build(BuildContext context) {
    final routines = Provider.of<List<Routine>>(context);
    if (routines != null) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 30.0, right: 20.0, bottom: 20.0, top: 20),
                child: Text(
                  'Routines allow you to operate or set schedules for multiple devices in your house.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: routines.length,
                  itemBuilder: (BuildContext context, int index) {
                    Routine routine = routines[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CurrentRoutinePage(
                                routine: routines[index],
                              ),
                            ));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: routines[index].routineColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      routine.icon,
                                    ],
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                routine.routineName,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 1.0),
                                            child: Row(
                                              children: <Widget>[
                                                Opacity(
                                                  opacity: 0.8,
                                                  child: Text(
                                                    routine.routineDesc,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 30.0, right: 20.0, bottom: 20.0, top: 20),
                  child: Text(
                    'Routines allow you to operate or set schedules for multiple devices in your house.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ]),
        ),
      );
    }
  }
}
