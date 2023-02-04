import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workout_configuration/logic/box_notifier.dart';
import 'package:workout_configuration/util/constants.dart';
import 'package:workout_configuration/util/utils.dart';
import 'dart:developer' as devtools show log;

void main() {
  runApp(const MyApp());
}

extension Dimensions on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}

extension DurationExt on num {
  Duration get microsecond => Duration(microseconds: round());
  Duration get ms => (1000 * this).microsecond;
}

extension Log on Object {
  void log() => devtools.log(toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoxNotifier(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: AppColor.lightOrange,
          textTheme: GoogleFonts.inconsolataTextTheme(),
        ),
        home: const Home(),
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
  late double first;
  late final double _top;
  final boxWidth = 40.0;

  @override
  void didChangeDependencies() {
    first = 0.0;
    _top = context.height * .4;
    final x = context.width / 3;
    context.read<BoxNotifier>().changeBoxPosition(
          Offset(x, _top),
          Offset(x * 2.0, _top),
        );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.lightTertiaryGray,
        body: SizedBox(
          height: context.height * .6,
          child: Consumer<BoxNotifier>(
            builder: (context, notifier, child) {
              final fp = notifier.fbp.dx / width * 100;
              final sp = (notifier.sbp.dx - notifier.fbp.dx) / width * 100;
              final tp = (width - notifier.sbp.dx) / width * 100;
              return Stack(
                children: [
                  CustomPaint(
                    painter: SliderPainter(
                      first: first,
                      second: notifier.fbp.dx,
                      third: notifier.sbp.dx,
                      top: _top,
                    ),
                    size: Size(width, height * .6),
                  ),
                  Positioned(
                    top: _top - boxWidth - 10,
                    left: notifier.fbp.dx / 2 - 10,
                    child: _buildIcon(Constants.runnerImage),
                  ),
                  Positioned(
                    top: _top - boxWidth - 10,
                    left: notifier.fbp.dx + (notifier.sbp.dx - notifier.fbp.dx) / 2 - 10,
                    child: _buildIcon(Constants.dumbBellImage),
                  ),
                  Positioned(
                    top: _top - boxWidth - 10,
                    left: notifier.sbp.dx + (width - notifier.sbp.dx) / 2 - 10,
                    child: _buildIcon(Constants.stretchingImage),
                  ),
                  Positioned(
                    left: notifier.fbp.dx - boxWidth / 2,
                    top: _top - boxWidth / 2,
                    child: GestureDetector(
                      onTapDown: (_) => notifier.liftFirstBox = true,
                      onTapUp: (_) => notifier.liftFirstBox = false,
                      onPanEnd: (_) => notifier.liftFirstBox = false,
                      onPanUpdate: (details) {
                        notifier.changeBoxPosition(
                          details.globalPosition,
                          notifier.sbp,
                          notify: true,
                        );
                      },
                      child: AnimatedScale(
                        duration: 100.ms,
                        scale: notifier.lfb ? 1.2 : 1.0,
                        child: child,
                      ),
                    ),
                  ),
                  // Pop Ups work
                  Positioned(
                    top: _top - boxWidth * 2.3,
                    left: notifier.fbp.dx - (85.0 / 2.0) + 1,
                    child: AnimatedScale(
                      duration: 100.ms,
                      scale: notifier.lfb ? 1.0 : 0.0,
                      child: _buildPopUpContainer(
                        fp,
                        sp,
                        leftColor: AppColor.lightOrange,
                        rightColor: AppColor.lightPurple,
                      ),
                    ),
                  ),
                  Positioned(
                    top: _top - boxWidth * 2.3,
                    left: notifier.sbp.dx - (85.0 / 2.0) + 1,
                    child: AnimatedScale(
                      duration: 100.ms,
                      scale: notifier.lsb ? 1.0 : 0.0,
                      child: _buildPopUpContainer(
                        sp,
                        tp,
                        leftColor: AppColor.lightPurple,
                        rightColor: AppColor.lightBlue,
                      ),
                    ),
                  ),
                  Positioned(
                    left: notifier.sbp.dx - boxWidth / 2,
                    top: _top - boxWidth / 2,
                    child: GestureDetector(
                      onTapDown: (_) => notifier.liftSecondBox = true,
                      onTapUp: (_) => notifier.liftSecondBox = false,
                      onPanEnd: (_) => notifier.liftSecondBox = false,
                      onPanUpdate: (details) {
                        notifier.changeBoxPosition(
                          notifier.fbp,
                          details.globalPosition,
                          notify: true,
                        );
                      },
                      child: AnimatedScale(
                        duration: 100.ms,
                        scale: notifier.lsb ? 1.2 : 1.0,
                        child: child,
                      ),
                    ),
                  ),
                ],
              );
            },
            child: Container(
              width: boxWidth,
              height: boxWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(.3),
                    offset: const Offset(0.0, 3.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: const Icon(Icons.compare_arrows_rounded),
            ),
          ),
        ),
      ),
    );
  }

