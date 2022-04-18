// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokedox_flutter/bloc/pokemon_bloc.dart';
import 'package:pokedox_flutter/cubit/button_cubit/buttoncubit_cubit.dart';
import 'package:pokedox_flutter/cubit/local_cubit/pokemonlocal_cubit.dart';
import 'package:pokedox_flutter/src/data/model/pokemonDetailModal.dart';
import 'package:pokedox_flutter/src/data/model/pokemonResponseModal.dart';
import 'package:pokedox_flutter/src/presentation/pokemon_homescreen.dart';
import 'package:pokedox_flutter/src/utils/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:pokedox_flutter/src/utils/string_extensions.dart';

import '../../cubit/color_cubit/cubit/color_cubit.dart';

class PokemonDetailScreen extends StatelessWidget {
  final PokemonDetail pokemonDetail;

  const PokemonDetailScreen({Key? key, required this.pokemonDetail})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ButtonCubit>(context).checkMarked(pokemonDetail.id);
    SizerUtil().toString();
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        BlocProvider.of<ColorCubit>(context)
            .changeColor(Colors.white, 'homescreen');
        return Future.value(true);
      },
      child: Scaffold(
          floatingActionButton: BlocBuilder<ButtonCubit, ButtoncubitState>(
            builder: (context, state) {
              bool isMarked = false;
              if (state is ButtoncubitSaved) {
                return FloatingActionButton.extended(
                    backgroundColor: CustomColors.buttonBackground,
                    onPressed: () {
                      BlocProvider.of<PokemonlocalCubit>(context)
                          .removeFromFav(pokemonDetail.id);
                      BlocProvider.of<ButtonCubit>(context)
                          .checkMarked(pokemonDetail.id);
                    },
                    label: Text(
                      'Remove as favourite',
                      style: TextStyle(color: CustomColors.splashBackground),
                    ));
              } else {
                return FloatingActionButton.extended(
                    backgroundColor: CustomColors.splashBackground,
                    onPressed: () {
                      BlocProvider.of<PokemonlocalCubit>(context)
                          .addtoFav(pokemonDetail.id);
                      BlocProvider.of<ButtonCubit>(context)
                          .checkMarked(pokemonDetail.id);
                    },
                    label: Text('Mark as favourite'));
              }
            },
          ),
          backgroundColor: CustomColors.appBackground,
          body: SafeArea(
              child: NestedScrollView(
                  body: _bodyWidget(context),
                  headerSliverBuilder: (context, innerBoxisScrolled) =>
                      [_headerWidget(context)]))),
    );
  }

  Widget _bodyWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bmiWidget(context),
        SizedBox(
          height: 1.0.h,
        ),
        _statsWidget(context, pokemonDetail)
      ],
    );
  }

  Widget _headerWidget(context) {
    return ImagePixels(
        imageProvider: NetworkImage(pokemonDetail.imageUrl),
        builder: (BuildContext context, ImgDetails img) {
          return SliverAppBar(
            expandedHeight: 30.0.h,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true, background: _bottomWidget(context)),
            floating: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<ColorCubit>(context)
                      .changeColor(Colors.white, 'homescreen');
                },
                icon: Icon(Icons.arrow_back_ios_rounded)),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor:
                img.pixelColorAtAlignment!(Alignment.center).withOpacity(0.2),
            pinned: false,
          );
        });
  }

  Widget _bottomWidget(context) {
    return ImagePixels(
        imageProvider: NetworkImage(pokemonDetail.imageUrl),
        builder: (BuildContext context, ImgDetails img) {
          return Container(
            padding: EdgeInsets.only(top: 8.0.h),
            height: 25.0.h,
            color:
                img.pixelColorAtAlignment!(Alignment.center).withOpacity(0.2),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemonDetail.name.toCapitalized(),
                        style: TextStyle(
                            letterSpacing: 0.5.w,
                            fontSize: 25.0.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pokemonDetail.types.join(', ').toTitleCase(),
                        style: TextStyle(
                            letterSpacing: 0.5.w,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Text(
                        '#' + pokemonDetail.id.toString().padLeft(3, '0'),
                        style: TextStyle(
                            fontSize: 16.0.sp, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Stack(
                  children: [
                    ClipRect(
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 43.0.w,
                          height: 30.0.h,
                          child: SvgPicture.asset(
                            'assets/svg/pbg_logo.svg',
                            color: Colors.black.withOpacity(0.1),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 43.0.w,
                      child: Image.network(
                        pokemonDetail.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget _bmiWidget(context) {
    return Container(
      color: Colors.white,
      height: 9.0.h,
      child: Row(
        children: [
          _titleSubtitle(context, 'Height', pokemonDetail.height.toString()),
          _titleSubtitle(context, 'Weight', pokemonDetail.weight.toString()),
          _titleSubtitle(
              context,
              'BMI',
              power(pokemonDetail.height, 2, pokemonDetail.weight)
                  .toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _titleSubtitle(context, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.all(5.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.0.sp,
            ),
          )
        ],
      ),
    );
  }
}

Widget _statsWidget(context, PokemonDetail pokemonDetail) {
  int total = 0;

  return Expanded(
    child: Container(
      width: 100.0.w,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5.0.w, 5.0.w, 0.0, 2.0.w),
            child: Text('Base Stats',
                style:
                    TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold)),
          ),
          Divider(
            thickness: 1.0.sp,
          ),
          Expanded(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: pokemonDetail.stats.length + 1,
                itemBuilder: (context, index) {
                  index < pokemonDetail.stats.length
                      ? total = total + pokemonDetail.stats[index].baseStat!
                      : total = total;

                  return index < pokemonDetail.stats.length
                      ? _individualStats(
                          context,
                          pokemonDetail.stats[index].stat!.name!,
                          pokemonDetail.stats[index].baseStat!)
                      : _individualStats(
                          context, 'Avg. Power', (total / 6).toInt());
                }),
          ),
        ],
      ),
    ),
  );
}

Widget _individualStats(context, String field, int value) {
  return Padding(
    padding: EdgeInsets.fromLTRB(5.0.w, 5.0.w, 5.0.w, 0.0),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              field.toTitleCase(),
              style: TextStyle(color: Colors.grey, fontSize: 13.0.sp),
            ),
            SizedBox(
              width: 3.0.w,
            ),
            Text(
              value.toString(),
              style: TextStyle(color: Colors.black, fontSize: 13.0.sp),
            )
          ],
        ),
        SizedBox(
          height: 1.0.h,
        ),
        FAProgressBar(
          maxValue: 120.0,
          size: 6.0.sp,
          changeColorValue: 50,
          changeProgressColor: Colors.green,
          progressColor: Colors.red,
          backgroundColor: CustomColors.appBackground,
          borderRadius: BorderRadius.circular(10.0.sp),
          currentValue: value.toDouble(),
        )
      ],
    ),
  );
}

double power(int height, int n, int weight) {
  double retval = 1;
  int temp = pow(height, 2).toInt();
  retval = (weight / temp);
  return retval;
}
