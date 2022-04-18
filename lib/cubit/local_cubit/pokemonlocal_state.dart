// ignore_for_file: prefer_const_constructors_in_immutables

part of 'pokemonlocal_cubit.dart';

abstract class PokemonlocalState {
  const PokemonlocalState();

  @override
  List<Object> get props => [];
}

class PokemonlocalInitial extends PokemonlocalState {}


class PokemonLocalLoading extends PokemonlocalState {
 

  PokemonLocalLoading();
}
class PokemonlocalLoadSuccess extends PokemonlocalState {
   final List<PokemonDetail> pokemonDetailList;


  PokemonlocalLoadSuccess({required this.pokemonDetailList});
}
class PokemonlocalError extends PokemonlocalState {
  

  PokemonlocalError();
}
class PokemonlocalEmpty extends PokemonlocalState {
  

  PokemonlocalEmpty();
}
