import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

class CustomAnimatedList extends StatefulWidget {
  const CustomAnimatedList({super.key});

  @override
  State<CustomAnimatedList> createState() => _CustomAnimatedListState();
}

class _CustomAnimatedListState extends State<CustomAnimatedList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<Widget> _items = [];

  ValueNotifier<double> _progress = ValueNotifier(0.0);

  void _addItem() {
    _items.add(_item());
    _listKey.currentState!.insertItem(
      0,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _removeItem(int index) {
    final widget = _items.removeAt(index);
    final size = MediaQuery.of(context).size;
    size.log();
    _listKey.currentState!.removeItem(
      index,
      (context, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        // return SizeTransition(
        //   sizeFactor: animation,
        //   child: widget,
        // );
        return SlideTransition(
          position: offsetAnimation,
          child: widget,
        );
      },
    );
  }

  _item() {
    return Dismissible(
      key: UniqueKey(),
      secondaryBackground: Container(
        height: 80,
        width: 80,
        color: Colors.red,
      ),
      onUpdate: (details) {
        // details.progress.log();
        details.progress.log();
        _progress.value = details.progress;
      },
      dismissThresholds: const {
        DismissDirection.endToStart: .4,
        DismissDirection.startToEnd: 1,
      },
      confirmDismiss: (direction) async {
        return false;
      },
      background: Row(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: _progress,
            builder: (context, value, child) {
              // calculate percent
              const width = 80 * .3;
              // final destination widtIh = 80;
              // range is from 0 to 24;
              // 0 -> 0
              // 24 -> 80
              final percent = (80 / width) * (80 * value);
              "percent: $percent".log();
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  // if (value <= .3)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 80,
                    alignment: Alignment.centerRight,
                    transformAlignment: Alignment.center,
                    // width: value <= .15
                    //     ? percent
                    //     : value <= .3
                    //         ? 80
                    //         : 0.0,
                    width: value <= .24 ? 80 : 0.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 152, 0, 1),
                    ),
                  ),
                ],
              );
            },
          ),
          ValueListenableBuilder<double>(
            valueListenable: _progress,
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  // if (value <= .3)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 80,
                    width: value > .24 ? 80 : 0.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 80,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // add item button
        ElevatedButton(
          onPressed: _addItem,
          style: ElevatedButton.styleFrom(minimumSize: Size(MediaQuery.of(context).size.width, 40)),
          child: const Text("Add Item"),
        ),
        const SizedBox(height: 10),
        // remove item button
        ElevatedButton(
          onPressed: () {
            _removeItem(_items.length - 1);
            // _items.removeLast();
          },
          style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width, 40), backgroundColor: Colors.blueGrey),
          child: const Text("Remove Item"),
        ),
        Expanded(
          child: AnimatedList(
              key: _listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                "rebuilding animated list: ${_items.length}".log();
                return SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  axisAlignment: 0.5,
                  child: _items[index],
                );
              }),
        ),
      ],
    );
  }
}

extension Log on Object {
  void log() => dev.log(toString());
}
