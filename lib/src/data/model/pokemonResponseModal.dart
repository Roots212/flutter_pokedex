// ignore_for_file: empty_constructor_bodies
import 'package:flutter/foundation.dart';
import 'package:pokedox_flutter/src/data/model/pokemonDetailModal.dart';

class PokemonObject {
  final int id;
  final String name;
  final String url;
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  PokemonObject({required this.id, required this.name, required this.url});

  factory PokemonObject.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final url = json['url'] as String;
    final id = int.parse(url.split('/')[6]);

    return PokemonObject(id: id, name: name, url: url);
  }
}

class PokemonList {
  final List<PokemonObject> pokemonList;
  final bool isNextAvailable;
  final String next;
  PokemonList(
      {required this.pokemonList,
      required this.isNextAvailable,
      required this.next});

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    final isNextAvailable = json['next'] != null;
    final next = json['next'];
    final pokemonList = (json['results'] as List)
        .map((object) => PokemonObject.fromJson(object))
        .toList();
    return PokemonList(
        pokemonList: pokemonList, isNextAvailable: isNextAvailable, next: next);
  }
}
