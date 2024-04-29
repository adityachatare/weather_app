import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/UpcomingWeatherDetails.dart';
import 'package:weather_app/WeatherDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool selectedToday = true;
  bool selectedTomorrow = false;
  bool selectedNextWeek = false;
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  // late LatLng _center;
  String currentTemp = '';
  String weather = '';
  bool positionStreamStarted = false;
  late LocationPermission permission;
  double latitudeData = 0.0, longitudeData = 0.0;
  Future<List> _getCurrentLocation() async {
    await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    print("Permission : $permission");

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      latitudeData = 0.0;
      longitudeData = 0.0;
    } else {
      //  if (permission == LocationPermission.always ||
      //   permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        // _center = LatLng(position.latitude, position.longitude);
        latitudeData = position.latitude;
        longitudeData = position.longitude;
      });
      print("Latitude : $latitudeData \n longitite : $longitudeData ");
      await _getAddressFromLatLng();
      await getWeatherUpdate(position.latitude, position.longitude)
          .then((value) {
        print(value);
        setState(() {
          currentTemp = value.current.temp.toString();
          weather = value.current.weather[0].main;
        });
        print("Temp Now : ${value.current.temp}");
      });
      // }
    }

    return [latitudeData, longitudeData];
  }

  Placemark pos = Placemark();
  Future<void> _getAddressFromLatLng() async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitudeData, longitudeData);
      print("placemarks : $placemarks");
      if (placemarks.isNotEmpty) {
        setState(() {
          pos = placemarks[0];

          // _address =
          //     '${pos.name}, ${pos.subLocality}, ${pos.locality}, ${pos.administrativeArea} ${pos.postalCode}, ${pos.country}';
        });
      }

      // print("address $_address ");
    } catch (e) {
      print(e);
    }
  }

  Future<WeatherDetails> getWeatherUpdate(double lat, double long) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/3.0/onecall?lat=${lat.toString()}&lon=${long.toString()}&exclude=hourly,daily&units=metric&appid=1038208bd4cecf2450b8b31623a1c84d"));
    print(
        "https://api.openweathermap.org/data/3.0/onecall?lat=${lat.toString()}&lon=${long.toString()}&exclude=hourly,daily&units=metric&appid=1038208bd4cecf2450b8b31623a1c84d");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var post = WeatherDetails.fromJson(json.decode(response.body));

      return post;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post!');
    }
  }

  Future<UpcomingWeatherDetails> getUpcomingWeatherDetails(
      double lat, double long, String date) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/3.0/onecall/day_summary?lat=${lat.toString()}&lon=${long.toString()}&date=$date&units=metric&appid=1038208bd4cecf2450b8b31623a1c84d"));
    print(
        "https://api.openweathermap.org/data/3.0/onecall/day_summary?lat=${lat.toString()}&lon=${long.toString()}&date=$date&units=metric&appid=1038208bd4cecf2450b8b31623a1c84d");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var post = UpcomingWeatherDetails.fromJson(json.decode(response.body));

      return post;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post!');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _handlePermission();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedToday = true;
                          selectedTomorrow = false;
                          selectedNextWeek = false;
                        });
                        _getCurrentLocation();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            selectedToday ? Colors.green : null),
                      ),
                      child: Text("Today",
                          style: TextStyle(
                              color: selectedToday ? Colors.white : null))),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          selectedToday = false;
                          selectedTomorrow = true;
                          selectedNextWeek = false;
                        });
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        await getUpcomingWeatherDetails(
                                latitudeData, longitudeData, formattedDate)
                            .then((value) {
                          setState(() {
                            currentTemp = value.temperature.max.toString();
                            weather = value.cloudCover.afternoon == 0
                                ? "Clear"
                                : "Cloudy";
                          });
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            selectedTomorrow ? Colors.green : null),
                      ),
                      child: Text(
                        "Tomorrow",
                        style: TextStyle(
                            color: selectedTomorrow ? Colors.white : null),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedToday = false;
                          selectedTomorrow = false;
                          selectedNextWeek = true;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            selectedNextWeek ? Colors.green : null),
                      ),
                      child: Text("Next Week",
                          style: TextStyle(
                              color: selectedNextWeek ? Colors.white : null)))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: 500,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(187, 44, 217, 100),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  Text(
                    "$currentTemp \u00B0",
                    style: const TextStyle(
                        fontSize: 60.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text("${pos.locality}, ${pos.country}"),
                  weather == "Clear"
                      ? Image(image: AssetImage("images/sunny.png"))
                      : weather == "Cloudy"
                          ? Image(image: AssetImage("images/cloudy.png"))
                          : Image(image: AssetImage("images/rainy.png")),
                  Text("${weather}"),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Position position = await Geolocator.getCurrentPosition(
          //     desiredAccuracy: LocationAccuracy.high);
          _getCurrentLocation();
          // print(position);
        },
        child: Icon(Icons.gps_fixed),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
