import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

extension Log on Object {
  void log() {
    dev.log(toString());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              _header(),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  fontSize: 20,
                ),
                tabs: const [
                  Tab(
                    text: "Breakfast",
                  ),
                  Tab(
                    text: "Lunch",
                  ),
                  Tab(
                    text: "Snacks",
                  ),
                  Tab(
                    text: "Dinner",
                  ),
                  // Tab(
                  //   child: Text(
                  //     'Lunch',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Tab(
                  //   child: Text(
                  //     'Snacks',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Tab(
                  //   child: Text(
                  //     'Dinner',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _header() {
    final child = Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(137, 43, 41, 41),
      ),
      height: 40,
      width: 50,
    );
    return Row(
      children: [
        Expanded(child: child),
        child,
      ],
    );
  }
}
