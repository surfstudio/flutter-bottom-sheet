import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

class StandardExample extends StatefulWidget {
  const StandardExample({Key? key}) : super(key: key);

  @override
  State<StandardExample> createState() => _StandardExampleState();
}

class _StandardExampleState extends State<StandardExample> {
  bool isUseSafeArea = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: _showSheet,
            child: const Text('Open BottomSheet'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showSheetWithoutList,
            child: const Text('Open StickyBottomSheet'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Use SafeArea'),
              Switch(
                value: isUseSafeArea,
                onChanged: (isSwitched) {
                  setState(
                    () {
                      isUseSafeArea = isSwitched;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSheet() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      context: context,
      isSafeArea: isUseSafeArea,
      bottomSheetColor: Colors.white,
      builder: (context, controller, offset) {
        return _BottomSheet(
          scrollController: controller,
          bottomSheetOffset: offset,
        );
      },
      anchors: [0, 0.5, 1],
    );
  }

  void _showSheetWithoutList() {
    showStickyFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: .8,
      headerHeight: 200,
      context: context,
      isSafeArea: isUseSafeArea,
      bottomSheetColor: Colors.transparent,
      decoration: const BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      headerBuilder: (context, offset) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(offset == 0.8 ? 0 : 40),
              topRight: Radius.circular(offset == 0.8 ? 0 : 40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Header',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Text(
                'position $offset',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        );
      },
      bodyBuilder: (context, offset) {
        return SliverChildListDelegate(
          _children,
        );
      },
      anchors: [.2, 0.5, .8],
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final double bottomSheetOffset;

  const _BottomSheet({
    required this.scrollController,
    required this.bottomSheetOffset,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      controller: scrollController,
      children: [
        Text(
          'position $bottomSheetOffset',
          style: Theme.of(context).textTheme.headline6,
        ),
        Column(
          children: _children,
        ),
      ],
    );
  }
}

List<Widget> _children = [
  const _TextField(),
  const _TestContainer(color: Color(0xEEFFFF00)),
  const _TextField(),
  const _TestContainer(color: Color(0xDD99FF00)),
  const _TextField(),
  const _TestContainer(color: Color(0xCC00FFFF)),
  const _TextField(),
  const _TestContainer(color: Color(0xBB555555)),
  const _TextField(),
  const _TestContainer(color: Color(0xAAFF5555)),
  const _TextField(),
  const _TestContainer(color: Color(0x9900FF00)),
  const _TextField(),
  const _TestContainer(color: Color(0x8800FF00)),
  const _TextField(),
  const _TestContainer(color: Color(0x7700FF00)),
  const _TextField(),
];

class _TextField extends StatelessWidget {
  const _TextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }
}

class _TestContainer extends StatelessWidget {
  final Color color;

  const _TestContainer({
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        color: color,
      ),
    );
  }
}
