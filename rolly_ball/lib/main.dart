import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rolly_ball/custom_painters.dart';
import 'package:rolly_ball/extensions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Rolly Ball"),
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> shift = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // timer is there just to demo purpose.
      Timer(const Duration(milliseconds: 1000), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent * .6,
          duration: const Duration(milliseconds: 1800),
          curve: Curves.ease,
        );
      });
    });
  }

  _listener() {
    if (_scrollController.hasClients) {
      final percent = _scrollController.position.pixels / _scrollController.position.maxScrollExtent;
      shift.value = percent.clamp(0.0, 1.0);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: OuterCircle(shift),
          size: context.screenSize,
        ),
        SizedBox(
          height: context.height / 3,
          width: context.width / 2.5,
          child: ListWheelScrollView.useDelegate(
            controller: _scrollController,
            itemExtent: 50,
            squeeze: 1.3,
            perspective: .005,
            diameterRatio: 1,
            physics: const BouncingScrollPhysics(),
            childDelegate: ListWheelInfiniteDelegate(
              childCount: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ListWheelInfiniteDelegate extends ListWheelChildDelegate {
  ListWheelInfiniteDelegate({
    required this.child,
    required this.childCount,
  });

  final int childCount;
  final Widget child;

  @override
  int? get estimatedChildCount => childCount;

  @override
  Widget? build(BuildContext context, int index) {
    return IndexedSemantics(index: index, child: child);
  }

  @override
  bool shouldRebuild(covariant ListWheelInfiniteDelegate oldDelegate) {
    return child != oldDelegate.child || childCount != oldDelegate.childCount;
  }
}
