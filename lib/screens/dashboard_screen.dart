import 'package:flutter/material.dart';
import 'package:web_dashboard_app_tut/screens/home.dart';
import 'package:web_dashboard_app_tut/screens/profile.dart';
import 'package:web_dashboard_app_tut/screens/rapports.dart';
import 'package:web_dashboard_app_tut/screens/settings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //setting the expansion function for the navigation rail
  bool isExpanded = true;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Let's start by adding the Navigation Rail
          Container(
            child: NavigationRail(
                leading: Container(
                  color: Colors.white,
                  width: 240,
                  height: 80,
                  child: Text("Profile"),
                ),
                extended: isExpanded,
                backgroundColor: Colors.green,
                unselectedIconTheme:
                    IconThemeData(color: Colors.white, opacity: 1),
                unselectedLabelTextStyle: TextStyle(
                  color: Colors.white,
                ),
                selectedIconTheme:
                    IconThemeData(color: Colors.deepPurple.shade900),
                onDestinationSelected: (value) {
                  setState(() {
                    index = value;
                  });
                },
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text("Home"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.bar_chart),
                    label: Text("Rapports"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text("Profile"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text("Settings"),
                  ),
                ],
                selectedIndex: index),
          ),
          index == 0
              ? Home()
              : index == 1
                  ? Raports()
                  : index == 2
                      ? Profile()
                      : Setting()
        ],
      ),
    );
  }
}
