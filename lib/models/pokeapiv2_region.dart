class PokeAPIV2 {
  List<BaseTypeNameUrl> abilities;
  int id;
  BaseTypeNameUrl mainRegion;
  List<BaseTypeNameUrl> moves;
  String name;
  List<Names> names;
  List<BaseTypeNameUrl> pokemonSpecies;
  List<BaseTypeNameUrl> types;
  List<BaseTypeNameUrl> versionGroups;

  PokeAPIV2(
      {this.abilities,
      this.id,
      this.mainRegion,
      this.moves,
      this.name,
      this.names,
      this.pokemonSpecies,
      this.types,
      this.versionGroups});

  PokeAPIV2.fromJson(Map<String, dynamic> json) {
    if (json['abilities'] != null) {
      List<BaseTypeNameUrl> abilities = [];
      json['abilities'].forEach((v) {
        abilities.add(new BaseTypeNameUrl.fromJson(v));
      });
    }
    id = json['id'];
    mainRegion = json['main_region'] != null
        ? new BaseTypeNameUrl.fromJson(json['main_region'])
        : null;
    if (json['moves'] != null) {
      List<BaseTypeNameUrl> moves = [];
      json['moves'].forEach((v) {
        moves.add(new BaseTypeNameUrl.fromJson(v));
      });
    }
    name = json['name'];
    if (json['names'] != null) {
      List<Names> names = [];
      json['names'].forEach((v) {
        names.add(new Names.fromJson(v));
      });
    }
    if (json['pokemon_species'] != null) {
      List<BaseTypeNameUrl> pokemonSpecies = [];
      json['pokemon_species'].forEach((v) {
        pokemonSpecies.add(new BaseTypeNameUrl.fromJson(v));
      });
    }
    if (json['types'] != null) {
      List<BaseTypeNameUrl> types = [];
      json['types'].forEach((v) {
        types.add(new BaseTypeNameUrl.fromJson(v));
      });
    }
    if (json['version_groups'] != null) {
      List<BaseTypeNameUrl> versionGroups = [];
      json['version_groups'].forEach((v) {
        versionGroups.add(new BaseTypeNameUrl.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abilities != null) {
      data['abilities'] = this.abilities.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    if (this.mainRegion != null) {
      data['main_region'] = this.mainRegion.toJson();
    }
    if (this.moves != null) {
      data['moves'] = this.moves.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    if (this.names != null) {
      data['names'] = this.names.map((v) => v.toJson()).toList();
    }
    if (this.pokemonSpecies != null) {
      data['pokemon_species'] =
          this.pokemonSpecies.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['types'] = this.types.map((v) => v.toJson()).toList();
    }
    if (this.versionGroups != null) {
      data['version_groups'] =
          this.versionGroups.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BaseTypeNameUrl {
  String name;
  String url;

  BaseTypeNameUrl({this.name, this.url});

  BaseTypeNameUrl.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Names {
  BaseTypeNameUrl language;
  String name;

  Names({this.language, this.name});

  Names.fromJson(Map<String, dynamic> json) {
    language = json['language'] != null
        ? new BaseTypeNameUrl.fromJson(json['language'])
        : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.language != null) {
      data['language'] = this.language.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}
