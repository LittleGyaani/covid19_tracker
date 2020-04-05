//Core Library Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Essential Library Imports
import 'dart:convert' as convert;
import 'dart:async';
import 'package:http/http.dart' as http;

//Third Party Library Imports
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_icons/flutter_icons.dart';

//Main Library Imports
import 'package:covid_tracker/models/speciality-model.dart';
import 'package:covid_tracker/views/information.dart';
import 'package:covid_tracker/views/speciality.dart';
import 'package:covid_tracker/data/speciality-data.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  const TitleText(
      {Key key, this.text, this.fontSize = 18, this.color = Colors.black,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: new TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.w800, color: color),);
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  static int globalCount = 0;
  static int globalDeaths = 0;
  static int globalRecovered = 0;
  static String countryName = "";
  static int countryAffectCount = 0;
  static int countryDeaths = 0;
  static int countryRecovered = 0;
  static int countryTodayCase = 0;
  static int countryTodayDeaths = 0;
  static int countryActiveCases = 0;
  static int countryCriticalCases = 0;
  static int countryCasesPerMillion = 0;
  static int countryDeathsPerMillion = 0;
  double affectPercent = 0;
  final bool isLoading = false;
  String _timeString;

  List<SpecialityModel> specialities;

  Widget _operationsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _icon(AntDesign.arrowsalt, "Transfer"),
        _icon(AntDesign.pay_circle1, "Airtime"),
        _icon(AntDesign.pay_circle1, "Pay Bills"),
        _icon(AntDesign.qrcode, "Qr Pay"),
      ],
    );
  }

  Widget _safetyMeasures() {
    return Container(
      height: 250,
      child: ListView.builder(
          itemCount: specialities.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SpecialistTile(
              imgAssetPath: specialities[index].imgAssetPath,
              speciality: specialities[index].speciality,
              noOfDoctors: specialities[index].noOfDoctors,
              backColor: specialities[index].backgroundColor,
            );
          }),
    );
  }

  Widget _icon(IconData icon, String text) {
    return Column(
      children: <Widget>[Scrollable(viewportBuilder: null)],
    );
  }

  Widget sectionHeader(String headerTitle, {onViewMore}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 10),
          child: Text(headerTitle, style: new TextStyle()),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, top: 2),
          child: FlatButton(
            onPressed: onViewMore,
            child: Text('View all ›', style: new TextStyle()),
          ),
        )
      ],
    );
  }

  // wrap the horizontal listview inside a sizedBox..
  Widget headerTopCategories() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sectionHeader('Quick Help', onViewMore: () {}),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              headerCategoryItem(
                  'Buy Insurance', MaterialCommunityIcons.umbrella,
                  onPressed: () {}),
              headerCategoryItem(
                  'Report Case', MaterialCommunityIcons.note_plus,
                  onPressed: () {}),
              headerCategoryItem(
                  'Call Help Line', MaterialCommunityIcons.phone_classic,
                  onPressed: () {}),
              headerCategoryItem(
                  'COVID Centers', MaterialCommunityIcons.hospital,
                  onPressed: () {}),
              headerCategoryItem(
                  'Emergency Alert', MaterialCommunityIcons.alert,
                  onPressed: () {}),
            ],
          ),
        )
      ],
    );
  }

  Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 86,
              height: 86,
              child: FloatingActionButton(
                shape: CircleBorder(),
                heroTag: name,
                onPressed: onPressed,
                backgroundColor: Colors.white,
                child: Icon(icon, size: 35, color: Colors.red),
              )),
          Text(
            name + ' ›',
            style: new TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.00,
            ),
          ),
        ],
      ),
    );
  }

  final String globalAPIURI = 'https://coronavirus-19-api.herokuapp.com/all';
  final String countryAPIURI =
      'https://coronavirus-19-api.herokuapp.com/countries/';

  final int totalPopulation = 7800000000; //Global Population - 7.8 Billions

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }

  Future<void> _getGlobalCoronaStatus() async {

    var response = await http.get(globalAPIURI);
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      globalCount = jsonResponse['cases'];
      globalDeaths = jsonResponse['deaths'];
      globalRecovered = jsonResponse['recovered'];
      affectPercent = (globalCount / totalPopulation);
    });
  }

  Future<void> _getCountryWiseCoronaStatus(countryName) async {

    var response = await http.get(countryAPIURI + countryName);
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      countryName = jsonResponse['country'];
      countryAffectCount = jsonResponse['cases'];
      countryDeaths = jsonResponse['deaths'];
      countryRecovered = jsonResponse['recovered'];
      countryTodayCase = jsonResponse['todayCases'];
      countryTodayDeaths = jsonResponse['todayDeaths'];
      countryActiveCases = jsonResponse['active'];
      countryCriticalCases = jsonResponse['critical'];
      countryCasesPerMillion = jsonResponse['casesPerOneMillion'];
      countryDeathsPerMillion = jsonResponse['deathsPerOneMillion'];
    });
  }

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getGlobalCoronaStatus());
    specialities = getSpeciality();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0,
        titleSpacing: 30,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 10),
              child: new ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/SARS-CoV-2_without_background.png/220px-SARS-CoV-2_without_background.png',
                ),
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'CORONA Tracker',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _timeString,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          new MaterialButton(
            minWidth: 10,
            onPressed: () {
              // _getCountryWiseCoronaStatus(countryName);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new InformationScreen()));
            },
            child: new Icon(
              AntDesign.search1,
              size: 20,
            ),
          ),
          new MaterialButton(
            minWidth: 10,
            onPressed: () {
              _getGlobalCoronaStatus();
            },
            child: new Icon(
              AntDesign.sync,
              size: 20,
            ),
          ),
        ],
      ),
      body: new SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 30, 25, 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SizedBox(
                    height: 10.00,
                  ),
                  new Container(
                    width: 70,
                    height: 70,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).primaryColor.withAlpha(50),
                    ),
                    child: new Image(
                      image: NetworkImage(
                          'https://www.mohfw.gov.in/assets/images/icon-infected.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.tealAccent,
                    child: Text(
                      '$globalCount',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 80,
                        fontFamily: 'Bebas',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '$globalCount Affected'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '7.8 Billion'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        LinearPercentIndicator(
                          lineHeight: 8.0,
                          percent: affectPercent,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor:
                              Theme.of(context).accentColor.withAlpha(30),
                          progressColor: Theme.of(context).primaryColor,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        Text(
                          'For Emergency'.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontFamily: 'Bebas',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Dial COVID Help Line : 1075',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height:10),
                  //_operationsWidget(),
                  SizedBox(
                    height: 10,
                  ),
                  headerTopCategories(),
                  Divider(
                    height: 25,
                    color: Colors.grey[300],
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'DEATHS',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$globalDeaths',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' +',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'RECOVERED',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$globalRecovered',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' +',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'AFFECTED',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$globalCount',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' +',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 25,
                    color: Colors.grey[300],
                  ),
                  _safetyMeasures(),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'SAFETY MEASURES',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 24,
                              fontFamily: 'Bebas',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '5 Steps to keep Corona Away',
                            style: new TextStyle(
                              fontSize: 9.00,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '#StayHomeStaySafe',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  new Container(
                    height: 250,
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: new ListView(
                      physics: new ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        new StatCard(
                          title: 'STAY HOME',
                          achieved: 200,
                          total: 350,
                          color: Colors.orangeAccent,
                          image: Image.network(
                            'https://img.icons8.com/color/2x/cottage.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        new StatCard(
                          title: 'KEEP DISTANCE',
                          achieved: 350,
                          total: 300,
                          color: Colors.purpleAccent,
                          image: Image.network(
                            'https://img.icons8.com/dusk/344/point-objects.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        new StatCard(
                          title: 'WASH HANDS',
                          achieved: 100,
                          total: 200,
                          color: Colors.white,
                          image: Image.network(
                            'https://img.icons8.com/color/2x/wash-your-hands.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        new StatCard(
                          title: 'COVER COUGH',
                          achieved: 100,
                          total: 200,
                          color: Colors.greenAccent,
                          image: Image.network(
                            'https://img.icons8.com/officel/344/microorganisms.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        new StatCard(
                          title: 'SICK FEELING',
                          achieved: 100,
                          total: 200,
                          color: Colors.pinkAccent,
                          image: Image.network(
                            'https://img.icons8.com/officel/344/sneeze.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Text(
                    'Made with ❤️ by Little Gyaani | App version : 1.0.0',
                    style: new TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new SizedBox(height: 25),
                  new Text('Report any issues'),
                  MaterialButton(
                    color: Colors.red,
                    onPressed: null,
                    child: Text('bmohanty@live.com | +91 9853233951'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final double total;
  final double achieved;
  final Image image;
  final Color color;

  const StatCard({
    Key key,
    @required this.title,
    @required this.total,
    @required this.achieved,
    @required this.image,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.fitHeight,
          image: new NetworkImage(
              'https://ak5.picdn.net/shutterstock/videos/1045470025/thumb/1.jpg'),
        ),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 25),
          ),
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 8.0,
            percent: 1.0,
            circularStrokeCap: CircularStrokeCap.round,
            center: image,
            progressColor: color,
            backgroundColor: Theme.of(context).accentColor.withAlpha(30),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25),
          ),
          // RichText(
          //   text: TextSpan(children: [
          //     TextSpan(
          //       text: achieved.toString(),
          //       style: TextStyle(
          //         fontSize: 20,
          //         color: Theme.of(context).accentColor,
          //       ),
          //     ),
          //     TextSpan(
          //       text: ' / $total',
          //       style: TextStyle(
          //         color: Colors.grey,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 12,
          //       ),
          //     ),
          //   ]),
          // )
        ],
      ),
    );
  }
}
