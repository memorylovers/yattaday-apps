import 'package:flutter/material.dart';
import 'package:common_widget/common_widget.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Default',
  type: BubbleBorder,
  path: 'components/logo',
)
Widget defaultBubbleBorder(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Container(
        width: 200,
        height: 100,
        decoration: ShapeDecoration(
          color: Colors.blue[400],
          shape: const BubbleBorder(),
        ),
        child: const Center(
          child: Text(
            '吹き出し',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Directions',
  type: BubbleBorder,
  path: 'components/logo',
)
Widget allDirectionsBubbleBorder(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 80,
            decoration: ShapeDecoration(
              color: Colors.green[400],
              shape: const BubbleBorder(destination: Destination.top),
            ),
            child: const Center(
              child: Text('Top', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 80,
                decoration: ShapeDecoration(
                  color: Colors.blue[400],
                  shape: const BubbleBorder(destination: Destination.left),
                ),
                child: const Center(
                  child: Text('Left', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 40),
              Container(
                width: 150,
                height: 80,
                decoration: ShapeDecoration(
                  color: Colors.purple[400],
                  shape: const BubbleBorder(destination: Destination.right),
                ),
                child: const Center(
                  child: Text('Right', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            width: 150,
            height: 80,
            decoration: ShapeDecoration(
              color: Colors.orange[400],
              shape: const BubbleBorder(destination: Destination.bottom),
            ),
            child: const Center(
              child: Text('Bottom', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With and Without Padding',
  type: BubbleBorder,
  path: 'components/logo',
)
Widget paddingBubbleBorder(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 100,
            decoration: ShapeDecoration(
              color: Colors.teal[400],
              shape: const BubbleBorder(usePadding: true),
            ),
            child: const Center(
              child: Text(
                'With Padding',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 200,
            height: 100,
            decoration: ShapeDecoration(
              color: Colors.red[400],
              shape: const BubbleBorder(usePadding: false),
            ),
            child: const Center(
              child: Text(
                'Without Padding',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Chat Message Example',
  type: BubbleBorder,
  path: 'components/logo',
)
Widget chatMessageBubbleBorder(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    padding: const EdgeInsets.all(16),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.grey[300],
                shape: const BubbleBorder(destination: Destination.left),
              ),
              child: const Text(
                'こんにちは！今日はどうですか？',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.blue[400],
                shape: const BubbleBorder(destination: Destination.right),
              ),
              child: const Text(
                '元気です！ありがとう。',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive Direction',
  type: BubbleBorder,
  path: 'components/logo',
)
Widget interactiveBubbleBorder(BuildContext context) {
  final destinationOptions = {
    'Left': Destination.left,
    'Top': Destination.top,
    'Right': Destination.right,
    'Bottom': Destination.bottom,
  };

  final selectedDestination = context.knobs.list(
    label: 'Direction',
    options: destinationOptions.keys.toList(),
    initialOption: 'Left',
  );

  final usePadding = context.knobs.boolean(
    label: 'Use Padding',
    initialValue: true,
  );

  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Container(
        width: 200,
        height: 120,
        decoration: ShapeDecoration(
          color: Colors.indigo[400],
          shape: BubbleBorder(
            destination: destinationOptions[selectedDestination]!,
            usePadding: usePadding,
          ),
        ),
        child: Center(
          child: Text(
            selectedDestination,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    ),
  );
}
