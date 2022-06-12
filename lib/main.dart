import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App w64117',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  dynamic data = null;
  final _apiKey = "8d68aa00ea6d0f47fb36a52735bdcd12";
  final _inputController = TextEditingController();

  Future fetchWeather() async {
    final inputValue = _inputController.text;
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=$inputValue&APPID=$_apiKey'));
    setState(() {
      data = jsonDecode(response.body);
    });
  }

  getWeatherImage() {
    final weatherType = data['weather'][0]['main'];
    if (weatherType != null) {
      if (weatherType == "Clouds") {
        return Image.asset('assets/cloudy.png', color: Colors.greenAccent);
      } else if (weatherType == "Clear") {
        return Image.asset('assets/sun.png', color: Colors.greenAccent);
      } else if (weatherType == "Drizzle" || weatherType == "Rain") {
        return Image.asset('assets/rain.png', color: Colors.greenAccent);
      } else if (weatherType == "Thunderstorm") {
        return Image.asset('assets/thunderstorm.png', color: Colors.greenAccent);
      } else if (weatherType == "snow") {
        return Image.asset('assets/snowing.png', color: Colors.greenAccent);
      }
    } else {
      return SizedBox.shrink();
    }
  }

  generateListItems() {
    final convertedTemp = (data['main']['temp'] - 273.15 as double).round();
    final windSpeed = data['wind']['speed'];
    final humidity = data['main']['humidity'];
    final pressure = data['main']['pressure'];
    final sunriseTimestamp = DateTime.fromMillisecondsSinceEpoch(data['sys']['sunrise'] * 1000);
    final sunrise = sunriseTimestamp.hour.toString() + ":" + sunriseTimestamp.minute.toString();
    final sunsetTimestamp = DateTime.fromMillisecondsSinceEpoch(data['sys']['sunset'] * 1000);
    final sunset = sunsetTimestamp.hour.toString() + ":" + sunsetTimestamp.minute.toString();

    return [
      "Temperatura: $convertedTemp\°C",
      "Predkosc wiatru: $windSpeed\km/h",
      "Wilgotnosc: $humidity%",
      "Wschod slonca: $sunrise",
      "Zachod slonca: $sunset",
      "Cisnienie: $pressure\hpa"
    ].map((listItem) {
      return Container(
        height: 60,
        margin: EdgeInsets.only(top: 3, bottom: 3, left: 12, right: 12),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.lightGreenAccent[100]!.withOpacity(0.8), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Text(
              listItem,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFF166D3B),
        body: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.only(top: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF166D3B),
              Color(0x70021802),
            ],
          )),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: TextFormField(
                  controller: _inputController,
                  onFieldSubmitted: (value) async {
                    print(value);
                    await fetchWeather();
                  },
                  decoration: InputDecoration(
                      hintText: "Enter city",
                      contentPadding: EdgeInsets.all(16),
                      isDense: true,
                      border: UnderlineInputBorder(borderRadius: BorderRadius.circular(21), borderSide: BorderSide.none),
                      fillColor: Colors.white,
                      filled: true),
                ),
              ),
              Container(
                height: 20,
              ),
              Center(
                child: (data != null)
                    ? data['cod'] != 200
                        ? Text(
                            "Miejsce, ktorego szukasz nie istnieje",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          )
                        : Column(
                            children: [
                              ...generateListItems(),
                              Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.only(top: 40),
                                child: getWeatherImage(),
                              ),
                            ],
                          )
                    : SizedBox.shrink(),
              )
            ],
          ),
        ));
  }
}
