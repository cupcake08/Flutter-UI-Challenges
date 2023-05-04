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
    notifiers[middle].value = 0.5;
    notifiers[middle - 1].value = 0.0;
    notifiers[middle + 1].value = 1.0;
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
                  final idx = value!.floor();
                  if (idx > 0) notifiers[idx - 1].value = idx - value;
                  if (idx < heroes.length - 1) notifiers[idx + 1].value = value - idx;
                  notifiers[idx].value = value - idx;
                },
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {},
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
        InkWell(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) => HeroDetailScreen(hero: hero),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          ),
          child: Hero(
            tag: "heroT${hero.id}",
            child: Card(
              color: hero.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                        image: hero.backGroundImage,
                        fit: BoxFit.cover,
                        height: context.height * .25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      hero.name,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      hero.heroName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400, color: Colors.white60),
                    ),
                    const Spacer(),
                    Text(
                      hero.description,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_upward_rounded),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: notifiers[index],
            builder: (context, value, _) {
              value.log();
              return Container(
                transform: Matrix4.translationValues(0.0, -context.height * .09, 0),
                height: context.height * .3,
                width: context.width,
                child: Hero(
                  tag: "hero${hero.id}",
                  child: Flow(
                    delegate: ParallexFlowDelegate(0.0),
                    children: [
                      Image(image: hero.image),
                    ],
                  ),
                ),
              );
            }),
      ],
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
