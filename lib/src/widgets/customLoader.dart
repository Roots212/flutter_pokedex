import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: RiveAnimation.asset(
          'assets/rive/pokeLoader.riv',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
