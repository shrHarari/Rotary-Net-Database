import 'package:flutter/material.dart';
import 'package:rotary_database/screens/main_screen_pages/main_page_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){

    /// Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch(settings.name) {
      case '/':
      case MainPageScreen.routeName:
        return MaterialPageRoute(builder: (_) => MainPageScreen());

        break;


      default:
        return MaterialPageRoute(builder: (_) => MainPageScreen()
        );
    }
  }
}
