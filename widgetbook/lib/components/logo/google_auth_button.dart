import 'package:flutter/material.dart';
import 'package:common_widget/common_widget.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: GoogleAuthButton, path: 'components/logo')
Widget defaultGoogleAuthButton(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: SizedBox(
        width: 300,
        child: GoogleAuthButton(
          onPressed: () {
            print('Google sign in button pressed');
          },
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: GoogleAuthButton, path: 'components/logo')
Widget disabledGoogleAuthButton(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: SizedBox(
        width: 300,
        child: GoogleAuthButton(
          onPressed: null,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Custom Label', type: GoogleAuthButton, path: 'components/logo')
Widget customLabelGoogleAuthButton(BuildContext context) {
  final labelText = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Googleでサインイン',
  );

  return Container(
    color: Colors.grey[200],
    child: Center(
      child: SizedBox(
        width: 300,
        child: GoogleAuthButton(
          labelText: labelText,
          onPressed: () {
            print('Google sign in button pressed');
          },
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Dark Theme', type: GoogleAuthButton, path: 'components/logo')
Widget darkThemeGoogleAuthButton(BuildContext context) {
  return Theme(
    data: ThemeData.dark(),
    child: Container(
      color: Colors.grey[900],
      child: Center(
        child: SizedBox(
          width: 300,
          child: GoogleAuthButton(
            onPressed: () {
              print('Google sign in button pressed');
            },
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Multiple Sizes', type: GoogleAuthButton, path: 'components/logo')
Widget multipleSizesGoogleAuthButton(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: GoogleAuthButton(
              onPressed: () {},
              labelText: 'Small',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 300,
            child: GoogleAuthButton(
              onPressed: () {},
              labelText: 'Medium',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 350,
            child: GoogleAuthButton(
              onPressed: () {},
              labelText: 'Large',
            ),
          ),
        ],
      ),
    ),
  );
}