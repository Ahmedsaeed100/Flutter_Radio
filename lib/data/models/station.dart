class Stations {
  late String stationID;
  late String stationNameLocal;
  late String stationNameEN;
  late String stationImg;
  late String streemUrl;
  late String stationWebsite;
  late List<dynamic> gener;
  late String language;
  late String languageID;
  late String stationGenerID;
  late String network;
  late String networkID;
  late String country;
  late String countryID;

  Stations.fromJson(Map<String, dynamic> json) {
    stationID = json['StationID'];
    stationNameLocal = json['StationName_Local'];
    stationNameEN = json['stationName_EN'];
    stationImg = json['StationImg'];
    streemUrl = json['streemUrl'];
    stationWebsite = json['StationWebsite'];
    stationGenerID = json['StationGenerID'];
    languageID = json['languageID'];
    networkID = json['networkID'];
    countryID = json['countryID'];
  }
}
