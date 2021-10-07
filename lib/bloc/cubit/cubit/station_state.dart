part of 'station_cubit.dart';

@immutable
abstract class StationState {}

class StationCubitInitial extends StationState {}

class StationsLoaded extends StationState {
  final List<Stations> stations;

  StationsLoaded(this.stations);
}
