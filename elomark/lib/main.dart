//import 'package:firebase_core/firebase_core.dart';
import 'package:elomark/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(GetMaterialApp(
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
