import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workout_configuration/logic/box_notifier.dart';
import 'package:workout_configuration/ui/slider.dart';
import 'package:workout_configuration/util/utils.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoxNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Work Out App',
        theme: ThemeData(
          primaryColor: AppColor.lightOrange,
          textTheme: GoogleFonts.inconsolataTextTheme(),
        ),
        home: const WorkoutSelectionScreen(),
      ),
    );
  }
}

class WorkoutSelectionScreen extends StatefulWidget {
  const WorkoutSelectionScreen({super.key});

  @override
  State<WorkoutSelectionScreen> createState() => _WorkoutSelectionScreenState();
}

class BackGroundGridPainter extends CustomPainter {
  final double first, second, third;
  final Paint _paint;
  final List<double> stops;
  final bool applyGradient;
  final double top;
  BackGroundGridPainter({
    required this.first,
    required this.second,
    required this.third,
    this.top = 0.0,
    this.stops = const [0.0, 0.6],
    this.applyGradient = true,
  }) : _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    late Rect rect;
    // first
    rect = Rect.fromLTWH(first, top, second, size.height);
    !applyGradient
        ? _paint.color = AppColor.lightOrange.withAlpha(80)
        : _paint.shader = LinearGradient(
            colors: [
              AppColor.lightOrange.withAlpha(60),
              AppColor.lightTertiaryGray,
            ],
            stops: stops,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(rect);
    canvas.drawRect(rect, _paint);
    rect = Rect.fromLTWH(second, top, third - second, size.height);
    !applyGradient
        ? _paint.color = AppColor.lightPurple.withAlpha(60)
        : _paint.shader = LinearGradient(
            colors: [
              AppColor.lightPurple.withOpacity(.1),
              AppColor.lightTertiaryGray,
            ],
            stops: stops,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(rect);
    canvas.drawRect(rect, _paint);
    // third
    rect = Rect.fromLTWH(third, top, size.width - third, size.height);
    !applyGradient
        ? _paint.color = AppColor.lightBlue.withAlpha(60)
        : _paint.shader = LinearGradient(
            colors: [
              AppColor.lightBlue.withOpacity(.1),
              AppColor.lightTertiaryGray,
            ],
            stops: stops,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(rect);
    canvas.drawRect(rect, _paint);
  }

  @override
  bool shouldRepaint(covariant BackGroundGridPainter oldDelegate) {
    return oldDelegate.first != first || oldDelegate.second != second || oldDelegate.third != third;
  }
}

class CustomRectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height * .2);
    return rect;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

class _WorkoutSelectionScreenState extends State<WorkoutSelectionScreen> {
  late final double _first;
  double? _top;
  final double boxWidth = 40.0;
  List<DropdownMenuItem<int>>? workoutPart;

  @override
  void initState() {
    super.initState();
    _first = 0.0;
  }

