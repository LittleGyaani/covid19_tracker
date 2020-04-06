//Core Library Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Main Library Imports
import 'package:covid_tracker/views/welcome.dart';

void main() => runApp(new Covid19TrackerApp());

class Covid19TrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      )  
    );
    
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID19 Tracker App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: new Color(0XFF6D3FFF),
        accentColor: new Color(0XFF233C63),
        fontFamily: 'Poppins',
      ),
      home: new Welcome(),
    );
  }
}
