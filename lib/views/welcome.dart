import 'package:flutter/material.dart';

import 'dashboard.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: new Stack(
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(25, 20, 25, 25),
              child: new Center(
                child: new Column(
                  children: <Widget>[
                    new Image.asset(
                      'assets/img/covidapp_header.png',
                      width: 300,
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),
                    new Text(
                      'COVID-19 TRACKER',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Text(
                      'CORONA VIRUS STATISTICS'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Bebas',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    new Text(
                      'Coronavirus disease (COVID-19) is an infectious disease caused by a new virus. The disease causes respiratory illness (like the flu) with symptoms such as a cough, fever, and in more severe cases, difficulty breathing. You can protect yourself by washing your hands frequently, avoiding touching your face, and avoiding close contact (1 meter or 3 feet) with people who are unwell.',
                      style: new TextStyle(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 30),
                    ),
                    new MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new Dashboard(),
                          ),
                        );
                      },
                      minWidth: double.infinity,
                      height: 50,
                      child: new Text(
                        'Go to Dashboard'.toUpperCase(),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                    ),
                    new SizedBox(height: 25),
                    new Image.asset(
                      'assets/img/kslabs_logo.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
