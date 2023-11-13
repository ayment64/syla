class StateCities {
  List<String>? cities;

  StateCities({this.cities});

  StateCities.fromJson(Map<String, dynamic> json, String cityName) {
    cities = json[cityName].cast<String>();
  }
}
