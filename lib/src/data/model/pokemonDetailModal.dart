class PokemonDetail {
  final int weight;
  final int id;
  final String name;
  final int height;
  final List<String> types;
  final List<Stats> stats;
 String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  PokemonDetail(
      {required this.weight,
      required this.id,
      required this.height,
      required this.types,
      required this.name,
      required this.stats});

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final stats =
        (json['stats'] as List).map((stat) => Stats.fromJson(stat)).toList();
    final types = (json['types'] as List)
        .map((e) => e['type']['name'] as String)
        .toList();
    return PokemonDetail(
        weight: json['weight'],
        id: json['id'],
        name: json['name'],
        height: json['height'],
        stats: stats,
        types: types);
  }
}

class Stats {
  int? baseStat;
  int? effort;
  Stat? stat;

  Stats({this.baseStat, this.effort, this.stat});

  Stats.fromJson(Map<String, dynamic> json) {
    baseStat = json['base_stat'];
    effort = json['effort'];
    stat = json['stat'] != null ? new Stat.fromJson(json['stat']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_stat'] = this.baseStat;
    data['effort'] = this.effort;
    if (this.stat != null) {
      data['stat'] = this.stat!.toJson();
    }
    return data;
  }
}

class Stat {
  String? name;
  String? url;

  Stat({this.name, this.url});

  Stat.fromJson(Map<String, dynamic> json) {
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
