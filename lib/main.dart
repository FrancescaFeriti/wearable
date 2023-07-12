import 'package:flow1_prova/database/database.dart';
import 'package:flow1_prova/screens/datasetting.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flow1_prova/screens/loginPage.dart';
import 'package:flow1_prova/screens/homePage.dart';
import 'package:flow1_prova/Repository/databaseRepository.dart';
import 'package:provider/provider.dart';
import 'package:floor/floor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final databaseRepository = DatabaseRepository(database: database);

  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: MyApp(),
  ));
} //main

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  } //build
}//MyApp

