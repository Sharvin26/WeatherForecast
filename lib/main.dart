import 'package:flutter/material.dart';
import './ui/weather.dart';

void main(){
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WeatherForecast",
      home: new Weather(),
    )
  );
}