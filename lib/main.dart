import 'package:audio_service/audio_service.dart';
import 'package:audio_service_example/AudioFunctions/audio_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/cubit/cubit/station_cubit.dart';
import 'data/repository/station_repository.dart';
import 'data/web_services/loadFirebaseStations.dart';
import 'presentation/Screens/screens.dart';
import 'presentation/Widgets/bottom_sheet.dart';

late AudioPlayerHandler audioHandler;
Future<void> main() async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COC Radio',
      home: BlocProvider(
        create: (context) =>
            StationCubit(StationsRepository(StationsWebServices())),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color primaryColor = Colors.blueGrey;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const homeTabs = [
      Tab(
        text: "RECOMMENDED",
      ),
      Tab(
        text: "BROWSE",
      ),
      Tab(
        text: "FAVORITES",
      ),
      Tab(
        text: "RECENT",
      ),
    ];
    var homebarViews = [
      Browse(),
      Home(),
      Text("Tab 3"),
      Text("Tab 4"),
    ];
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomSheet: Bottomsheet(size: size),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              snap: true,
              floating: true,
              pinned: true,
              backgroundColor: primaryColor,
              title: Text(
                'COC Radio',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 5.0,
                onTap: (index) {
                  setState(() {
                    switch (index) {
                      case 0:
                        primaryColor = Color(0xff2e4922);
                        break;
                      case 1:
                        primaryColor = Color(0xff044c8e);
                        break;
                      case 2:
                        primaryColor = Color(0xff311f02);
                        break;
                      case 3:
                        primaryColor = Color(0xff3e3e3e);
                        break;

                      default:
                    }
                  });
                },
                tabs: homeTabs,
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: homebarViews,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
