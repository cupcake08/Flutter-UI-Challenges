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
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> shift = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listener);
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
          width: context.width / 2,
          child: ClipPath(
            clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.height / 2))),
            child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              itemExtent: 50,
              squeeze: 1.2,
              diameterRatio: .8,
              physics: const BouncingScrollPhysics(),
              childDelegate: ListWheelInfiniteDelegate(
                childCount: 15,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.width / 2),
                    color: Colors.red,
                  ),
                ),
              ),
            ),
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

class ListWheelInfiniteDelegate extends ListWheelChildDelegate {
  /// Constructs the delegate from a builder callback.
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

// class CircleClipper extends CustomClipper
// class CircleClipper extends CliP