  _buildPopUpContainer(double left, double right, {required Color leftColor, required Color rightColor}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(.3),
            offset: const Offset(0.0, 3.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPopupChild(
            percent: left,
            color: leftColor,
          ),
          const ColoredBox(
            color: AppColor.lightTertiaryGray,
            child: SizedBox(
              width: 1,
              height: 30,
            ),
          ),
          _buildPopupChild(
            percent: right,
            color: rightColor,
          ),
        ],
      ),
    );
  }

  _buildPopupChild({
    required double percent,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColoredBox(
            color: color,
            child: const SizedBox(height: 2, width: 14),
          ),
          Text(
            "${percent.floor()}%",
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
        ],
      ),
    );
  }

  _buildIcon(String imageUrl) {
    return Image.asset(
      imageUrl,
      height: 25,
      width: 25,
    );
  }
}

class SliderPainter extends CustomPainter {
  final double first, second, third, top;
  final bool showFirstPopup, showSecondPopup;
  final Paint _paint1, _paint2, _paint3; // draw 3 portions of line
  final List<double> stops;
  SliderPainter({
    required this.first,
    required this.second,
    required this.third,
    required this.top,
    this.showFirstPopup = false,
    this.showSecondPopup = false,
  })  : _paint1 = Paint()
          ..color = AppColor.lightOrange
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6,
        _paint2 = Paint()
          ..color = AppColor.lightPurple
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6,
        _paint3 = Paint()
          ..color = AppColor.lightBlue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6,
        stops = [0.0, 1.0];

  @override
  void paint(Canvas canvas, Size size) {
    late Rect rect;
    Paint paint = Paint();
    // first portion
    canvas.drawLine(Offset(first, top), Offset(second, top), _paint1);
    rect = Rect.fromLTWH(first, 0.0, second, size.height);
    paint.shader = LinearGradient(
      colors: [
        AppColor.lightOrange.withOpacity(.1),
        AppColor.lightTertiaryGray,
      ],
      stops: stops,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);
    canvas.drawRect(rect, paint);
    // second portion
    canvas.drawLine(Offset(second, top), Offset(third, top), _paint2);
    rect = Rect.fromLTWH(second, 0.0, third - second, size.height);
    paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColor.lightPurple.withOpacity(.1),
          AppColor.lightTertiaryGray,
        ],
        stops: stops,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, paint);
    // third portion
    canvas.drawLine(Offset(third, top), Offset(size.width, top), _paint3);
    rect = Rect.fromLTWH(third, 0.0, size.width - third, size.height);
    paint.shader = LinearGradient(
      colors: [
        AppColor.lightBlue.withOpacity(.1),
        AppColor.lightTertiaryGray,
      ],
      stops: stops,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant SliderPainter oldDelegate) => true;
}
