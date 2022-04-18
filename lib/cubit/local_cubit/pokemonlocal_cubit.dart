import 'package:bloc/bloc.dart';
import 'package:pokedox_flutter/src/data/model/pokemonDetailModal.dart';
import 'package:pokedox_flutter/src/data/repository/pokemon_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pokemonlocal_state.dart';

class PokemonlocalCubit extends Cubit<PokemonlocalState> {
  PokemonlocalCubit() : super(PokemonlocalInitial());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final PokemonRepository pokemonRepository = PokemonRepository();
  int fav_length = 0;

  loadFavourites() async {
    emit(PokemonLocalLoading());
    try {
      final SharedPreferences prefs = await _prefs;
      List<String> favouritePokemonList = [];

      favouritePokemonList = prefs.getStringList('favourites') ?? [];

      List<PokemonDetail> pokemonDetail = [];
      if (favouritePokemonList.isNotEmpty) {
        for (int i = 0; i < favouritePokemonList.length; i++) {
          final temp = await pokemonRepository
              .getPokemonDetails(int.parse(favouritePokemonList[i]));
          pokemonDetail.add(temp!);
        }

        fav_length = pokemonDetail.length;
        emit(PokemonlocalLoadSuccess(pokemonDetailList: pokemonDetail));
      } else {
        emit(PokemonlocalEmpty());
      }
    } on Error catch (e) {
      emit(PokemonlocalError());
    }
  }

  addtoFav(int id) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favouritePokemonList = [];

    favouritePokemonList = prefs.getStringList('favourites') ?? [];
    favouritePokemonList.add(id.toString());
    prefs.setStringList('favourites', favouritePokemonList);
    loadFavourites();
  }

  removeFromFav(int id) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favouritePokemonList = [];

    favouritePokemonList = prefs.getStringList('favourites') ?? [];
    favouritePokemonList.remove(id.toString());
    prefs.setStringList('favourites', favouritePokemonList);
    loadFavourites();
  }
}
