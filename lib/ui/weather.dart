import 'package:flutter/material.dart';
import 'dart:async';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _cityEnter;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator
        .of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
          return new weatherChange();
    }));
    if (results != null && results.containsKey('info')) {
      _cityEnter = results['info'];
    }
  }

//  void _showStuff() async{
//    Map _data = await getWeather(util.appId, util.defaultCity);
//    debugPrint(_data['main']['temp'].toString());
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //AppBar
      appBar: new AppBar(
        title: new Text(
          "WeatherForecast",
          style: new TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black54,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.location_searching),
              onPressed: () {
                _goToNextScreen(context);
              })
        ],
      ),

      body: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //Image
          new Center(
            child: new Image.asset(
              './images/weather1.png',
              width: 500.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          //City Text
          new Container(
            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            alignment: Alignment.topCenter,
            child: new Text(
                '${_cityEnter == null ? util.defaultCity : _cityEnter}',
                style: cityText()),
          ),

          //Cloud Images
          new Container(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: new Image.asset("./images/light_rain.png"),
          ),

          //Weather Data Field
          updateTempWidget(_cityEnter)
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiURL =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util
        .appId}&units=metric";
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;

            return new Container(
              padding: EdgeInsets.fromLTRB(160.0, 220.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString()+" ºC",
                      style: tempTextStyle(),
                    ),
                  ),

                  new ListTile(
                    title: new Text(
                          "Min: ${content['main']['temp_min'].toString()} ºC\n"
                          "Max: ${content['main']['temp_max'].toString()} ºC",
                      style: extraStyle() ,
                    ),
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }
}

class weatherChange extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //AppBar
      appBar: new AppBar(
        title: new Text("Change City"),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),

      //Body
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: Icon(Icons.location_city),
                      labelText: "Change City",
                      hintText: "Enter the City Name"),
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {'info': _cityFieldController.text});
                    },
                    child: new Text("Get Weather")),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityText() {
  return new TextStyle(
      fontSize: 28.0, fontWeight: FontWeight.w600, color: Colors.white);
}

TextStyle tempTextStyle() {
  return new TextStyle(
      fontSize: 28.0, fontWeight: FontWeight.w600, color: Colors.white);
}

TextStyle extraStyle(){
  return new TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white);
}