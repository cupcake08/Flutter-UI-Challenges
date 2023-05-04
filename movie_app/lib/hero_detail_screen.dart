import 'package:flutter/material.dart';
import 'package:movie_app/extensions.dart';
import 'package:movie_app/hero.dart';

class HeroDetailScreen extends StatefulWidget {
  const HeroDetailScreen({super.key, required this.hero});
  final MHero hero;

  @override
  State<HeroDetailScreen> createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen> {
  late final DraggableScrollableController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = DraggableScrollableController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.3,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.55,
          minChildSize: 0.25,
          initialChildSize: 0.25,
          expand: false,
          snap: true,
          controller: _scrollController,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _subWidget(false, "latest news"),
                    const SizedBox(height: 20),
                    _subWidget(true, "related movies"),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: widget.hero.color,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () async {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.ease,
            );
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        children: [
          // Hero(
          //   tag: "backColor${widget.hero.id}",
          //   child: Card(
          //     color: widget.hero.color,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: SizedBox(
          //       height: context.height,
          //       width: context.width,
          //     ),
          //     margin: const EdgeInsets.all(0),
          //   ),
          // ),
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
          DraggableScrollableSheet(
            maxChildSize: 0.55,
            minChildSize: 0.0,
            initialChildSize: 0.0,
            snap: true,
            snapSizes: const [
              0.3,
              0.55,
            ],
            controller: _scrollController,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.only(top: 30),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _subWidget(false, "latest news"),
                      const SizedBox(height: 20),
                      _subWidget(true, "related movies"),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _subWidget(bool isMovie, String label) {
    final height = context.height * .6;
    height.log();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: isMovie ? 200 : 80,
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final delay = 400 + index * 100;
              return UnconstrainedBox(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: delay),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.hero.color,
                  ),
                  margin: EdgeInsets.only(right: 10, left: index == 0 ? 20 : 0.0),
                  height: isMovie ? 200 : 80,
                  width: context.width * .4,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _buildHeader() {
    return Container(
      // color: widget.hero.color,
      child: Padding(
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
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Hero(
              tag: "name${widget.hero.id}",
              child: Text(
                widget.hero.heroName,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w400, color: Colors.white60),
              ),
            ),
            const SizedBox(height: 30),
            Hero(
              tag: "desc${widget.hero.id}",
              child: Text(
                widget.hero.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, height: 1.5),
              ),
            ),
          ],
        ),
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
