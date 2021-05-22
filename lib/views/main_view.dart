import 'package:flutter/material.dart';

import 'account_view.dart';
import 'goals_view.dart';
import 'home_view.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MainView> {
  final double iconSize = 29.0;
  final double activeIconSize = 32.0;
  int _currentPage = 0;

  void _updatePage(int page) {
    if (_currentPage == page) return;

    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentPage,
            children: [
              HomeView(),
              HomeView(),
              GoalsView(),
              AccountView(),
            ],
          )),
      bottomNavigationBar: Container(
        height: 60.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildNavigationElement(
              "Home",
              Icons.house_outlined,
              _currentPage == 0 ? activeIconSize : iconSize,
                  () => {_updatePage(0)},
              _currentPage == 0 ? Colors.black87 : Colors.black54,
            ),
            buildNavigationElement(
              "Timer",
              Icons.timer_outlined,
              _currentPage == 1 ? activeIconSize : iconSize,
                  () => {_updatePage(1)},
              _currentPage == 1 ? Colors.black87 : Colors.black54,
            ),
            buildNavigationElement(
              "Logs",
              Icons.calendar_today_outlined,
              _currentPage == 2 ? activeIconSize : iconSize,
                  () => {_updatePage(2)},
              _currentPage == 2 ? Colors.black87 : Colors.black54,
            ),
            buildNavigationElement(
              "Account",
              Icons.account_circle_outlined,
              _currentPage == 3 ? activeIconSize : iconSize,
                  () => {_updatePage(3)},
              _currentPage == 3 ? Colors.black87 : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

IconButton buildNavigationElement(String text, IconData iconData, double size,
    Function()? onPressed, Color color) {
  return IconButton(
    onPressed: onPressed,
    icon: Icon(
      iconData,
      size: size,
      color: color,
    ),
    tooltip: text,
  );
}

