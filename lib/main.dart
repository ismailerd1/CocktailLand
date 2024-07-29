// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:cocktailland/models/cocktail.dart';
import 'package:cocktailland/components/bottomnavbar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CocktailAdapter());
  await Hive.openBox<Cocktail>('cocktailsBox');
  await Hive.openBox<Cocktail>('favoriteCocktailsBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyNavbar(),
    );
  }
}


