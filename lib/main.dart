// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedox_flutter/bloc/pokemon_bloc.dart';
import 'package:pokedox_flutter/cubit/color_cubit/cubit/color_cubit.dart';
import 'package:pokedox_flutter/cubit/local_cubit/pokemonlocal_cubit.dart';
import 'package:pokedox_flutter/src/presentation/splash_screen%20.dart';
import 'package:pokedox_flutter/src/utils/colors.dart';
import 'package:sizer/sizer.dart';

main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
         BlocProvider<ColorCubit>(
            create: (BuildContext context) => ColorCubit()),
        BlocProvider<PokemonlocalCubit>(
            create: (BuildContext context) => PokemonlocalCubit()),
            
        BlocProvider<PokemonBloc>(
            create: (BuildContext context) => PokemonBloc())
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SplashScreen());
      }),
    );
  }
}
