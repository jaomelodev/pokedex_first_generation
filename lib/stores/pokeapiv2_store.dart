import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/models/pokeapiv2.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/specie.dart';
part 'pokeapiv2_store.g.dart';

class PokeApiV2Store = _PokeApiV2StoreBase with _$PokeApiV2Store;

abstract class _PokeApiV2StoreBase with Store {
  @observable
  Specie specie;

  @observable
  PokeApiV2 pokeApiV2;

  @action
  Future<void> getInfoPokemon(String name) async {
    try {
      var url = Uri.parse(ConstsAPI.pokeapiv2URL + name.toLowerCase());
      final response = await http.get(url);
      var decodeJson = jsonDecode(response.body);
      pokeApiV2 = PokeApiV2.fromJson(decodeJson);
    } catch (error, stackTrace) {
      print("Erro ao carregar info pokemon" + stackTrace.toString());
      return null;
    }
  }

  @action
  Future<void> getInfoSpecie(String numPokemon) async {
    try {
      specie = null;
      var url = Uri.parse(ConstsAPI.pokeapiv2EspeciesURL + numPokemon);
      final response = await http.get(url);
      var decodeJson = jsonDecode(response.body);
      specie = Specie.fromJson(decodeJson);
    } catch (error, stackTrace) {
      print("Erro ao carregar specie" + stackTrace.toString());
      return null;
    }
  }
}
