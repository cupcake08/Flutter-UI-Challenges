import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/extensions.dart';
import 'package:movie_app/hero.dart';
import 'package:movie_app/hero_detail_screen.dart';
import 'package:movie_app/parallex.dart';

class MarvelScreen extends StatefulWidget {
  const MarvelScreen({super.key});

  @override
  State<MarvelScreen> createState() => _MarvelScreenState();
}

class _MarvelScreenState extends State<MarvelScreen> {
  late final List<ValueNotifier<double>> notifiers;
  int _currentPage = 0;
  late final ValueNotifier<Size> giveMeSize;
  late final List<GlobalKey> globalKeys;

  @override
  void initState() {
    super.initState();
    giveMeSize = ValueNotifier(Size.zero);
    notifiers = List.generate(
      heroes.length,
      (_) => ValueNotifier<double>(0.0),
    );
    globalKeys = List.generate(heroes.length, (_) => GlobalKey());
    int middle = notifiers.length ~/ 2;
    _currentPage = middle;
    notifiers[middle].value = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = globalKeys[middle].currentContext!.findRenderObject() as RenderBox;
      giveMeSize.value = renderBox.size;
    });
  }

  @override
  void dispose() {
    for (final notifier in notifiers) {
      notifier.dispose();
    }
    giveMeSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildHeader(),
          ),
          Expanded(
            child: CarouselSlider(
              items: heroes.map((e) {
                final index = heroes.indexOf(e);
                return _buildCard(e, index);
              }).toList(),
              options: CarouselOptions(
                initialPage: heroes.length ~/ 2,
                aspectRatio: .8,
                onScrolled: (value) => notifiers[_currentPage].value = _currentPage - value!,
                enableInfiniteScroll: false,
                onPageChanged: (index, _) {
                  _currentPage = index;
                },
                viewportFraction: .85,
                enlargeCenterPage: true,
                enlargeFactor: .2,
                height: context.height * .6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _navigateToAnotherScreen(MHero hero) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        pageBuilder: (___, _, __) => HeroDetailScreen(hero: hero),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildCard(MHero hero, int index) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ValueListenableBuilder(
            valueListenable: giveMeSize,
            builder: (_, value, __) {
              if (value > Size.zero) {
                return Hero(
                  tag: "backColor${hero.id}",
                  child: Card(
                    color: hero.color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.all(0),
                    child: SizedBox(
                      height: value.height,
                      width: value.width,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        GestureDetector(
          onVerticalDragStart: (_) => _navigateToAnotherScreen(hero),
          onTap: () => _navigateToAnotherScreen(hero),
          child: _helper(hero, index),
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -context.height * .09, 0),
          height: context.height * .35,
          width: context.width,
          child: Flow(
            delegate: ParallexFlowDelegate(notifiers[index]),
            children: [
              Hero(
                tag: "heroT${hero.id}",
                child: Image(image: hero.image),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _helper(MHero hero, int index) {
    return Material(
      child: Container(
        key: globalKeys[index],
        decoration: BoxDecoration(
          color: hero.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Hero(
                  tag: "background${hero.id}",
                  child: Image(
                    image: hero.backGroundImage,
                    fit: BoxFit.cover,
                    height: context.height * .25,
                    color: hero.name == "Captain-America" ? null : Colors.white,
                  ),
                ),
              ),
              FittedBox(
                child: Hero(
                  tag: "hero${hero.id}",
                  child: Text(
                    hero.name,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              Hero(
                tag: "name${hero.id}",
                child: Text(
                  hero.heroName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400, color: Colors.white60),
                ),
              ),
              const Spacer(),
              Hero(
                tag: "desc${hero.id}",
                child: Text(
                  hero.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Marvel".toUpperCase(),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            "Super Hero",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
