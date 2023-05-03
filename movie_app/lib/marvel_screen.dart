import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/extensions.dart';
import 'package:movie_app/hero.dart';
import 'package:movie_app/hero_detail_screen.dart';

class MarvelScreen extends StatefulWidget {
  const MarvelScreen({super.key});

  @override
  State<MarvelScreen> createState() => _MarvelScreenState();
}

class _MarvelScreenState extends State<MarvelScreen> {
  late final CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
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
              items: heroes.map((e) => _buildCard(e)).toList(),
              options: CarouselOptions(
                initialPage: heroes.length ~/ 2,
                aspectRatio: .8,
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

  Widget _buildCard(MHero hero) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Hero(
            tag: "check${hero.id}",
            child: ColoredBox(
              color: hero.color,
              child: const SizedBox.shrink(),
            ),
          ),
        ),
        InkWell(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) => HeroDetailScreen(hero: hero),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          ),
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
                    child: Hero(
                      tag: "background${hero.id}",
                      child: Image(
                        image: hero.backGroundImage,
                        fit: BoxFit.cover,
                        height: context.height * .25,
                        // color: Colors.white,
                      ),
                    ),
                  ),
                  Hero(
                    tag: "name${hero.id}",
                    child: Text(
                      hero.name,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Hero(
                    tag: "heroName${hero.id}",
                    child: Text(
                      hero.heroName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400, color: Colors.white60),
                    ),
                  ),
                  const Spacer(),
                  Hero(
                    tag: "description${hero.id}",
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
                      icon: const Icon(Icons.arrow_upward_rounded),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          transform: Matrix4.translationValues(0, -context.height * .09, 0),
          height: context.height * .3,
          width: context.width,
          child: Hero(
            tag: "hero${hero.id}",
            child: Image(image: hero.image),
          ),
        ),
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
