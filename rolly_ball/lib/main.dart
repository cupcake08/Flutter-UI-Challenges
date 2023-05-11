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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listener);
  }

  _listener() {
    if (_scrollController.hasClients) {
      _scrollController.position.pixels.log();
      _scrollController.position.maxScrollExtent.log();
      if (_scrollController.position.pixels > 2000.0) {}
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
          painter: OuterCircle(.3),
          size: context.screenSize,
        ),
        SizedBox(
          height: context.height / 3,
          width: context.width / 2,
          child: ListWheelScrollView.useDelegate(
            controller: _scrollController,
            itemExtent: 50,
            squeeze: 1.2,
            diameterRatio: .8,
            childDelegate: ListWheelInfiniteDelegate(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.width / 2),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            // childDelegate: ListWheelChildBuilderDelegate(
            //   childCount: 10,
            //   builder: (context, index) {
            //     return Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(context.width / 2),
            //         color: Colors.red,
            //       ),
            //     );
            //   },
            // ),
            // childDelegate: ListWheelChildLoopingListDelegate(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(context.width / 2),
            //         color: Colors.red,
            //       ),
            //     ),
            //     // for (int i = 0; i < 10; i++)
            //     //   Container(
            //     //     decoration: BoxDecoration(
            //     //       borderRadius: BorderRadius.circular(context.width / 2),
            //     //       color: Colors.red,
            //     //     ),
            //     //   )
            //   ],
            // ),
            // children: [
            //   for (int i = 0; i < 10; i++)
            //     Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(context.width / 2),
            //         color: Colors.red,
            //       ),
            //       margin: const EdgeInsets.symmetric(vertical: 5),
            //     )
            // ],
          ),
        ),
        // MouseRegion(
        //   // onHorizontalDragStart: (details) {
        //   //   "Horizontal start".log();
        //   // },
        //   // onVerticalDragStart: (details) {
        //   //   "vertical".log();
        //   // },
        //   onEnter: (event) {
        //     "enter".log();
        //   },
        //   child: CustomPaint(
        //     foregroundPainter: InnerCircle(),
        //     size: context.screenSize / 2,
        //   ),
        // ),
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
  ListWheelInfiniteDelegate({required this.children});

  final List<Widget> children;

  /// {@template flutter.widgets.ListWheelChildBuilderDelegate.childCount}
  /// If non-null, [childCount] is the maximum number of children that can be
  /// provided, and children are available from 0 to [childCount] - 1.
  ///
  /// If null, then the lower and upper limit are not known. However the [builder]
  /// must provide children for a contiguous segment. If the builder returns null
  /// at some index, the segment terminates there.
  /// {@endtemplate}
  final int childCount = 1;

  @override
  int? get estimatedChildCount => null;


  @override
  Widget? build(BuildContext context, int index) {
    return IndexedSemantics(index: index, child: children[index % childCount]);
  }

  @override
  bool shouldRebuild(covariant ListWheelInfiniteDelegate oldDelegate) {
    return children.first != oldDelegate.children.first;
  }
}

// class CircleClipper extends CliP
