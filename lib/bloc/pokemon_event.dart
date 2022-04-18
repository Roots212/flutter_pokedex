part of 'pokemon_bloc.dart';

abstract class PokemonEvent   {
  const PokemonEvent();


}

class PokemonFetchApiEvent extends PokemonEvent {
  const PokemonFetchApiEvent();
}


