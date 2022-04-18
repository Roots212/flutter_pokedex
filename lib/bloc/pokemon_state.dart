part of 'pokemon_bloc.dart';

abstract class PokemonState  {
  const PokemonState();

  @override
  List<Object> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {
     final List<PokemonDetail>? oldPokemonDetailList;

  final String message;

  PokemonLoading({required this.message,this.oldPokemonDetailList});
}

class PokemonLoadSuccess extends PokemonState {
   final List<PokemonDetail> pokemonDetailList;


  PokemonLoadSuccess({required this.pokemonDetailList});
}

class PokemonError extends PokemonState {
  final Error error;

  PokemonError({required this.error});
}
