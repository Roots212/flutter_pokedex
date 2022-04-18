import 'package:bloc/bloc.dart';
import 'package:pokedox_flutter/src/data/model/pokemonDetailModal.dart';
import 'package:pokedox_flutter/src/data/repository/pokemon_repository.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  PokemonBloc() : super(PokemonInitial()) {
    on<PokemonFetchApiEvent>(_mapPokemonFetchEvent);
  }
  final PokemonRepository pokemonRepository = PokemonRepository();
  int page = 0;
  bool isFetching = false;
  List<PokemonDetail> pokemonDetail = [];

  Future<void> _mapPokemonFetchEvent(
      PokemonEvent event, Emitter<PokemonState> emit) async {
    if (event is PokemonFetchApiEvent) {
      emit(PokemonLoading(
          message: 'Fetching Pokemons', oldPokemonDetailList: pokemonDetail));

      try {
        final pokemonResponse = await pokemonRepository.getPokemons(page);
        for (int i = 0; i < pokemonResponse!.pokemonList.length; i++) {
          final temp = await pokemonRepository
              .getPokemonDetails(pokemonResponse.pokemonList[i].id);
          pokemonDetail.add(temp!);
        }
        emit(PokemonLoadSuccess(pokemonDetailList: pokemonDetail));
        page++;
      } on Error catch (e) {
        emit(PokemonError(error: e));
      }
    }
  }
}
