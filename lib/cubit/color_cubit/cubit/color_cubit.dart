// ignore_for_file: prefer_const_constructors

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:pokedox_flutter/src/utils/colors.dart';

part 'color_state.dart';

class ColorCubit extends Cubit<ColorState> {
  ColorCubit() : super(ColorInitial());
  Color? bgcolor;
  changeColor(Color color, String page) {
    bgcolor = color;
    if (page == 'homescreen') {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark));
    } else if (page == 'detailscreen') {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: color.withOpacity(0.35),
          statusBarBrightness: Brightness.dark));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: CustomColors.splashBackground,
          statusBarBrightness: Brightness.light));
    }
  }
}
