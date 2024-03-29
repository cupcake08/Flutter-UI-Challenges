import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_app/extensions.dart';
import 'package:movie_app/hero.dart';
import 'package:movie_app/overlay_mixin.dart';

class HeroDetailScreen extends StatefulWidget {
  const HeroDetailScreen({super.key, required this.hero});
  final MHero hero;

  @override
  State<HeroDetailScreen> createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen> with OverlayMixin, SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    setHero = widget.hero;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      insertOverlay();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        draggableScrollableController.animateTo(
          .25,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
        );
        animationController.forward();
      });
    });
  }

  _navigateBack() async {
    removeOverlay();
    Timer(const Duration(milliseconds: 50), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            onPressed: _navigateBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: Stack(
          children: [
            Hero(
              tag: "backColor${widget.hero.id}",
              child: Card(
                color: widget.hero.color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(0),
                child: SizedBox(
                  height: context.height,
                  width: context.width,
                ),
              ),
            ),
            _buildHeader(),
            Container(
              transform: Matrix4.translationValues(0.0, kToolbarHeight, 0.0),
              alignment: Alignment.topCenter,
              child: Hero(
                tag: "heroT${widget.hero.id}",
                createRectTween: (begin, end) => CustomRectTween(a: begin!, b: end!),
                child: Image(
                  image: widget.hero.image,
                  height: context.height * .35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            transform: Matrix4.translationValues(0, kToolbarHeight, 0),
            child: Hero(
              tag: "background${widget.hero.id}",
              child: Image(
                image: widget.hero.backGroundImage,
                fit: BoxFit.cover,
                height: context.height * .35,
                color: widget.hero.name == "Captain-America" ? null : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: kToolbarHeight),
          Hero(
            tag: "hero${widget.hero.id}",
            child: Text(
              widget.hero.name,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style:
                  Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Hero(
            tag: "name${widget.hero.id}",
            child: Text(
              widget.hero.heroName,
              style:
                  Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400, color: Colors.white60),
            ),
          ),
          const SizedBox(height: 30),
          Hero(
            tag: "desc${widget.hero.id}",
            child: Text(
              widget.hero.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 6,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRectTween extends RectTween {
  CustomRectTween({
    required this.a,
    required this.b,
  }) : super(begin: a, end: b);
  final Rect a, b;

  @override
  Rect? lerp(double t) {
    final curve = Curves.easeInBack.transform(t);
    return Rect.fromLTWH(
      lerpDouble(a.left, b.left, t),
      lerpDouble(a.top, b.top * curve, t),
      lerpDouble(a.width, b.width, t),
      lerpDouble(a.height, b.height, t),
    );
  }

  double lerpDouble(double? a, double? b, double t) {
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
