import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarty/devices_controller.dart';
import 'package:smarty/models/devicesModel.dart';
import 'package:smarty/models/roomModel.dart';
import 'package:smarty/models/user.dart';
import 'package:smarty/shared/constants.dart';
import 'package:smarty/widgets/voiceAgent.dart';

class MyOtherRoom extends StatefulWidget {
  @override
  int initRoom;
  List<Room> rooms;
  List<Device> devices;

  MyOtherRoom(
      {@required this.initRoom, @required this.rooms, @required this.devices});

  _MyOtherRoomState createState() => _MyOtherRoomState();
}

class _MyOtherRoomState extends State<MyOtherRoom> {
  @override
  List<Room> rooms;
  List<Tab> rlist = [];
  bool isSwitched = true;
  int brightness = 60;
  List<Device> devices;
  DatabaseReference itemRef;

  Color bulbColor = Colors.white;
  String currRoom;
  String currDevice;
  String initrmName;
  String rmName;
  bool isAbsorbed = false;
  List<String> x;

  void initState() {
    // if (Provider.of<BoltProvider>(context, listen: false).getBalanceAsInt() == 10)
    //   Timer.run(
    //       () => Provider.of<DialogProvider>(context, listen: false).popAi());

    rooms = widget.rooms;
    devices = widget.devices;
    for (var r in rooms) {
      rlist.add(
        Tab(text: r.roomName, icon: r.icon),
      );
    }
    initrmName = rlist[widget.initRoom].text;
    rmName = rlist[widget.initRoom].text;
    currRoom = rlist[widget.initRoom].text;
    currDevice = rooms[widget.initRoom].d[0];
    initrmName = rlist[widget.initRoom].text;
    rmName = rlist[widget.initRoom].text;
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference();
  }

  incrementCount(User user, String room, String device) {
    Firestore.instance
        .collection('Homes')
        .document(user.houseId)
        .collection(user.uid)
        .document(room)
        .updateData({device: FieldValue.increment(1)}).catchError((e) {
      print(e);
    });
  }

  Device getDevState(String roomName, String devName) {
    //bool isSwitched = true;
    for (var i in devices)
      if ((i.inRoom == roomName) && (i.deviceName == devName)) return i;
  }

  void stateChange(
      bool newvalue, String room, String device, String houseId, User user) {
    if (newvalue == false) {
      itemRef
          .child("Homes/" +
              houseId +
              "/Rooms/" +
              room +
              "/devices/" +
              device +
              "/")
          .update({'State': "off"});
    } else {
      incrementCount(user, room, device);
      itemRef
          .child("Homes/" +
              houseId +
              "/Rooms/" +
              room +
              "/devices/" +
              device +
              "/")
          .update({'State': "on"});
    }
  }

  Icon getIcons(String devIc) {
    for (var j in devices) {
      if (j.deviceName == devIc) {
        return j.icon;
      }
    }
  }

  Stream getString(String room, String device, String houseId) {
    Stream x;
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    x = database
        .reference()
        .child("Homes/" + houseId + "/Rooms/" + room + "/" + device + "/")
        .onValue;
    return x;
  }

  bool convert(String x) {
    bool w;
    if (x == "on") {
      w = true;
    } else {
      w = false;
    }
    return w;
  }

  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    final user = Provider.of<User>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     (rmName != rlist[widget.initRoom].text) ? rmName : initrmName,
      //     style: kAppBarTextStyle,
      //   ),
      // ),
//      drawer: Drawer(),
      body: DefaultTabController(
        initialIndex: widget.initRoom,
        length: rooms.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: false,
                title: Text(
                  (rmName != rlist[widget.initRoom].text)
                      ? rmName
                      : initrmName,
                  style: kAppBarTextStyle,
                ),
                actions: <Widget>[MicClass()],
                bottom: TabBar(
                  isScrollable: true,
                  labelColor: Theme.of(context).accentColor,
                  unselectedLabelColor: Theme.of(context).disabledColor,
//                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: rlist,
                  onTap: (value) {
                    setState(() {
                      rmName = rlist[value].text;
                      currRoom = rlist[value].text;
                      currDevice = rooms[value].d[0];
                    });
                  },
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenheight * 0.02),
                  AbsorbPointer(
                      absorbing: isAbsorbed,
                      child: (isAbsorbed == true)
                          ? controllerContainer(screenheight, screenwidth, 0.2)
                          : controllerContainer(screenheight, screenwidth, 1)),
                  // SizedBox(height: screenheight * 0.001),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Devices',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                          // textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Container(
                    height: screenheight * 0.35,
                    width: screenwidth,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (var i in rooms)
                          getListTile(rooms.indexOf(i), user),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Opacity controllerContainer(
      double screenheight, double screenwidth, double opc) {
    return Opacity(
      opacity: opc,
      child: Container(
        height: screenheight * 0.4,
        width: screenwidth,
        margin: EdgeInsets.only(left: 10, right: 10),
        // color: Colors.red,
        child: DevicesController(
          chDevice: currDevice,
          chRoom: (rmName != rlist[widget.initRoom].text) ? rmName : initrmName,
          // isDisabled: isAbsorbed,
          // toggleState: getDevState(rooms[rmName].roomName, rooms[l].d[i]).toggleSt,
        ),
      ),
    );
  }

  ListView getListTile(int l, User user) {
    return ListView.builder(
        itemCount: rooms[l].d.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(1.0, 4.0),
                            blurRadius: 4.0)
                      ]
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        currRoom = rooms[l].roomName;
                        currDevice = rooms[l].d[i];
                      });
                    },
                    leading: getIcons(rooms[l].d[i]),
                    title: Text(rooms[l].d[i], style: TextStyle(fontWeight: FontWeight.w600),),
                    trailing: StreamBuilder(
                      stream: itemRef
                          .child("Homes/" +
                              user.houseId +
                              "/Rooms/" +
                              rooms[l].roomName +
                              "/devices/" +
                              rooms[l].d[i] +
                              "/")
                          .onValue,
                      builder: (context, snap) {
                        Map<String, dynamic> values =
                            new Map<String, dynamic>.from(
                                snap.data.snapshot.value);
                        return Switch(
                          value: convert(values["State"]),
                          onChanged: (value) {
                            stateChange(value, rooms[l].roomName, rooms[l].d[i],
                                user.houseId, user);
                            setState(() {
                              getDevState(rooms[l].roomName, rooms[l].d[i])
                                  .toggleSt = value;
                            });
                          },
                          activeTrackColor: Theme.of(context).accentColor,
                          activeColor: Colors.white,
                          inactiveTrackColor: Theme.of(context).backgroundColor,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
