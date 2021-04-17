import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDatailPage extends StatefulWidget {
  final int index;

  PokeDatailPage({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  _PokeDatailPageState createState() => _PokeDatailPageState();
}

class _PokeDatailPageState extends State<PokeDatailPage> {
  PageController _pageController;
  Pokemon _pokemon;
  PokeApiStore _pokemonStore;
  MultiTrackTween _animation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokemonStore.currentPokemon;
    _animation = MultiTrackTween(
      [
        Track("rotation").add(
          Duration(seconds: 6),
          Tween(begin: 0.0, end: 6.3),
          curve: Curves.linear,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(
          builder: (BuildContext context) {
            return AppBar(
              title: Opacity(
                opacity: 0,
                child: Text(
                  _pokemon.name,
                  style: TextStyle(
                    fontFamily: "Google",
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ),
              elevation: 0,
              backgroundColor: _pokemonStore.pokemonColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Observer(builder: (context) {
            return Container(
              color: _pokemonStore.pokemonColor,
            );
          }),
          Container(
            height: MediaQuery.of(context).size.height / 3,
          ),
          SlidingSheet(
            elevation: 0,
            cornerRadius: 30,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.74, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _pokemonStore.setCurrentPokemon(index: index);
                },
                itemCount: _pokemonStore.pokeAPI.pokemon.length,
                itemBuilder: (BuildContext context, int index) {
                  Pokemon _pokeitem = _pokemonStore.getPokemon(index: index);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ControlledAnimation(
                        playback: Playback.LOOP,
                        duration: _animation.duration,
                        tween: _animation,
                        builder: (context, animation) {
                          return Transform.rotate(
                            angle: animation["rotation"],
                            child: Hero(
                              tag: index.toString(),
                              child: Opacity(
                                opacity: 0.2,
                                child: Image.asset(
                                  ConstsApp.whitePokeball,
                                  height: 270,
                                  width: 270,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Observer(builder: (context) {
                        return AnimatedPadding(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.bounceInOut,
                          padding: EdgeInsets.all(
                            index == _pokemonStore.currentPosition ? 0 : 60,
                          ),
                          child: CachedNetworkImage(
                            height: 160,
                            width: 160,
                            placeholder: (context, url) => new Container(
                              color: Colors.transparent,
                            ),
                            color: index == _pokemonStore.currentPosition
                                ? null
                                : Colors.black.withOpacity(0.5),
                            imageUrl:
                                "https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeitem.num}.png",
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
