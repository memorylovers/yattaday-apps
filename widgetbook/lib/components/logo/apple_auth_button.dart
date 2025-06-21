import 'package:flutter/material.dart';
import 'package:common_widget/common_widget.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: AppleAuthButton, path: 'components/logo')
Widget defaultAppleAuthButton(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: SizedBox(
        width: 300,
        child: AppleAuthButton(
          onPressed: () {
            print('Apple sign in button pressed');
          },
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: AppleAuthButton, path: 'components/logo')
Widget disabledAppleAuthButton(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: SizedBox(
        width: 300,
        child: AppleAuthButton(
          onPressed: null,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Custom Label', type: AppleAuthButton, path: 'components/logo')
Widget customLabelAppleAuthButton(BuildContext context) {
  final labelText = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Appleでサインイン',
  );

  return Container(
    color: Colors.grey[200],
    child: Center(
      child: SizedBox(
        width: 300,
        child: AppleAuthButton(
          labelText: labelText,
          onPressed: () {
            print('Apple sign in button pressed');
          },
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Dark Theme', type: AppleAuthButton, path: 'components/logo')
Widget darkThemeAppleAuthButton(BuildContext context) {
  return Theme(
    data: ThemeData.dark(),
    child: Container(
      color: Colors.grey[900],
      child: Center(
        child: SizedBox(
          width: 300,
          child: AppleAuthButton(
            onPressed: () {
              print('Apple sign in button pressed');
            },
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Multiple Sizes', type: AppleAuthButton, path: 'components/logo')
Widget multipleSizesAppleAuthButton(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: AppleAuthButton(
              onPressed: () {},
              labelText: 'Small',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 300,
            child: AppleAuthButton(
              onPressed: () {},
              labelText: 'Medium',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 350,
            child: AppleAuthButton(
              onPressed: () {},
              labelText: 'Large',
            ),
          ),
        ],
      ),
    ),
  );
}