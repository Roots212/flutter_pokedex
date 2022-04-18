import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedox_flutter/src/data/model/pokemonDetailModal.dart';
import 'package:pokedox_flutter/src/data/model/pokemonResponseModal.dart';

class PokemonRepository {
  final baseUrl = 'pokeapi.co';
  final client = http.Client();

  Future<PokemonList?> getPokemons(int index) async {
    final queryParameters = {'limit': '20', 'offset': (index * 20).toString()};

    final uri = Uri.https(baseUrl, '/api/v2/pokemon', queryParameters);

    try {
      final resposne = await client.get(uri);
      final json = jsonDecode(resposne.body);

      return PokemonList.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<PokemonDetail?> getPokemonDetails(int pokeId) async {
    final uri = Uri.https(baseUrl, '/api/v2/pokemon/$pokeId');

    try {
      final resposne = await client.get(uri);
      final json = jsonDecode(resposne.body);
      return PokemonDetail.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
