import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterial_components/flutterial_components.dart';
import 'package:path_provider/path_provider.dart';

const flutterialChannel = const MethodChannel("flutterial");

class ThemeService {
  Directory _appDir;

  ThemeData theme;

  File _file;

  final ValueNotifier<ThemeData> themeNotifier =
      new ValueNotifier(new ThemeData.light());

  ThemeService() {
    flutterialChannel.setMethodCallHandler((call) {
      print('ThemeService.onRemoteCall... ${call.method} ${call.arguments}');
    });
    getApplicationDocumentsDirectory().then((d) {
      _appDir = d;
      initTheme();
    });
  }
  void loadThemefromJSON(dynamic themeMap) {
    theme = new ThemeData.light().copyWith(
        primaryColor: getMaterialColor(themeMap['primaryColor'].toString()),
        accentColor: getMaterialColor(themeMap['accentColor'].toString()),
        scaffoldBackgroundColor:
            getMaterialColor(themeMap['scaffoldBackgroundColor'].toString()),
        buttonColor: getMaterialColor(themeMap['buttonColor'].toString()),
        dividerColor: getMaterialColor(themeMap['dividerColor'].toString()),
        canvasColor: getMaterialColor(themeMap['canvasColor'].toString()),
        cardColor: getMaterialColor(themeMap['cardColor'].toString()),
        disabledColor: getMaterialColor(themeMap['disabledColor'].toString()),
        backgroundColor:
            getMaterialColor(themeMap['backgroundColor'].toString()),
        highlightColor: getMaterialColor(themeMap['highlightColor'].toString()),
        splashColor: getMaterialColor(themeMap['splashColor'].toString()),
        dialogBackgroundColor:
            getMaterialColor(themeMap['dialogBackgroundColor'].toString()),
        hintColor: getMaterialColor(themeMap['hintColor'].toString()),
        errorColor: getMaterialColor(themeMap['errorColor'].toString()),
        indicatorColor: getMaterialColor(themeMap['indicatorColor'].toString()),
        selectedRowColor:
            getMaterialColor(themeMap['selectedRowColor'].toString()),
        unselectedWidgetColor:
            getMaterialColor(themeMap['unselectedWidgetColor'].toString()),
        secondaryHeaderColor:
            getMaterialColor(themeMap['secondaryHeaderColor'].toString()),
        textSelectionColor:
            getMaterialColor(themeMap['textSelectionColor'].toString()),
        textSelectionHandleColor:
            getMaterialColor(themeMap['textSelectionHandleColor'].toString()),
        platform: themeMap['textSelectionHandleColor'].toString() == "ios"
            ? TargetPlatform.iOS
            : TargetPlatform.android,
        brightness:
            themeMap['isDark'] == 1 ? Brightness.dark : Brightness.light);

    themeNotifier.value = theme;
    //print('ThemeService.load  jsonTheme ${jsonTheme}');
  }

  Future loadTheme(File file) async {
    final jsonTheme = await file.readAsString();
    final themeMap = json.decode(jsonTheme);
    loadThemefromJSON(themeMap);
  }

  Future initTheme() async {
    print('ThemeService.initTheme ${_appDir.path}');
    _file = new File(_appDir.path + '/theme.json');
    if (!(await _file.exists())) {
      print('ThemeService init theme.json... ');
      await _file
          .writeAsString(await rootBundle.loadString("assets/theme.json"));
    }

    loadTheme(_file);

    /*if ( await file.exists())
    else {
    }*/
  }
  Map<String, dynamic> getThemeAsMap(ThemeData themeData) {
    final map = <String, dynamic>{
      "platform": themeData.platform == TargetPlatform.iOS ? 'iOS' : 'android',
      "isDark": themeData.brightness == Brightness.light ? 0 : 1,
      "primaryColor": getMaterialName(themeData.primaryColor),
      "accentColor": getMaterialName(themeData.accentColor),
      "scaffoldBackgroundColor":
          getMaterialName(themeData.scaffoldBackgroundColor),
      "buttonColor": getMaterialName(themeData.buttonColor),
      "dividerColor": getMaterialName(themeData.dividerColor),
      "canvasColor": getMaterialName(themeData.canvasColor),
      "cardColor": getMaterialName(themeData.cardColor),
      "disabledColor": getMaterialName(themeData.disabledColor),
      "backgroundColor": getMaterialName(themeData.backgroundColor),
      "highlightColor": getMaterialName(themeData.highlightColor),
      "splashColor": getMaterialName(themeData.splashColor),
      "dialogBackgroundColor": getMaterialName(themeData.dialogBackgroundColor),
      "hintColor": getMaterialName(themeData.hintColor),
      "errorColor": getMaterialName(themeData.errorColor),
      "indicatorColor": getMaterialName(themeData.indicatorColor),
      "selectedRowColor": getMaterialName(themeData.selectedRowColor),
      "unselectedWidgetColor": getMaterialName(themeData.unselectedWidgetColor),
      "secondaryHeaderColor": getMaterialName(themeData.secondaryHeaderColor),
      "textSelectionColor": getMaterialName(themeData.textSelectionColor),
      "textSelectionHandleColor":
          getMaterialName(themeData.textSelectionHandleColor)
    };
    return map;
  }
  void saveTheme(ThemeData themeData) {
    final map = getThemeAsMap(themeData);
    theme = themeData;
    themeNotifier.value = theme;
    updateThemeFile(json.encode(map));
  }

  Future updateThemeFile(String content) async {
    await _file.writeAsString(content, mode: FileMode.WRITE);
  }
}

getMaterialColor(String name, {VoidCallback or}) => colors_names()
    .firstWhere((c) => c.name == name, orElse: () => colors_names().first)
    .color;

getMaterialName(Color color, {VoidCallback or}) => colors_names()
    .firstWhere((c) => c.color.value == color.value,
        orElse: () => colors_names().first)
    .name;

ThemeData parseTheme(Map<String, dynamic> themeMap) {}
