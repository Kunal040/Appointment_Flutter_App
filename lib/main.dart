

import 'package:barber/screens/add_shop.dart';

import './provider/slots_provider.dart';

import './screens/slots_screen.dart';

import './screens/tabs_screen.dart';


import 'package:flutter/material.dart';




import 'package:provider/provider.dart';
import './provider/shop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Shop(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SlotsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TabsScreen(),
        routes: {
          SlotsScreen.routeName: (ctx) => SlotsScreen(),
          AddShop.routeName : (ctx) => AddShop(),
        },
        onUnknownRoute: (settings){
          return MaterialPageRoute(builder: (ctx) => TabsScreen());
        },
        supportedLocales: const [Locale('en', 'GB')],
      ),
    );
  }
}

