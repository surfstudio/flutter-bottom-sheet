import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

class StandardBottomSheetExample extends StatefulWidget {
  const StandardBottomSheetExample({super.key});

  @override
  State<StandardBottomSheetExample> createState() =>
      _StandardBottomSheetExampleState();
}

class _StandardBottomSheetExampleState
    extends State<StandardBottomSheetExample> {
  bool isUseSafeArea = false;

  void _showSheetWithBorderRadius() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 0.8,
      context: context,
      bottomSheetBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
      ),
      bottomSheetColor: Colors.transparent,
      builder: (context, controller, offset) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.orange,
              height: 40,
            ),
            Container(
              color: Colors.transparent,
              height: 100,
            ),
            Container(
              color: Colors.orange,
              height: 100,
            ),
          ],
        );
      },
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
      useRootScaffold: false,
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
      bottomSheetColor: Colors.teal,
      bottomSheetBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      headerBuilder: (context, offset) {
        final textTheme = Theme.of(context).textTheme;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: offset == 0.8 ? Colors.green : Colors.deepPurple,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Header',
                    style: textTheme.headlineMedium,
                  ),
                ),
              ),
              Text(
                'position $offset',
                style: textTheme.titleLarge,
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("I'm a snackbar"),
              ),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Show SnackBar'),
          ),
          const SizedBox(height: 20),
          const Text(
            'To see how to customize the display of the snackbar click on the red button, then the green or blue button. The isRegisterScaffold property is responsible for the behavior',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showSheet,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Open BottomSheet'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showSheetWithoutList,
            child: const Text('Open StickyBottomSheet'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showSheetWithBorderRadius,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Open BottomSheet with BorderRadius'),
          ),
          const SizedBox(height: 20),
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
}

class _BottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final double bottomSheetOffset;

  const _BottomSheet({
    required this.scrollController,
    required this.bottomSheetOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        padding: EdgeInsets.zero,
        controller: scrollController,
        children: [
          Text(
            'position $bottomSheetOffset',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Column(
            children: _children,
          ),
        ],
      ),
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
  const _TextField();

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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 100,
        color: color,
      ),
    );
  }
}
