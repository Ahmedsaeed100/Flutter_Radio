import 'package:audio_service_example/AudioFunctions/audio_functions.dart';
import 'package:audio_service_example/bloc/cubit/cubit/station_cubit.dart';
import 'package:audio_service_example/data/models/station.dart';
import 'package:audio_service_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Browse extends StatefulWidget {
  late final List<Stations> getAllCharacers;
  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  final _searchTextController = TextEditingController();
  late final Stations stations;
  late List<Stations> allStations;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StationCubit>(context).getAllStations();
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _searchTextController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: 'Find a Station',
          // border: InputBorder.,
          prefixIcon: Icon(Icons.search),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        onChanged: (searchedCharacter) {
          //  addSearchedForItemToSearchedList(searchedCharacter);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationCubit, StationState>(
      builder: (_, state) {
        if (state is StationsLoaded) {
          allStations = (state).stations;
          return Column(
            children: [
              _buildSearchField(),
              Expanded(
                child: StreamBuilder<QueueState>(
                    stream: audioHandler.queueState,
                    builder: (context, snapshot) {
                      final queueState = snapshot.data ?? QueueState.empty;
                      final queue = queueState.queue;
                      return ListView.builder(
                        itemCount: queue.length,
                        itemBuilder: (_, i) {
                          return Container(
                            color: Colors.grey[100],
                            margin: const EdgeInsets.symmetric(horizontal: 7),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: i == queueState.queueIndex
                                        ? Colors.blueAccent.withOpacity(0.1)
                                        : null,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (i != queueState.queueIndex) {
                                        audioHandler.skipToQueueItem(i);
                                        audioHandler.play();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child:
                                              queue[i].artUri.toString() != '1'
                                                  ? Image.network(
                                                      '${queue[i].artUri.toString()}',
                                                      fit: BoxFit.contain,
                                                      height: 70,
                                                      width: 70,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/NoRadioImage.jpg',
                                                      fit: BoxFit.contain,
                                                      height: 70,
                                                      width: 70,
                                                    ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 17),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    queue[i].title,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text("Rock, Hits ,Talk"),
                                                  Text("Egypt"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 0.7,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
