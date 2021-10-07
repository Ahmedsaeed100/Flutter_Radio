import 'package:audio_service/audio_service.dart';
import 'package:audio_service_example/AudioFunctions/audio_functions.dart';
import 'package:audio_service_example/presentation/Screens/screens.dart';
import 'package:flutter/material.dart';

class Bottomsheet extends StatelessWidget {
  const Bottomsheet({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowChannel(),
          ),
        );
      },
      child: SizedBox(
        height: size.height * 0.09,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.grey,
                width: size.width * 0.003,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.height * 0.020),
                topRight: Radius.circular(size.height * 0.020),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<MediaItem?>(
                  stream: audioHandler.mediaItem,
                  builder: (context, snapshot) {
                    final mediaItem = snapshot.data;
                    if (mediaItem == null) return const SizedBox();

                    return Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.17,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.020,
                              vertical: size.width * 0.020,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              child: Image.network(
                                '${mediaItem.artUri!}',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.46,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  mediaItem.title,
                                  style: TextStyle(
                                    fontSize: size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                'Song Name by Metadata ICY Song Name by Metadata ICY Song Name by Metadata ICY',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: size.width * 0.027,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        //    SizedBox(width: size.height * 0.01),
                      ],
                    );
                  }),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QueueState>(
                    stream: audioHandler.queueState,
                    builder: (context, snapshot) {
                      final queueState = snapshot.data ?? QueueState.empty;
                      return IconButton(
                        icon:
                            Icon(Icons.skip_previous, size: size.width * 0.07),
                        onPressed: queueState.hasPrevious
                            ? audioHandler.skipToPrevious
                            : null,
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
                          width: size.width * 0.09,
                          height: size.width * 0.09,
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                          ),
                        );
                      } else if (playing != true) {
                        return IconButton(
                          icon: const Icon(Icons.play_arrow),
                          iconSize: size.width * 0.09,
                          onPressed: audioHandler.play,
                        );
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.pause),
                          iconSize: size.width * 0.09,
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
                        icon: Icon(Icons.skip_next, size: size.width * 0.07),
                        onPressed:
                            queueState.hasNext ? audioHandler.skipToNext : null,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
