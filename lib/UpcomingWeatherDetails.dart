import 'package:meta/meta.dart';
import 'dart:convert';

class UpcomingWeatherDetails {
  double lat;
  double lon;
  String tz;
  DateTime date;
  String units;
  CloudCover cloudCover;
  CloudCover humidity;
  Precipitation precipitation;
  Temperature temperature;
  CloudCover pressure;
  Wind wind;

  UpcomingWeatherDetails({
    required this.lat,
    required this.lon,
    required this.tz,
    required this.date,
    required this.units,
    required this.cloudCover,
    required this.humidity,
    required this.precipitation,
    required this.temperature,
    required this.pressure,
    required this.wind,
  });

  factory UpcomingWeatherDetails.fromRawJson(String str) =>
      UpcomingWeatherDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpcomingWeatherDetails.fromJson(Map<String, dynamic> json) =>
      UpcomingWeatherDetails(
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        tz: json["tz"],
        date: DateTime.parse(json["date"]),
        units: json["units"],
        cloudCover: CloudCover.fromJson(json["cloud_cover"]),
        humidity: CloudCover.fromJson(json["humidity"]),
        precipitation: Precipitation.fromJson(json["precipitation"]),
        temperature: Temperature.fromJson(json["temperature"]),
        pressure: CloudCover.fromJson(json["pressure"]),
        wind: Wind.fromJson(json["wind"]),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "tz": tz,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "units": units,
        "cloud_cover": cloudCover.toJson(),
        "humidity": humidity.toJson(),
        "precipitation": precipitation.toJson(),
        "temperature": temperature.toJson(),
        "pressure": pressure.toJson(),
        "wind": wind.toJson(),
      };
}

class CloudCover {
  double afternoon;

  CloudCover({
    required this.afternoon,
  });

  factory CloudCover.fromRawJson(String str) =>
      CloudCover.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CloudCover.fromJson(Map<String, dynamic> json) => CloudCover(
        afternoon: json["afternoon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "afternoon": afternoon,
      };
}

class Precipitation {
  double total;

  Precipitation({
    required this.total,
  });

  factory Precipitation.fromRawJson(String str) =>
      Precipitation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Precipitation.fromJson(Map<String, dynamic> json) => Precipitation(
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
      };
}

class Temperature {
  double min;
  double max;
  double afternoon;
  double night;
  double evening;
  double morning;

  Temperature({
    required this.min,
    required this.max,
    required this.afternoon,
    required this.night,
    required this.evening,
    required this.morning,
  });

  factory Temperature.fromRawJson(String str) =>
      Temperature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Temperature.fromJson(Map<String, dynamic> json) => Temperature(
        min: json["min"]?.toDouble(),
        max: json["max"]?.toDouble(),
        afternoon: json["afternoon"]?.toDouble(),
        night: json["night"]?.toDouble(),
        evening: json["evening"]?.toDouble(),
        morning: json["morning"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
        "afternoon": afternoon,
        "night": night,
        "evening": evening,
        "morning": morning,
      };
}

class Wind {
  Max max;

  Wind({
    required this.max,
  });

  factory Wind.fromRawJson(String str) => Wind.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        max: Max.fromJson(json["max"]),
      );

  Map<String, dynamic> toJson() => {
        "max": max.toJson(),
      };
}

class Max {
  double speed;
  double direction;

  Max({
    required this.speed,
    required this.direction,
  });

  factory Max.fromRawJson(String str) => Max.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Max.fromJson(Map<String, dynamic> json) => Max(
        speed: json["speed"]?.toDouble(),
        direction: json["direction"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "direction": direction,
      };
}
