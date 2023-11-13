class CountryStates {
  List<States>? states;

  CountryStates({this.states});

  CountryStates.fromJson(Map<String, dynamic> json, String countryName) {
    if (json[countryName] != null) {
      states = <States>[];
      json[countryName].forEach((v) {
        states!.add(States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (states != null) {
      data['states'] = states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  String? name;
  String? abbreviation;

  States({this.name, this.abbreviation});

  States.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    abbreviation = json['abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['abbreviation'] = abbreviation;
    return data;
  }
}
