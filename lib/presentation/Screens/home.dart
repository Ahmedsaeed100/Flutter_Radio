import 'package:audio_service_example/presentation/Screens/screens.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    const _brows = [
      Text("Countries"),
      Text("Gener"),
      Text("Language"),
      Text("Networks"),
    ];

    List<Widget> _browsView = [
      Browse(),
      Text("Gener"),
      Text("Language"),
      Text("Networks"),
    ];

    return DefaultTabController(
      length: _brows.length,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            color: Colors.green.withOpacity(0.1),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorWeight: 3.0,
              indicatorColor: Color(0xffff7722),
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.blueGrey,
              unselectedLabelStyle: TextStyle(fontSize: 16),
              labelPadding:
                  const EdgeInsets.only(bottom: 5, right: 10, left: 10),
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              tabs: _brows,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _browsView,
            ),
          ),
        ],
      ),
    );
  }
}
