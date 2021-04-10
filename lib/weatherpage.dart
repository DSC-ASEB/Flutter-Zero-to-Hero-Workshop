import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // initstate runs as soon as app launches
  @override
  void initState() {
    getweather();
    super.initState();
  }

  WeatherFactory wf = new WeatherFactory("aef5002fb96136cdd4b39bc9110472b8");
  Weather mylocation;
  bool loading = true; // loading to wait until
  getweather() async {
    // 1 request permission
    await Geolocator.requestPermission();
    print('gotlocation');
    // 2 get latitude longitude
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('latitude: ${position.latitude} longitude : ${position.longitude}');
    //3 get weather
    Weather w = await wf.currentWeatherByLocation(
        position.latitude, position.longitude);
    //4 assigning location w to mylocation
    setState(() {
      mylocation = w;
      loading = false;
    });
  }

  String b = '123';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading == true     // if it is still loading we show a progress loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Column(          // shows the column when loading =false
                children: [
                  Container(
                    color: Colors.blueAccent,
                    alignment: Alignment.center,
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Currently in ${mylocation.areaName}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          '${mylocation.temperature.celsius}°',
                          style: TextStyle(color: Colors.white, fontSize: 50),
                        ),
                        Text(
                          '${mylocation.weatherDescription}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                          child: Column(
                    children: [
                      ListTile(
                          leading: Icon(Icons.thermostat_outlined),
                          title: Text('Temperature'),
                          trailing: Text('${mylocation.temperature}')),
                      ListTile(
                          leading: Icon(Icons.cloud),
                          title: Text('Weather'),
                          trailing: Text('${mylocation.weatherDescription}')),
                      ListTile(
                          leading: Icon(CupertinoIcons.cloud),
                          title: Text('Feels like'),
                          trailing: Text('${mylocation.tempFeelsLike}')),
                      ListTile(
                          leading: Icon(CupertinoIcons.wind),
                          title: Text('Windspeed'),
                          trailing: Text('${mylocation.windSpeed}'))
                    ],
                  )))
                ],
              ));
  }
}
