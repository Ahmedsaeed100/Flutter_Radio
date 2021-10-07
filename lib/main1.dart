// ignore_for_file: public_member_api_docs

// This example demonstrates a playlist with repeat/shuffle functionality.
//
// To run this example, use:
//
// flutter run -t lib/example_playlist.dart

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'AudioFunctions/audio_functions.dart';

// You might want to provide this using dependency injection rather than a
// global variable.
late AudioPlayerHandler _audioHandler;

Future<void> main() async {
  _audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(MyApp());
}

/// The app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audio Service Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

/// The main screen.
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SizedBox(
        height: 60,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.black38,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),

          //color: Color.fromRGBO(40, 143, 235, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<MediaItem?>(
                  stream: _audioHandler.mediaItem,
                  builder: (context, snapshot) {
                    final mediaItem = snapshot.data;
                    if (mediaItem == null) return const SizedBox();

                    return Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                '${mediaItem.artUri!}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                mediaItem.title,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                mediaItem.album!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              StreamBuilder<PlaybackState>(
                stream: _audioHandler.playbackState,
                builder: (context, snapshot) {
                  final playbackState = snapshot.data;
                  final processingState = playbackState?.processingState;
                  final playing = playbackState?.playing;
                  if (processingState == AudioProcessingState.loading ||
                      processingState == AudioProcessingState.buffering) {
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 15),
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                          ),
                        ),
                      ],
                    );
                  } else if (playing != true) {
                    return IconButton(
                      icon: Icon(Icons.play_arrow,
                          color: Colors.black.withOpacity(0.8)),
                      iconSize: 50.0,
                      onPressed: _audioHandler.play,
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.pause,
                          color: Colors.black.withOpacity(0.8)),
                      iconSize: 50.0,
                      onPressed: _audioHandler.pause,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.brown, Colors.black],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            children: [
              // MediaItem display
              Expanded(
                child: StreamBuilder<MediaItem?>(
                  stream: _audioHandler.mediaItem,
                  builder: (context, snapshot) {
                    //Make Repeat To List
                    _audioHandler.setRepeatMode(
                      AudioServiceRepeatMode.all,
                    );
                    final mediaItem = snapshot.data;
                    if (mediaItem == null) return const SizedBox();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (mediaItem.artUri != null)
                          Container(
                            margin: const EdgeInsets.only(top: 30, bottom: 20),
                            padding: const EdgeInsets.only(top: 10),
                            child: Center(
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.network(
                                  '${mediaItem.artUri!}',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        Text(
                          mediaItem.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          mediaItem.album ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Playback controls
              ControlButtons(_audioHandler),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Icon(
                      Icons.volume_up_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: StreamBuilder<double>(
                        stream: _audioHandler.volume,
                        builder: (context, snapshot) => Container(
                          child: Column(
                            children: [
                              Slider(
                                divisions: 50,
                                min: 0.0,
                                max: 1.0,
                                value: _audioHandler.volume.value,
                                onChanged: _audioHandler.setVolume,
                                activeColor: Colors.white,
                                thumbColor: Colors.blueAccent[100],
                                inactiveColor: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // A seek bar.

              const SizedBox(height: 10.0),
              // Repeat/shuffle controls
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  "Recent Played Stations",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              // Playlist
              Container(
                height: 240.0,
                child: StreamBuilder<QueueState>(
                  stream: _audioHandler.queueState,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data ?? QueueState.empty;
                    final queue = queueState.queue;
                    return ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) newIndex--;
                        _audioHandler.moveQueueItem(oldIndex, newIndex);
                      },
                      children: [
                        for (var i = 0; i < queue.length; i++)
                          Dismissible(
                            key: ValueKey(queue[i].id),
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            onDismissed: (dismissDirection) {
                              _audioHandler.removeQueueItemAt(i);
                            },
                            child: Material(
                              color: i == queueState.queueIndex
                                  ? Colors.grey.shade300
                                  : null,
                              child: ListTile(
                                title: Text(queue[i].title),
                                onTap: () => _audioHandler.skipToQueueItem(i),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayerHandler audioHandler;

  ControlButtons(this.audioHandler);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<QueueState>(
          stream: audioHandler.queueState,
          builder: (context, snapshot) {
            final queueState = snapshot.data ?? QueueState.empty;
            return IconButton(
              icon: const Icon(Icons.skip_previous, size: 35),
              onPressed:
                  queueState.hasPrevious ? audioHandler.skipToPrevious : null,
            );
          },
        ),
        StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, snapshot) {
            final playbackState = snapshot.data;
            final processingState = playbackState?.processingState;
            final playing = playbackState?.playing;
            if (processingState == AudioProcessingState.loading ||
                processingState == AudioProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: audioHandler.play,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: audioHandler.pause,
              );
            }
          },
        ),
        StreamBuilder<QueueState>(
          stream: audioHandler.queueState,
          builder: (context, snapshot) {
            final queueState = snapshot.data ?? QueueState.empty;
            return IconButton(
              icon: const Icon(Icons.skip_next, size: 35),
              onPressed: queueState.hasNext ? audioHandler.skipToNext : null,
            );
          },
        ),
      ],
    );
  }
}
