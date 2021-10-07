import 'package:audio_service_example/data/models/station.dart';
import 'package:audio_service_example/data/web_services/loadFirebaseStations.dart';

class StationsRepository {
  final StationsWebServices stationsWebServices;

  StationsRepository(this.stationsWebServices);

  Future<List<Stations>> getAllStations() async {
    try {
      final stations = await stationsWebServices.getAllStations();

      return stations.map((station) => Stations.fromJson(station)).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
