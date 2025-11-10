import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/config/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Manajemen Karyawan',
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
