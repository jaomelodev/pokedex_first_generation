import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/pages/about_page/about_page.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';
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
  PokeApiStore _pokemonStore;
  PokeApiV2Store _pokeApiV2Store;
  MultiTrackTween _animation;
  double _progress;
  double _multiple;
  double _opacity;
  double _opacityTitleAppBar;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.index, viewportFraction: 0.5);
    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
    _pokeApiV2Store.getInfoPokemon(_pokemonStore.currentPokemon.name);
    _pokeApiV2Store.getInfoSpecie(_pokemonStore.currentPokemon.id.toString());
    _animation = MultiTrackTween(
      [
        Track("rotation").add(
          Duration(seconds: 6),
          Tween(begin: 0.0, end: 6.3),
          curve: Curves.linear,
        ),
      ],
    );
    _progress = 0;
    _multiple = 1;
    _opacity = 1;
    _opacityTitleAppBar = 0;
  }

  double interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Observer(builder: (context) {
            return AnimatedContainer(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _pokemonStore.pokemonColor.withOpacity(0.7),
                    _pokemonStore.pokemonColor,
                  ],
                ),
              ),
              duration: Duration(milliseconds: 300),
              child: Stack(
                children: [
                  AppBar(
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ControlledAnimation(
                              playback: Playback.LOOP,
                              duration: _animation.duration,
                              tween: _animation,
                              builder: (context, animation) {
                                return Transform.rotate(
                                  angle: animation["rotation"],
                                  child: Opacity(
                                    opacity:
                                        _opacityTitleAppBar >= 0.2 ? 0.2 : 0.0,
                                    child: Image.asset(
                                      ConstsApp.whitePokeball,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite_border),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12 -
                        _progress *
                            (MediaQuery.of(context).size.height * 0.071),
                    left: 20 +
                        _progress *
                            (MediaQuery.of(context).size.height * 0.071),
                    child: Text(
                      _pokemonStore.currentPokemon.name,
                      style: TextStyle(
                        fontFamily: 'Google',
                        fontSize: 38 -
                            _progress *
                                (MediaQuery.of(context).size.height * 0.011),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: (MediaQuery.of(context).size.height * 0.16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            setTipos(_pokemonStore.currentPokemon.type),
                            Text(
                              '#' + _pokemonStore.currentPokemon.num.toString(),
                              style: TextStyle(
                                fontFamily: 'Google',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SlidingSheet(
            listener: (state) {
              setState(() {
                _progress = state.progress;
                _multiple = 1 - interval(0.0, 0.87, _progress);
                _opacity = _multiple;
                _opacityTitleAppBar =
                    _multiple = interval(0.55, 0.87, _progress);
              });
            },
            elevation: 0,
            cornerRadius: 30,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.60, 0.87],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height * 0.12,
                child: AboutPage(),
              );
            },
          ),
          Opacity(
            opacity: _opacity,
            child: Padding(
              padding: EdgeInsets.only(
                  top: _opacityTitleAppBar == 1
                      ? 1000
                      : (MediaQuery.of(context).size.height * 0.25) -
                          _progress * 50),
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    _pokemonStore.setCurrentPokemon(index: index);
                    _pokeApiV2Store
                        .getInfoPokemon(_pokemonStore.currentPokemon.name);
                    _pokeApiV2Store.getInfoSpecie(
                        _pokemonStore.currentPokemon.id.toString());
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
                              child: AnimatedOpacity(
                                opacity: index == _pokemonStore.currentPosition
                                    ? 0.2
                                    : 0, //_pokeitem.name + 'rotatition',
                                duration: Duration(milliseconds: 200),
                                child: Image.asset(
                                  ConstsApp.whitePokeball,
                                  height: 270,
                                  width: 270,
                                ),
                              ),
                            );
                          },
                        ),
                        IgnorePointer(
                          child: Observer(
                            name: 'Pokemon',
                            builder: (context) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  AnimatedPadding(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn,
                                    padding: EdgeInsets.only(
                                      top:
                                          index == _pokemonStore.currentPosition
                                              ? 0
                                              : 60,
                                      bottom:
                                          index == _pokemonStore.currentPosition
                                              ? 0
                                              : 60,
                                    ),
                                    child: Hero(
                                      tag:
                                          index == _pokemonStore.currentPosition
                                              ? _pokeitem.name
                                              : 'none' + index.toString(),
                                      child: CachedNetworkImage(
                                        height: 150,
                                        width: 150,
                                        placeholder: (context, url) =>
                                            new Container(
                                          color: Colors.transparent,
                                        ),
                                        color: index ==
                                                _pokemonStore.currentPosition
                                            ? null
                                            : Colors.black.withOpacity(0.5),
                                        imageUrl:
                                            "https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeitem.num}.png",
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setTipos(List<String> types) {
    List<Widget> lista = [];
    types.forEach((nome) {
      lista.add(
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(80, 255, 255, 255)),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  nome.trim(),
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            )
          ],
        ),
      );
    });
    return Row(
      children: lista,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
