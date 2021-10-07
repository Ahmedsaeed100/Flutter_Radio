import 'package:audio_service/audio_service.dart';
import 'package:audio_service_example/AudioFunctions/audio_functions.dart';
import 'package:audio_service_example/main.dart';
import 'package:flutter/material.dart';

class ShowChannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: Icon(
                      Icons.reply,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  Icon(Icons.favorite, color: Colors.red[400]),
                  Icon(Icons.share, color: Colors.white70),
                ],
              ),
            ),
            // MediaItem display
            StreamBuilder<MediaItem?>(
              stream: audioHandler.mediaItem,
              builder: (context, snapshot) {
                //Make Repeat To List

                final mediaItem = snapshot.data;
                if (mediaItem == null) return const SizedBox();
                return Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
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

            // Playback controls
            ControlButtons(audioHandler),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(
                    Icons.volume_up_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: StreamBuilder<double>(
                      stream: audioHandler.volume,
                      builder: (context, snapshot) => Container(
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 1.5,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 7),
                          ),
                          child: Slider(
                            divisions: 150,
                            min: 0.0,
                            max: 1.0,
                            value: audioHandler.volume.value,
                            onChanged: audioHandler.setVolume,
                            activeColor: Colors.white,
                            thumbColor: Colors.blueAccent[100],
                            inactiveColor: Colors.grey,
                          ),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 10, bottom: 15),
                child: Text(
                  "Recent Played Stations",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

//                 // Playlist
            Expanded(
              child: StreamBuilder<QueueState>(
                stream: audioHandler.queueState,
                builder: (context, snapshot) {
                  final queueState = snapshot.data ?? QueueState.empty;
                  final queue = queueState.queue;

                  return ListView.builder(
                      itemCount: queue.length,
                      itemBuilder: (_, i) {
                        return InkWell(
                          onTap: () {
                            if (i != queueState.queueIndex) {
                              audioHandler.skipToQueueItem(i);
                              audioHandler.play();
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 65,
                                      width: 65,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: queue[i].artUri.toString() != '1'
                                          ? Image.network(
                                              '${queue[i].artUri}',
                                              fit: BoxFit.contain,
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
                                          horizontal: 17,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                queue[i].title,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Rock, Hits ,Talk",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Egypt",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 2,
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ],
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
              icon: const Icon(
                Icons.skip_previous,
                size: 35,
                color: Colors.white,
              ),
              onPressed:
                  queueState.hasPrevious ? audioHandler.skipToPrevious : null,
            );
          },
        ),
        StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, snapshot) {
            audioHandler.setRepeatMode(
              AudioServiceRepeatMode.all,
            );
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
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                iconSize: 64.0,
                onPressed: audioHandler.play,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.pause, color: Colors.white),
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
              icon: const Icon(
                Icons.skip_next,
                size: 35,
                color: Colors.white,
              ),
              onPressed: queueState.hasNext ? audioHandler.skipToNext : null,
            );
          },
        ),
      ],
    );
  }
}




// Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue, Colors.brown, Colors.black],
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 25),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(
//                             context,
//                           );
//                         },
//                         icon: Icon(
//                           Icons.reply,
//                           color: Colors.white,
//                           size: 35,
//                         ),
//                       ),
//                       Icon(Icons.favorite, color: Colors.red[400]),
//                       Icon(Icons.share, color: Colors.white70),
//                     ],
//                   ),
//                 ),
//                 // MediaItem display
//                 StreamBuilder<MediaItem?>(
//                   stream: audioHandler.mediaItem,
//                   builder: (context, snapshot) {
//                     //Make Repeat To List

//                     final mediaItem = snapshot.data;
//                     if (mediaItem == null) return const SizedBox();
//                     return Column(
//                       //crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         if (mediaItem.artUri != null)
//                           Container(
//                             margin: const EdgeInsets.only(top: 30, bottom: 20),
//                             padding: const EdgeInsets.only(top: 10),
//                             child: Center(
//                               child: Container(
//                                 height: 100,
//                                 width: 100,
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Image.network(
//                                   '${mediaItem.artUri!}',
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         Text(
//                           mediaItem.title,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 25,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           mediaItem.album ?? '',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     );
//                   },
//                 ),

//                 // Playback controls
//                 ControlButtons(audioHandler),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.volume_up_rounded,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                       Expanded(
//                         child: StreamBuilder<double>(
//                           stream: audioHandler.volume,
//                           builder: (context, snapshot) => Container(
//                             child: Column(
//                               children: [
//                                 Slider(
//                                   divisions: 50,
//                                   min: 0.0,
//                                   max: 1.0,
//                                   value: audioHandler.volume.value,
//                                   onChanged: audioHandler.setVolume,
//                                   activeColor: Colors.white,
//                                   thumbColor: Colors.blueAccent[100],
//                                   inactiveColor: Colors.grey,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // A seek bar.

//                 const SizedBox(height: 10.0),
//                 // Repeat/shuffle controls
//                 Container(
//                   margin: EdgeInsets.only(top: 20, bottom: 20),
//                   child: Text(
//                     "Recent Played Stations",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 // Playlist
//                 Container(
//                   height: 240.0,
//                   child: StreamBuilder<QueueState>(
//                     stream: audioHandler.queueState,
//                     builder: (context, snapshot) {
//                       final queueState = snapshot.data ?? QueueState.empty;
//                       final queue = queueState.queue;
//                       return ListView.builder(
//                           itemCount: queue.length,
//                           itemBuilder: (_, i) {
//                             return Material(
//                               color: i == queueState.queueIndex
//                                   ? Colors.grey.shade300
//                                   : null,
//                               child: ListTile(
//                                 title: Text(
//                                   queue[i].title,
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 29,
//                                   ),
//                                 ),
//                                 onTap: () => audioHandler.skipToQueueItem(i),
//                               ),
//                             );
//                           });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );