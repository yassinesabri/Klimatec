import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'utils/utils.dart' as Utils;
import 'package:http/http.dart' as http;

class Klimatec extends StatefulWidget {
  @override
  _KlimatecState createState() => new _KlimatecState();
}

class _KlimatecState extends State<Klimatec> {
  String _city;

  @override
  void initState() {
    super.initState();
    debugPrint('test');
  }

  Future<Map> getWeatherInfo(String city) async {
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${Utils
        .appId}&units=metric";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  Future _gotoChangeCity(BuildContext context) async {
    Map result = await Navigator
        .of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCityScreen();
    }));

    if (result != null && result.containsKey('city')) {
      // check if no city is chosen
      if (result['city'] == "") {
        _city = null;
      } else {
        _city = result['city'];
      }
    }
  }

  Widget updateTempInfo(String city) {
    return new FutureBuilder(
        future: getWeatherInfo(city == null ? Utils.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text('${content['main']['temp'].toString()} °C',
                        style: tempStyle()),
                    subtitle: new Text(
                      'Humidity: ${content['main']['humidity'].toString()} \n'
                          'Min: ${content['main']['temp_min'].toString()} °C\n'
                          'Max: ${content['main']['temp_max'].toString()} °C\n',
                      style: new TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.normal,
                          fontSize: 17.0),
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic App"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () {
                _gotoChangeCity(context);
              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "assets/umbrella.png",
              width: 1080.0,
              height: 1920.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
            child: new Text(
              '${_city != null ? _city : Utils.defaultCity}',
              style: cityStyle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("assets/light_rain.png"),
          ),
          updateTempInfo(_city)
        ],
      ),
    );
  }
}

class ChangeCityScreen extends StatelessWidget {
  TextEditingController _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        title: new Text("Change City"),
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "assets/white_snow.png",
              width: 1080.0,
              height: 1920.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    labelText: 'Enter City',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _cityFieldController,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {'city': _cityFieldController.text});
                  },
                  child: new Text(
                    "Get Weather",
                  ),
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle tempStyle() {
  return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 55.9);
}
