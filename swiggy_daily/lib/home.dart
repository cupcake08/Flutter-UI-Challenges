import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;
import 'package:swiggy_daily/data.dart';

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

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Widget> _items;
  late final AnimationController animationController;

  late final ValueNotifier<int> _tabNotifier;

  final _initialTab = 1;

  final rDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _initialTab,
      animationDuration: rDuration,
    );
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _tabController.addListener(_listener);
    _tabNotifier = ValueNotifier(_initialTab);
    _items = List.generate(
      4,
      (index) => Text(
        _getText(index + 1),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    );
    animationController
      ..forward()
      ..repeat(reverse: true);
  }

  _listener() {
    if (_tabController.indexIsChanging) {
      _tabNotifier.value = _tabController.index;
    }
  }

  _getText(int index) {
    String text = '';
    switch (index) {
      case 1:
        text = 'BreakFast';
      case 2:
        text = 'Lunch';
      case 3:
        text = 'Snacks';
      case 4:
        text = 'Dinner';
    }
    return text;
  }

  Widget _getListWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ListView.builder(
            itemCount: 5,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(137, 221, 217, 217),
                ),
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabNotifier.dispose();
    _tabController.removeListener(_listener);
    _tabController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            _header(),
            const SizedBox(height: 10),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.5),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Curves.ease,
                ),
              ),
              child: FadeTransition(
                opacity: animationController,
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicatorColor: Colors.orangeAccent,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  dividerColor: Colors.black,
                  tabs: const [
                    Tab(text: "BreakFast"),
                    Tab(text: "Lunch"),
                    Tab(text: "Snacks"),
                    Tab(text: "Dinner"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, .815),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeOutCirc,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      child: RotationTransition(
                        turns: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
                        child: ValueListenableBuilder(
                          valueListenable: _tabNotifier,
                          builder: (context, value, _) {
                            final diff = _tabController.previousIndex - _tabController.index;
                            final turnsTween = diff < 0 ? Tween<double>(begin: 1.0, end: 0.0) : Tween<double>(begin: 0, end: 1.0);
                            return AnimatedSwitcher(
                              duration: rDuration,
                              transitionBuilder: (child, animation) => RotationTransition(
                                turns: turnsTween.animate(CurvedAnimation(parent: animation, curve: Curves.easeOutQuad)),
                                child: FadeTransition(
                                  opacity: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutQuad,
                                  ),
                                  child: child,
                                ),
                              ),
                              child: Image(
                                key: ValueKey<int>(value),
                                image: imageLinks[value],
                                height: height * .3,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: 90,
                      child: ColoredBox(
                        color: Colors.white,
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [for (int i = 0; i < _items.length; i++) _getListWidget()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, .5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.ease,
        ),
      ),
      child: SizeTransition(
        sizeFactor: Tween<double>(
          begin: 5,
          end: 1,
        ).animate(animationController),
        child: SizedBox(
          child: Row(
            children: [
              Expanded(child: child),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
