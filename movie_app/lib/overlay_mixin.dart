import 'package:flutter/material.dart';
import 'package:movie_app/extensions.dart';
import 'package:movie_app/hero.dart';

mixin OverlayMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;

  // final PanelController panelController = PanelController();
  final DraggableScrollableController draggableScrollableController = DraggableScrollableController();
  late final AnimationController animationController;
  late final MHero _hero;

  set setHero(MHero hero) => _hero = hero;

  Future<void> removeOverlay() async {
    await draggableScrollableController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.ease,
    );
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  final List<String> imagesLinks = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQClj5XpgzBsddAUu2_PTmeYAdmG6jprwQj_g&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYYU_0OQsGuv_BvwUsokxP-NqKC9EPhfe8qA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcgLQsYL4gTwO7bIrBDqhvHzEY9qHfDFMXLA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWA3aCL6l4LoF6YCxM6vreIizEIEDgd8K0BQ&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQB36JKEF_71ngfMDWl8n_oDSTiy6w9r1oN8-4oj0QdvRaHXbzLrH6SztGTFtKw0848Z0c&usqp=CAU",
  ];

  Widget _widget() {
    return DraggableScrollableSheet(
      snap: true,
      minChildSize: .1,
      maxChildSize: .6,
      controller: draggableScrollableController,
      initialChildSize: .1,
      snapSizes: const [.25, .6],
      builder: (context, sc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            controller: sc,
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
  }

  _subWidget(bool isMovie, String label) {
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
          height: isMovie ? 200 : 100,
          child: ListView.builder(
            itemCount: imagesLinks.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return SlideTransition(
                position: Tween(begin: const Offset(0, 1.0), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Interval(
                      index / 10,
                      1.0,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                ),
                child: UnconstrainedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _hero.color,
                    ),
                    margin: EdgeInsets.only(right: 10, left: index == 0 ? 20 : 0.0),
                    height: isMovie ? 200 : 80,
                    width: context.width * .4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imagesLinks[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  insertOverlay() {
    _overlayEntry = OverlayEntry(builder: (context) => _widget());
    Overlay.of(context).insert(_overlayEntry!);
  }
}
