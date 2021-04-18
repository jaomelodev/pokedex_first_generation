import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';

class EvolutionTab extends StatelessWidget {
  final PokeApiV2Store _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
  final PokeApiStore _pokemonStore = GetIt.instance<PokeApiStore>();

  Widget resizePokemon(Widget widget) {
    return SizedBox(
      height: 80,
      width: 80,
      child: widget,
    );
  }

  List<Widget> getEvolution(Pokemon pokemon) {
    List<Widget> _list = [];
    if (pokemon.prevEvolution != null) {
      pokemon.prevEvolution.forEach((element) {
        _list.add(
          resizePokemon(
            _pokemonStore.getImage(numero: element.num),
          ),
        );
        _list.add(
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: Text(
              element.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        _list.add(Icon(Icons.keyboard_arrow_down));
      });
    }

    _list.add(resizePokemon(_pokemonStore.getImage(numero: pokemon.num)));
    _list.add(
      Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
        ),
        child: Text(
          pokemon.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (pokemon.nextEvolution != null) {
      pokemon.nextEvolution.forEach((element) {
        _list.add(Icon(Icons.keyboard_arrow_down));
        _list.add(resizePokemon(_pokemonStore.getImage(numero: element.num)));
        _list.add(
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: Text(
              element.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      });
    }

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Observer(builder: (context) {
          Pokemon pokemon = _pokemonStore.currentPokemon;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: getEvolution(pokemon),
            ),
          );
        }),
      ),
    );
  }
}
