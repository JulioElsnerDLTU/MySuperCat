import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mysupercat/shared/data/favorites_provider.dart';
import 'package:mysupercat/shared/presentation/pages/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MySuperCatApp(),
    ),
  );
}

class MySuperCatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySuperCat',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MySuperCatNavigation(),
    );
  }
}

