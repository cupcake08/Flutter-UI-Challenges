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
        appBar: AppBar(
          title: const Text("Rolly Ball"),
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.black,
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: OuterCircle(.3),
          size: context.screenSize,
        ),
        MouseRegion(
          // onHorizontalDragStart: (details) {
          //   "Horizontal start".log();
          // },
          // onVerticalDragStart: (details) {
          //   "vertical".log();
          // },
          onEnter: (event) {
            "enter".log();
          },
          child: CustomPaint(
            foregroundPainter: InnerCircle(),
            size: context.screenSize / 2,
          ),
        ),
      ],
    );
    // return CustomPaint(
    //   painter: OuterCircle(.3),
    //   foregroundPainter: InnerCircle(),
    //   size: context.screenSize,
    // );
  }
}
