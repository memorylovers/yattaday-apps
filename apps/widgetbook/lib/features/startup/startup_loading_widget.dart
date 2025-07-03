import 'package:flutter/material.dart';
import 'package:myapp/features/_startup/6_component/startup_loading_widget.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: "Default", type: StartupLoadingWidget, path: 'features/startup/')
Widget usecaseStartupLoadingWidget(BuildContext context) {
  return StartupLoadingWidget();
}
