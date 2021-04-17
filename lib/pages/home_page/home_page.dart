import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/pages/home_page/widgets/app_bar_home.dart';
import 'package:pokedex/pages/home_page/widgets/poke_item.dart';
import 'package:pokedex/pages/poke_detail_page/poke_detail_page.dart';
import 'package:pokedex/stores/pokeapi_store.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeApiStore _pokemonStore;

  @override
  void initState() {
    super.initState();
    _pokemonStore = GetIt.instance<PokeApiStore>();
    if (_pokemonStore.pokeAPI == null) {
      _pokemonStore.fetchPokemonList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: -(240 / 4.7),
            left: screenWidth - (240 / 1.6),
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                ConstsApp.blackPokeball,
                height: 240,
                width: 240,
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: statusHeight,
                ),
                AppBarHome(),
                Expanded(
                  child: Container(
                    child: Observer(
                      name: 'ListaHomePage',
                      builder: (BuildContext context) {
                        return (_pokemonStore.pokeAPI != null)
                            ? AnimationLimiter(
                                child: GridView.builder(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(12),
                                  addAutomaticKeepAlives: true,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount:
                                      _pokemonStore.pokeAPI.pokemon.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    Pokemon pokemon =
                                        _pokemonStore.getPokemon(index: i);
                                    return AnimationConfiguration.staggeredGrid(
                                      position: i,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        child: GestureDetector(
                                          child: PokeItem(
                                            types: pokemon.type,
                                            index: i,
                                            name: pokemon.name,
                                            num: pokemon.num,
                                          ),
                                          onTap: () {
                                            _pokemonStore.setCurrentPokemon(
                                              index: i,
                                            );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return PokeDatailPage(
                                                    index: i,
                                                  );
                                                },
                                                fullscreenDialog: true,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
