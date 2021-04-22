import 'package:flutter/material.dart';
import 'route.dart';

void main() {
  runApp(MyApp());
}

// Main App Rendering
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Central Dashboard version 5',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Open Sans'),
      routes: routes,
    );
  }
}
