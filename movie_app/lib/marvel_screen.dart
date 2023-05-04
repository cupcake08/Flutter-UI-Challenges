import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_app/extensions.dart';
import 'package:movie_app/hero.dart';
import 'package:movie_app/hero_detail_screen.dart';
import 'package:movie_app/parallex.dart';

class MarvelScreen extends StatefulWidget {
  const MarvelScreen({super.key});

  @override
  State<MarvelScreen> createState() => _MarvelScreenState();
}

enum CarouselScrollDirection {
  left,
  right,
}

class _MarvelScreenState extends State<MarvelScreen> {
  late final CarouselController _carouselController;
  late final List<ValueNotifier<double>> notifiers;

  @override
  void initState() {
    super.initState();
    notifiers = List.generate(
      heroes.length,
      (index) => ValueNotifier<double>(0.0),
    );
    int middle = notifiers.length ~/ 2;
    notifiers[middle].value = 0.0;
    notifiers[middle - 1].value = -0.5;
    for (int i = middle + 1; i < notifiers.length; i++) {
      notifiers[i].value = 0.5;
    }
    _carouselController = CarouselController();
  }

  @override
  void dispose() {
    for (final notifier in notifiers) {
      notifier.dispose();
    }
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
              carouselController: _carouselController,
              items: heroes.map((e) {
                final index = heroes.indexOf(e);
                return _buildCard(e, index);
              }).toList(),
              options: CarouselOptions(
                initialPage: heroes.length ~/ 2,
                aspectRatio: .8,
                onScrolled: (value) {
                  final delta = value! % 1.0;
                  final currIdx = value.floor();
                  "currIndex: $currIdx".log();
                  // final direction = delta > .5 ?
                  if (currIdx > 0) notifiers[currIdx - 1].value = -delta.clamp(0.0, 0.5);
                  notifiers[currIdx].value = delta.clamp(0.0, 0.5);
                  if (currIdx < notifiers.length - 1) notifiers[currIdx + 1].value = delta.clamp(0.0, 0.5);
                },
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  index.log();
                },
                viewportFraction: .85,
                enlargeCenterPage: true,
                enlargeFactor: .15,
                height: context.height * .6,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(MHero hero, int index) {
    return Stack(
      children: [
        // Align(
        //   alignment: Alignment.center,
        //   child: Hero(
        //     tag: "backColor${hero.id}",
        //     flightShuttleBuilder: (
        //       flightContext,
        //       animation,
        //       flightDirection,
        //       fromHeroContext,
        //       toHeroContext,
        //     ) {
        //       return Container(
        //         decoration: BoxDecoration(
        //           color: Colors.redAccent,
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         height: fromHeroContext.height,
        //         width: fromHeroContext.width,
        //       );
        //     },
        //     child: Card(
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //     ),
        //   ),
        // ),
        InkWell(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) => HeroDetailScreen(hero: hero),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          ),
          child: _helper(hero),
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

  _helper(MHero hero) {
    return Material(
      child: Container(
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
                transform: Matrix4.translationValues(0, 0, 0),
                child: Hero(
                  tag: "background${hero.id}",
                  child: Image(
                    image: hero.backGroundImage,
                    fit: BoxFit.cover,
                    height: context.height * .25,
                    color: Colors.white,
                  ),
                ),
              ),
              Hero(
                tag: "hero${hero.id}",
                child: Text(
                  hero.name,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Hero(
                tag: "name${hero.id}",
                child: Text(
                  hero.heroName,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w400, color: Colors.white60),
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
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
