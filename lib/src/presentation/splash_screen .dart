// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokedox_flutter/bloc/pokemon_bloc.dart';
import 'package:pokedox_flutter/cubit/local_cubit/pokemonlocal_cubit.dart';
import 'package:pokedox_flutter/src/presentation/pokemon_homescreen.dart';
import 'package:pokedox_flutter/src/utils/colors.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: PokemonHomeScreen(),
            )));
    super.initState();
    BlocProvider.of<PokemonBloc>(context).add(PokemonFetchApiEvent());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: CustomColors.splashBackground,
        statusBarBrightness: Brightness.light));
    SizerUtil().toString();
    return Scaffold(
      backgroundColor: CustomColors.splashBackground,
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          width: 75.0.w,
        ),
      ),
    );
  }
}
