import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/pages/home_page/home_page.dart';
import 'package:pokedex/stores/pokeapi_store.dart';

void main() {
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<PokeApiStore>(PokeApiStore());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}
