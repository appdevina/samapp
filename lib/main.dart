import 'package:crm_msi/ui/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      title: 'CRM - MIS',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
