import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Example',
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  var lati;
  var long;

  Position positions = null;
  StreamSubscription<Position> streamSubscription;
  bool trackLocation = false;

  @override
  initState() {
    super.initState();
    checkGps();

    trackLocation = false;
    positions = null;
  }

  getLocations() {
    if (trackLocation) {
      setState(() => trackLocation = false);
      streamSubscription.cancel();
      streamSubscription = null;
      positions = null;
    } else {
      setState(() => trackLocation = true);

      streamSubscription = Geolocator.getPositionStream().listen((result) {
        final location = result;
        setState(() {
          positions = location;
          lati = location.latitude;
          long = location.longitude;
        });
      });

      streamSubscription.onDone(() => setState(() {
            trackLocation = false;
          }));
    }
  }

  checkGps() async {
    final result = await Geolocator.isLocationServiceEnabled();
    if (result == true) {
      print("Success");
    } else {
      print("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('I am here'),
        actions: <Widget>[
          FlatButton(
            child: Text("Get Location"),
            onPressed: getLocations,
          )
        ],
      ),
      body: Center(
          child: Container(
        child: ListView(
          children: [
            Text(
              "${lati} , ${long}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      )),
    );
  }
}
