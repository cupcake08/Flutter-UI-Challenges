import 'package:flutter/material.dart';
import 'package:movie_app/extensions.dart';
import 'package:movie_app/hero.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

mixin OverlayMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;

  final PanelController panelController = PanelController();
  late final MHero _hero;

  set setHero(MHero hero) => _hero = hero;

  Future<void> removeOverlay() async {
    await panelController.close();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _widget() {
    return Hero(
      tag: "bigb",
      child: SlidingUpPanel(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        snapPoint: 0.6,
        controller: panelController,
        margin: const EdgeInsets.only(top: 20),
        minHeight: context.height * .1,
        maxHeight: context.height * .6,
        defaultPanelState: PanelState.CLOSED,
        panelBuilder: (sc) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
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
      ),
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
                    color: _hero.color,
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

  insertOverlay() {
    _overlayEntry = OverlayEntry(builder: (context) => _widget());
    Overlay.of(context).insert(_overlayEntry!);
  }
}
