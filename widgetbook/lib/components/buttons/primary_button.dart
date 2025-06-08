import 'package:flutter/material.dart';
import 'package:myapp/components/buttons/primary_button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: "Default", type: PrimaryButton)
Widget usecasePrimaryButton(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          spacing: 20,
          children: [
            //
            PrimaryButton(text: "Button", onPressed: () {}),
            //
            PrimaryButton(text: "Disabled", onPressed: null),
            //
            PrimaryButton(text: "Loading", onPressed: () {}, isLoading: true),
            //
            PrimaryButton(text: "Button", icon: Icons.home, onPressed: () {}),
            //
            PrimaryButton(text: "Disabled", icon: Icons.home, onPressed: null),
            //
            PrimaryButton(
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
