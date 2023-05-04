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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _scrollController.animateTo(
      //   0.3,
      //   duration: const Duration(milliseconds: 500),
      //   curve: Curves.ease,
      // );
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
      // backgroundColor: widget.hero.color,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () async {
            // _scrollController.animateTo(
            //   0.0,
            //   duration: const Duration(milliseconds: 100),
            //   curve: Curves.ease,
            // );
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        children: [
          _buildHeader(),
          Container(
            height: context.height * .35,
            width: context.width,
            transform: Matrix4.translationValues(0.0, kToolbarHeight, 0.0),
            child: Hero(
              tag: "hero${widget.hero.id}",
              transitionOnUserGestures: true,
              child: Image(image: widget.hero.image),
            ),
          ),
          // DraggableScrollableSheet(
          //   maxChildSize: 0.55,
          //   minChildSize: 0.0,
          //   initialChildSize: 0.25,
          //   snap: true,
          //   controller: _scrollController,
          //   builder: (context, scrollController) {
          //     return Container(
          //       decoration: const BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          //       ),
          //       padding: const EdgeInsets.only(top: 30),
          //       child: SingleChildScrollView(
          //         controller: scrollController,
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             _subWidget(false, "latest news"),
          //             const SizedBox(height: 20),
          //             _subWidget(true, "related movies"),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
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
              return UnconstrainedBox(
                child: Container(
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
    return Hero(
      tag: "heroT${widget.hero.id}",
      child: Card(
        color: widget.hero.color,
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                transform: Matrix4.translationValues(0, kToolbarHeight, 0),
                child: Image(
                  image: widget.hero.backGroundImage,
                  fit: BoxFit.cover,
                  height: context.height * .35,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: kToolbarHeight),
              FittedBox(
                child: Text(
                  widget.hero.name,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              FittedBox(
                child: Text(
                  widget.hero.heroName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400, color: Colors.white60),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                widget.hero.description,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
