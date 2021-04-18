import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:mobx/mobx.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {
  @observable
  PokeAPI _pokeAPI;

  @observable
  Pokemon _currentPokemon;

  @observable
  Color pokemonColor;

  @observable
  int currentPosition;

  @computed
  PokeAPI get pokeAPI => _pokeAPI;

  @computed
  Pokemon get currentPokemon => _currentPokemon;

  @action
  fetchPokemonList() {
    _pokeAPI = null;
    loadPokeAPI().then((pokeList) {
      _pokeAPI = pokeList;
    });
  }

  Pokemon getPokemon({int index}) {
    return _pokeAPI.pokemon[index];
  }

  @action
  setCurrentPokemon({int index}) {
    _currentPokemon = _pokeAPI.pokemon[index];
    pokemonColor = ConstsApp.getColorType(type: _currentPokemon.type[0]);
    currentPosition = index;
  }

  @action
  Widget getImage({String numero}) {
    //Esse link de imagem vai até o 809, então ele não envolve a última geração (sword and shild)
    return CachedNetworkImage(
      placeholder: (context, url) => new Container(
        color: Colors.transparent,
      ),
      imageUrl:
          "https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$numero.png",
    );
  }

  Future<PokeAPI> loadPokeAPI() async {
    try {
      var url = Uri.parse(ConstsAPI.pokeapiURL);
      final response = await http.get(url);
      var decodeJson = jsonDecode(response.body);
      return PokeAPI.fromJson(decodeJson);
    } catch (error, stackTrace) {
      print("Erro ao carregar lista" + stackTrace.toString());
      return null;
    }
  }
}
