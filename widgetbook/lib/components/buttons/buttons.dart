import 'package:flutter/material.dart';
import 'package:myapp/components/buttons/buttons.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: "Default", type: Button)
Widget usecaseButton(BuildContext context) {
  final style = ElevatedButton.styleFrom(
    iconSize: 28,
    textStyle: TextStyle(fontSize: 18),
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  );

  return Scaffold(
    body: SafeArea(
      child: Column(
        spacing: 20,
        children: [
          //
          Button(label: "Button", onPressed: () {}),
          //
          Button(label: "Disabled", onPressed: null),
          //
          Button(label: "Loading", onPressed: () {}, isLoading: true),

          //
          Button(label: "With Icon", icon: Icons.home, onPressed: () {}),
          //
          Button(label: "Disabled", icon: Icons.home, onPressed: null),
          //
          Button(
            label: "Loading",
            icon: Icons.home,
            onPressed: () {},
            isLoading: true,
          ),

          //
          Button(
            label: "With Styled",
            icon: Icons.home,
            style: style,
            onPressed: () {},
          ),
          //
          Button(
            label: "Disabled",
            icon: Icons.home,
            style: style,
            onPressed: null,
          ),
          //
          Button(
            label: "Loading",
            icon: Icons.home,
            style: style,
            onPressed: () {},
            isLoading: true,
          ),
        ],
      ),
    ),
  );
}
