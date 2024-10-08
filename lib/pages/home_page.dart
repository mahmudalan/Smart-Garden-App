import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lock_system_garden/pages/soil_moisture_page.dart';
import 'package:lock_system_garden/pages/temperature_page.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import 'humidity_page.dart';
import 'lock_page.dart';
import 'navbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    Color blue = const Color(0xff008DDA);
    Color cyan = const Color(0xff41C9E2);
    Color teal = const Color(0xffACE2E1);
    Color cream = const Color(0xffF7EEDD);
    return Scaffold(
      backgroundColor: cream,
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: blue),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.search))],
        backgroundColor: teal,
        title: Center(
          child: Text(
            'Lock System Garden',
            style: TextStyle(
              fontFamily: 'Queensides',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: blue
            ),
          )
        )
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _listOfWidget,
            ),
          ),
        ],
      ),
      bottomNavigationBar:
           SlidingClippedNavBar.colorful(
              backgroundColor: teal,
              onButtonPressed: onButtonPressed,
              iconSize: 30,
              selectedIndex: selectedIndex,
              barItems: <BarItem>[
                BarItem(
                  icon: Ionicons.finger_print,
                  title: 'Door',
                  activeColor: Colors.white,
                  inactiveColor: blue,
                ),
                BarItem(
                  icon:  Ionicons.thermometer_outline,
                  title: 'Temperature',
                  activeColor: Colors.white,
                  inactiveColor: blue,
                ),
                BarItem(
                  icon: Icons.water_drop_outlined,
                  title: 'Humidity',
                  activeColor: Colors.white,
                  inactiveColor: blue,
                ),
                BarItem(
                  icon: Icons.water,
                  title: 'Moisture',
                  activeColor: Colors.white ,
                  inactiveColor: blue,
                ),
              ],
            )
    );
  }
}

// icon size:24 for fontAwesomeIcons
// icons size: 30 for MaterialIcons

List<Widget> _listOfWidget = <Widget>[
  const Lock(),
  const Temperature(),
  const Humidity(),
  const Soil()
];