  _generateWorkoutParts() {
    workoutPart ??= [
      DropdownMenuItem<int>(
        value: 1,
        child: Text(
          "Legs",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: AppColor.black, fontSize: 18),
        ),
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    _generateWorkoutParts();
    _top ??= context.height * .15;
    final x = context.width / 3;
    context.read<BoxNotifier>().changeBoxPosition(
          Offset(x, _top!),
          Offset(x * 2.0, _top!),
        );
    super.didChangeDependencies();
  }

  Widget _buildBackGroundGrid() {
    final boxNotifier = context.read<BoxNotifier>();
    return CustomPaint(
      painter: BackGroundGridPainter(
        first: 0.0,
        second: boxNotifier.fbp.dx,
        third: boxNotifier.sbp.dx,
      ),
      size: MediaQuery.of(context).size,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = context.height;
    double width = context.width;
    final expandedHeight = height * .4;
    final collapsedHeight = height * .2;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // build background things.
          Consumer<BoxNotifier>(builder: (context, value, child) => _buildBackGroundGrid()),
          NestedScrollView(
            body: ListView.builder(
              itemCount: 10,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.lightTertiaryGray,
                  ),
                  height: 80.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
            ),
            headerSliverBuilder: (context, value) => [
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  bool flag = constraints.scrollOffset >= collapsedHeight;
                  return SliverAppBar.large(
                    shadowColor: Colors.transparent,
                    backgroundColor: !flag ? Colors.transparent : AppColor.lightTertiaryGray,
                    expandedHeight: expandedHeight,
                    collapsedHeight: collapsedHeight,
                    iconTheme: const IconThemeData(color: AppColor.black),
                    elevation: 0.0,
                    pinned: true,
                    floating: false,
                    snap: false,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(0.0),
                      child: Column(
                        children: [
                          Consumer<BoxNotifier>(
                            builder: (context, notifier, child) {
                              return Stack(
                                children: [
                                  if (flag)
                                    Positioned(
                                      top: 0,
                                      child: ClipRect(
                                        clipBehavior: Clip.antiAlias,
                                        clipper: CustomRectClipper(),
                                        child: _buildBackGroundGrid(),
                                      ),
                                    ),
                                  CustomPaint(
                                    painter: SliderPainter(
                                      first: _first,
                                      second: notifier.fbp.dx,
                                      third: notifier.sbp.dx,
                                      top: _top!,
                                    ),
                                    size: Size(width, collapsedHeight),
                                  ),
                                  Positioned(
                                    left: notifier.fbp.dx - boxWidth / 2,
                                    top: _top! - boxWidth / 2,
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
                                  Positioned(
                                    left: notifier.sbp.dx - boxWidth / 2,
                                    top: _top! - boxWidth / 2,
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
                              padding: const EdgeInsetsDirectional.all(10),
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
                              child: _buildIcon(Constants.sliderIcon),
                            ),
                          ),
                        ],
                      ),
                    ),
                    flexibleSpace: LayoutBuilder(builder: (context, constranints) {
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.only(bottom: collapsedHeight - kToolbarHeight),
                        title: AnimatedOpacity(
                          opacity: flag ? 1.0 : 0.0,
                          duration: 100.ms,
                          child: DropdownButton(
                            items: workoutPart,
                            value: 1,
                            onChanged: (value) {},
                            underline: const SizedBox.shrink(),
                          ),
                        ),
                        background: Column(
                          children: [
                            Transform.translate(
                              offset: Offset(0.0, -(expandedHeight - constranints.maxHeight) + 40),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("New", style: Theme.of(context).textTheme.displayMedium),
                                      Text(
                                        "Workout",
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppColor.lightPrimaryGray),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ColoredBox(
                                        color: AppColor.lightSecondaryGray,
                                        child: SizedBox(
                                          height: context.height * .15,
                                          width: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // title
                                          Text(
                                            "Muscle",
                                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColor.lightPrimaryGray),
                                          ),
                                          DropdownButton(
                                            underline: const SizedBox.shrink(),
                                            items: workoutPart,
                                            value: 1,
                                            onChanged: (value) {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Consumer<BoxNotifier>(
                              builder: (context, notifier, child) {
                                final fp = notifier.fbp.dx / width * 100;
                                final sp = (notifier.sbp.dx - notifier.fbp.dx) / width * 100;
                                final tp = (width - notifier.sbp.dx) / width * 100;
                                return Row(
                                  children: [
                                    Transform.translate(
                                      offset: Offset(
                                        notifier.fbp.dx - 44.5,
                                        _top! - boxWidth - constraints.scrollOffset,
                                      ),
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
                                    Transform.translate(
                                      offset: Offset(
                                        notifier.sbp.dx - 45 - 90 + 1,
                                        _top! - boxWidth - constraints.scrollOffset,
                                      ),
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
                                  ],
                                );
                              },
                            ),
                            // Icons
                            Consumer<BoxNotifier>(
                              builder: (context, notifier, child) {
                                final changeHeight = expandedHeight - constranints.maxHeight;
                                return Row(
                                  children: [
                                    Transform.translate(
                                      offset: Offset(
                                        notifier.fbp.dx / 2.0 - 12.5,
                                        _top! - (25 >> 1) - boxWidth - changeHeight,
                                      ),
                                      child: _buildIcon(Constants.runnerImage),
                                    ),
                                    Transform.translate(
                                      offset: Offset(
                                        notifier.fbp.dx + (notifier.sbp.dx - notifier.fbp.dx) / 2 - 12.5 - 25,
                                        _top! - (25 >> 1) - boxWidth - changeHeight,
                                      ),
                                      child: _buildIcon(Constants.dumbBellImage),
                                    ),
                                    Transform.translate(
                                      offset: Offset(
                                        notifier.sbp.dx + (width - notifier.sbp.dx) / 2 - 12.5 - 2 * 25,
                                        _top! - (25 >> 1) - boxWidth - changeHeight,
                                      ),
                                      child: _buildIcon(Constants.stretchingImage),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {},
              ),
              iconTheme: const IconThemeData(color: AppColor.black),
              actionsIconTheme: const IconThemeData(color: AppColor.black),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
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
          ColoredBox(
            color: AppColor.lightTertiaryGray,
            child: SizedBox(
              width: 1,
              height: boxWidth,
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

  _buildIcon(String imageUrl, {double size = 25}) {
    return Image.asset(
      imageUrl,
      height: size,
      width: size,
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
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
