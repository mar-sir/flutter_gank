import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gank_app/gank_configuration.dart';
import 'package:gank_app/home_page.dart';
import 'package:gank_app/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GankConfiguration _configuration =
      GankConfiguration(platForm: PlatForm.android, themeType: ThemeType.light);

  void configurationUpdater(GankConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    print('_MyAppState.build');
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return MaterialApp(
      title: '干货集中营',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(_configuration, configurationUpdater),
        '/search': (context) => SearchPage()
      },
    );
  }

  @override
  void initState() {
    print('_MyAppState.initState');
    super.initState();
    _loadConfig();
  }

  Future<Null> _loadConfig() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeType themeType =
        ThemeType.values.elementAt(prefs.getInt('theme') ?? 0);
    PlatForm platForm =
        PlatForm.values.elementAt(prefs.getInt('platform') ?? 0);
    _configuration =
        _configuration.copyWith(themeType: themeType, platForm: platForm);
    print(_configuration.platForm);
    configurationUpdater(_configuration.copyWith(themeType: themeType, platForm: platForm));
  }


  TargetPlatform get platform {
    switch (_configuration.platForm) {
      case PlatForm.android:
        return TargetPlatform.android;
      case PlatForm.iOS:
        return TargetPlatform.iOS;
    }
    assert(_configuration.platForm != null);
    return null;
  }

  ThemeData get theme {
    switch (_configuration.themeType) {
      case ThemeType.brown:
        return ThemeData(
          primarySwatch: Colors.brown,
          brightness: Brightness.light,
          platform: platform,
        );
      case ThemeType.light:
        return ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          platform: platform,
        );
      case ThemeType.dark:
        return ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          accentColor: Colors.red,
          platform: platform,
        );
      case ThemeType.pink:
        return ThemeData(
          primarySwatch: Colors.pink,
          brightness: Brightness.light,
          platform: platform,
        );
      case ThemeType.purple:
        return ThemeData(
          primarySwatch: Colors.purple,
          platform: platform,
        );
    }
    assert(_configuration.themeType != null);

    return null;
  }
}
