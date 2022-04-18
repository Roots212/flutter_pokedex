// ignore_for_file: prefer_const_constructors, prefer_final_fields, must_be_immutable, use_key_in_widget_constructors

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:pokedox_flutter/bloc/pokemon_bloc.dart';
import 'package:pokedox_flutter/cubit/button_cubit/buttoncubit_cubit.dart';
import 'package:pokedox_flutter/cubit/color_cubit/cubit/color_cubit.dart';
import 'package:pokedox_flutter/cubit/local_cubit/pokemonlocal_cubit.dart';
import 'package:pokedox_flutter/src/data/model/pokemonDetailModal.dart';
import 'package:pokedox_flutter/src/presentation/pokemon_detailscreen.dart';
import 'package:pokedox_flutter/src/utils/colors.dart';
import 'package:pokedox_flutter/src/utils/string_extensions.dart';
import 'package:pokedox_flutter/src/widgets/customLoader.dart';
import 'package:sizer/sizer.dart';

import '../widgets/custom_tabindicator.dart';

class PokemonHomeScreen extends StatelessWidget {
  ScrollController _apiscrollController = ScrollController();
  List<PokemonDetail> pokemonApiDetailList = [];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark));
    BlocProvider.of<PokemonlocalCubit>(context).loadFavourites();
    SizerUtil().toString();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CustomColors.appBackground,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Image.asset(
                'assets/images/heading_poke.png',
                width: 35.0.w,
              ),
              SizedBox(
                height: 0.2.h,
              ),
              Divider(
                thickness: 1.0.sp,
              )
            ],
          ),
          bottom: TabBar(
              indicator: CustomTabIndicator(
                indicatorHeight: 0.5.h,
                color: CustomColors.splashBackground,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3.0.sp,
              labelColor: Colors.black,
              labelStyle:
                  TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
              unselectedLabelStyle:
                  TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.normal),
              unselectedLabelColor: CustomColors.unselectedColor,
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                Tab(
                  text: 'All Pokemons',
                ),
                Row(
                  children: [
                    Tab(
                      text: 'Favourites',
                    ),
                    SizedBox(
                      width: 1.5.w,
                    ),
                    BlocBuilder<PokemonlocalCubit, PokemonlocalState>(
                      builder: (context, state) {
                        int fav_length = 0;
                        if (state is PokemonlocalLoadSuccess) {
                          fav_length = state.pokemonDetailList.length;
                        }
                        return Badge(
                          badgeColor: CustomColors.splashBackground,
                          badgeContent: Text(fav_length.toString(),
                              style: TextStyle(color: Colors.white)),
                        );
                      },
                    ),
                  ],
                )
              ]),
        ),
        body: SafeArea(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [apiBodyWidget('all'), localBodyWidget('fav', context)],
          ),
        ),
      ),
    );
  }

  apiBodyWidget(String text) {
    return BlocConsumer<PokemonBloc, PokemonState>(
        buildWhen: (previous, current) {
      return (current is PokemonLoadSuccess && previous is PokemonLoading);
    }, builder: (context, state) {
      if (state is PokemonLoading && pokemonApiDetailList.isEmpty) {
        return _loadingIndicator();
      } else if (state is PokemonLoadSuccess) {
        pokemonApiDetailList = [];
        pokemonApiDetailList.addAll(state.pokemonDetailList);
        context.read<PokemonBloc>().isFetching = false;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else if (state is PokemonError && pokemonApiDetailList.isEmpty) {
        return _errorWidget(context);
      }
      return _loadSuccessApi(context);
    }, listener: (context, state) {
      if (state is PokemonLoading && context.read<PokemonBloc>().page != 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            content: Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(
                color: CustomColors.splashBackground,
              ),
            )));
      } else if (state is PokemonLoadSuccess &&
          state.pokemonDetailList.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No more pokemons')));
      } else if (state is PokemonError) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong try again')));
        context.read<PokemonBloc>().isFetching = false;
      }
      return;
    });
  }

  localBodyWidget(String text, context) {
    return BlocConsumer<PokemonlocalCubit, PokemonlocalState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is PokemonLocalLoading) {
          return _loadingIndicator();
        } else if (state is PokemonlocalLoadSuccess) {
          return _loadSuccessLocal(context, state.pokemonDetailList);
        } else if (state is PokemonlocalEmpty) {
          return _emptyDataWidget(context);
        } else {
          return _errorWidgetLocal(context);
        }
      },
    );
  }

  Widget _loadSuccessApi(BuildContext context) {
    return GridView.builder(
        controller: _apiscrollController
          ..addListener(() {
            if (_apiscrollController.offset ==
                    _apiscrollController.position.maxScrollExtent &&
                !context.read<PokemonBloc>().isFetching) {
              context.read<PokemonBloc>().add(PokemonFetchApiEvent());
              context.read<PokemonBloc>().isFetching = true;
            }
          }),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.6),
        itemCount: pokemonApiDetailList.length,
        itemBuilder: (context, index) {
          return ImagePixels(
              imageProvider: NetworkImage(pokemonApiDetailList[index].imageUrl),
              builder: (BuildContext context, ImgDetails img) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => ButtonCubit(),
                              child: PokemonDetailScreen(
                                pokemonDetail: pokemonApiDetailList[index],
                              ),
                            )));
                    BlocProvider.of<ColorCubit>(context).changeColor(
                        img.pixelColorAtAlignment!(Alignment.center),
                        'detailscreen');
                  },
                  child: Container(
                    margin: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0.sp),
                      color: Colors.white,
                    ),
                    child: GridTile(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(3.0.sp),
                                topRight: Radius.circular(3.0.sp)),
                            child: Container(
                              color: img.pixelColorAtAlignment!
                                      (Alignment.center)
                                  .withOpacity(0.2),
                              alignment: Alignment.center,
                              child: Image.network(
                                pokemonApiDetailList[index].imageUrl,
                                width: 85.0.sp,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.all(2.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '#' +
                                      pokemonApiDetailList[index]
                                          .id
                                          .toString()
                                          .padLeft(3, '0'),
                                  style: TextStyle(
                                    color: CustomColors.unselectedColor,
                                    fontSize: 9.0.sp,
                                  )),
                              Text(
                                  pokemonApiDetailList[index]
                                      .name
                                      .toCapitalized(),
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 3.0.h,
                              ),
                              Text(
                                  pokemonApiDetailList[index]
                                      .types
                                      .join(', ')
                                      .toTitleCase(),
                                  style: TextStyle(
                                    color: CustomColors.unselectedColor,
                                    fontSize: 10.0.sp,
                                  )),
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                );
              });
        });
  }

  Widget _loadSuccessLocal(
      BuildContext context, List<PokemonDetail> pokemonLocalDetailList) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.6),
        itemCount: pokemonLocalDetailList.length,
        itemBuilder: (context, index) {
          return ImagePixels(
              imageProvider:
                  NetworkImage(pokemonLocalDetailList[index].imageUrl),
              builder: (BuildContext context, ImgDetails img) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => ButtonCubit(),
                              child: PokemonDetailScreen(
                                pokemonDetail: pokemonLocalDetailList[index],
                              ),
                            )));
                    BlocProvider.of<ColorCubit>(context).changeColor(
                        img.pixelColorAtAlignment!(Alignment.center),
                        'detailscreen');
                  },
                  child: Container(
                    margin: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0.sp),
                      color: Colors.white,
                    ),
                    child: GridTile(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(3.0.sp),
                                topRight: Radius.circular(3.0.sp)),
                            child: Container(
                              color: img.pixelColorAtAlignment!
                                      (Alignment.center)
                                  .withOpacity(0.2),
                              alignment: Alignment.center,
                              child: Image.network(
                                pokemonLocalDetailList[index].imageUrl,
                                errorBuilder: (context, error, stackTrace) {
                                  return SvgPicture.asset(
                                    'assets/svg/pbg_logo.svg',
                                    color: Colors.black.withOpacity(0.1),
                                    fit: BoxFit.fitWidth,
                                  );
                                },
                                width: 85.0.sp,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.all(2.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '#' +
                                      pokemonLocalDetailList[index]
                                          .id
                                          .toString()
                                          .padLeft(3, '0'),
                                  style: TextStyle(
                                    color: CustomColors.unselectedColor,
                                    fontSize: 9.0.sp,
                                  )),
                              Text(
                                  pokemonLocalDetailList[index]
                                      .name
                                      .toCapitalized(),
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 3.0.h,
                              ),
                              Text(
                                  pokemonLocalDetailList[index]
                                      .types
                                      .join(', ')
                                      .toTitleCase(),
                                  style: TextStyle(
                                    color: CustomColors.unselectedColor,
                                    fontSize: 10.0.sp,
                                  )),
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                );
              });
        });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CustomLoader()),
    );
  }

  Widget _errorWidget(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/poke_logo.png',
            width: 35.0.w,
          ),
          Text('Connection Lost',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0.sp,
                  fontWeight: FontWeight.bold)),
          Text(
              'Looks like something went wrong, check your connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w300)),
          SizedBox(height: 5.0.h),
          RawMaterialButton(
            elevation: 2.0,
            fillColor: CustomColors.splashBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0.sp)),
            child: Padding(
              padding: EdgeInsets.all(2.0.w),
              child: Text(
                'Refresh',
                style: TextStyle(fontSize: 15.0.sp, color: Colors.white),
              ),
            ),
            constraints: BoxConstraints(minWidth: 35.0.w),
            onPressed: () {
              context.read<PokemonBloc>().add(PokemonFetchApiEvent());
              context.read<PokemonBloc>().isFetching = true;
            },
          )
        ],
      )),
    );
  }

  Widget _emptyDataWidget(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/poke_logo.png',
            width: 35.0.w,
          ),
          Text('No Data',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0.sp,
                  fontWeight: FontWeight.bold)),
          Text(
              'Looks like you have not saved anything, your favourite pokemons will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w300)),
        ],
      )),
    );
  }

  Widget _errorWidgetLocal(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/poke_logo.png',
            width: 35.0.w,
          ),
          Text('Connection Lost',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0.sp,
                  fontWeight: FontWeight.bold)),
          Text(
              'Looks like something went wrong, check your connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w300)),
          SizedBox(height: 5.0.h),
          RawMaterialButton(
            elevation: 2.0,
            fillColor: CustomColors.splashBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0.sp)),
            child: Padding(
              padding: EdgeInsets.all(2.0.w),
              child: Text(
                'Refresh',
                style: TextStyle(fontSize: 15.0.sp, color: Colors.white),
              ),
            ),
            constraints: BoxConstraints(minWidth: 35.0.w),
            onPressed: () {
              context.read<PokemonlocalCubit>().loadFavourites();
            },
          )
        ],
      )),
    );
  }
}
