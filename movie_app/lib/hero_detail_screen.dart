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

class _HeroDetailScreenState extends State<HeroDetailScreen> with OverlayMixin {
  @override
  void initState() {
    super.initState();
    setHero = widget.hero;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      insertOverlay();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => panelController.animatePanelToPosition(
          .3,
          duration: const Duration(milliseconds: 200),
        ),
      );
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () async {
            removeOverlay();
            Timer(const Duration(milliseconds: 50), () {
              Navigator.pop(context);
            });
            // if (mounted) {}
          },
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
            height: context.height * .35,
            width: context.width,
            alignment: Alignment.topCenter,
            transform: Matrix4.translationValues(0.0, kToolbarHeight, 0.0),
            child: Hero(
              tag: "heroT${widget.hero.id}",
              createRectTween: (begin, end) => CustomRectTween(a: begin!, b: end!),
              child: Image(image: widget.hero.image),
            ),
          ),
        ],
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
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: kToolbarHeight),
          Hero(
            tag: "hero${widget.hero.id}",
            child: Text(
              widget.hero.name,
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
    this.isBack = false,
  }) : super(begin: a, end: b);
  final Rect a, b;
  final bool isBack;

  @override
  Rect? lerp(double t) {
    // final curve = isBack ? Curves.easeOutBack.transform(t) : Curves.easeInBack.transform(t);
    final curve = Curves.easeInBack.transform(t);
    // return Rect.fromLTWH(
    //   lerpDouble(a.left, b.left, t),
    //   lerpDouble(isBack ? a.top * curve : a.top, isBack ? b.top : b.top * curve, t),
    //   lerpDouble(a.width, b.width, t),
    //   lerpDouble(a.height, b.height, t),
    // );
    return Rect.fromLTRB(
      lerpDouble(a.left, b.left, t),
      lerpDouble(a.top, b.top * curve, t),
      lerpDouble(a.right, b.right, t),
      lerpDouble(a.bottom, b.bottom, t),
    );
  }

  double lerpDouble(double? a, double? b, double t) {
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
