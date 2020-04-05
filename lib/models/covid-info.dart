import 'package:flutter/material.dart';

class InformationTitleCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color iconColor;

  const InformationTitleCard(
      {Key key,
      @required this.title,
      @required this.subTitle,
      @required this.icon,
      @required this.iconColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          new BoxShadow(
              color: Colors.transparent,
              blurRadius: 4.0,
              spreadRadius: 3.5,
              offset: Offset(0.0, 2)),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: new Row(
                children: <Widget>[
                  Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top:15, right: 10),
                      child: Icon(
                      icon,
                      size: 50,
                      color: iconColor,
                    ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text(title,
                            style: new TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        //SizedBox(height: 10),
                        Text(subTitle,
                            style: new TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.normal,
                                fontSize: 13)),
                      ],
                    )
                  ]),
            )
                ],
              ),
            )
          ]),
    );
  }
}
