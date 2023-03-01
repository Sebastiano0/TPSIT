import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class WeatherIcon {
  static Future<String?> getStopWeather(
      double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=349c7aa6dfab04cf4bbbe24307bc4af3';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    if (data != null &&
        data['weather'] != null &&
        data['weather'][0] != null &&
        data['weather'][0]["icon"] != null) {
      debugPrint("${data['weather'][0]["icon"]}:${data['main']["feels_like"]}");
      return "${data['weather'][0]["icon"]}:${data['main']["feels_like"]}";
    } else {
      return null;
    }
  }
}
