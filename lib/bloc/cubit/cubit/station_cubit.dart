import 'package:audio_service_example/data/models/station.dart';
import 'package:audio_service_example/data/repository/station_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'station_state.dart';

class StationCubit extends Cubit<StationState> {
  final StationsRepository stationsRepository;
  List<Stations> stations = [];
  StationCubit(this.stationsRepository) : super(StationCubitInitial());

  List<Stations> getAllStations() {
    stationsRepository.getAllStations().then((s) {
      emit(StationsLoaded(s));
      this.stations = stations;
      //print('$stations sssss');
    });
    return stations;
  }
}
