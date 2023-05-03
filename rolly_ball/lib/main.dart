import 'package:flutter/material.dart';
import 'package:rolly_ball/custom_painters.dart';
import 'package:rolly_ball/extensions.dart';
import 'dart:math' as math show pi;

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
  // late double _shift;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OuterCircle(.3),
      child: SizedBox(
        height: context.height,
        width: context.width,
        child: MouseRegion(
          child: CustomPaint(
            painter: InnerCircle(),
          ),
        ),
      ),
    );
  }
}
