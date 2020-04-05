import 'package:flutter/material.dart';

import 'package:covid_tracker/models/covid-info.dart';
import 'package:flutter_icons/flutter_icons.dart';

class InformationScreen extends StatefulWidget {
  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text('COVID Tracker - Information'),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: <Widget>[
            InformationTitleCard(
              icon: AntDesign.sharealt,
              iconColor: Colors.blue,
              subTitle: 'Learn how Covid-19 spread?',
              title: 'How it Spreads?',
            ),
            SizedBox(height: 3),
            InformationTitleCard(
              icon: AntDesign.warning,
              iconColor: Colors.cyan,
              subTitle: 'Learn Covid-19 symptoms!',
              title: 'What are the Symptoms?',
            ),
            SizedBox(height: 3),
            InformationTitleCard(
              icon: AntDesign.heart,
              iconColor: Colors.red,
              subTitle: 'Learn Covid-19 treatments!',
              title: 'Prevention & treatment?',
            ),
            SizedBox(height: 3),
            InformationTitleCard(
              icon: AntDesign.questioncircle,
              iconColor: Colors.green,
              subTitle: 'What to do if you get the virus?',
              title: 'What to do?',
            ),
            SizedBox(height: 5),
            new Text('Brought to you by'),
            Image.asset(
              'assets/img/kslabs_logo.png',
              height: 150,
              width: 150,
            ),
            // Container(
            //   height: 200,
            //   width: 200,
            //   margin: EdgeInsets.all(8.0),
            //   child: Card(
            //     color: Colors.red,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //     child: InkWell(
            //       onTap: () => print("ciao"),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: <Widget>[
            //           ClipRRect(
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(8.0),
            //               topRight: Radius.circular(8.0),
            //             ),
            //             child: Image.network('https://placeimg.com/640/480/any',
            //                 width: 300, height: 100, fit: BoxFit.fill),
            //           ),
            //           Container(
            //             color: Colors.red,
            //             child: ListTile(
            //               title: Text('Pub 1'),
            //               subtitle: Text('Location 1'),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
