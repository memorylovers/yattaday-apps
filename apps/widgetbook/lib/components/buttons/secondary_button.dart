import 'package:flutter/material.dart';
import 'package:myapp/components/buttons/secondary_button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: "Default", type: SecondaryButton)
Widget usecaseSecondaryButton(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          spacing: 20,
          children: [
            //
            SecondaryButton(text: "Button", onPressed: () {}),
            //
            SecondaryButton(text: "Disabled", onPressed: null),
            //
            SecondaryButton(text: "Loading", onPressed: () {}, isLoading: true),
            //
            SecondaryButton(text: "Button", icon: Icons.home, onPressed: () {}),
            //
            SecondaryButton(
              text: "Disabled",
              icon: Icons.home,
              onPressed: null,
            ),
            //
            SecondaryButton(
              text: "Loading",
              icon: Icons.home,
              onPressed: () {},
              isLoading: true,
            ),
          ],
        ),
      ),
    ),
  );
}
