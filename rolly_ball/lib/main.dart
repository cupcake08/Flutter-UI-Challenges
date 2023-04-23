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
  late double _shift;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OuterCircle(_shift),
      child: MouseRegion(
        onHover: (event) {
          // final x = event.localPosition.dx;
          // final y = event.localPosition.dy;
          // "x: $x, y: $y".log();
          // final w = context.width;
          // final h = context.height;
          // final center = Offset(w / 2, h / 2);
          // final dx = x - center.dx;
          // final dy = y - center.dy;
          // final angle = math.atan2(dy, dx);
          // final shift = angle / (2 * math.pi);
          // "angle: $angle, shift: $shift".log();
          // setState(() {
          //   _shift = shift;
          // });
        },
        child: SizedBox(
          height: context.height,
          width: context.width,
          child: CustomPaint(
            painter: InnerCircle(),
          ),
        ),
      ),
    );
  }
}
