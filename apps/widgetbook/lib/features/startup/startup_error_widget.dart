import 'package:flutter/material.dart';
import 'package:myapp/features/_startup/6_component/startup_error_widget.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: "Default", type: StartupErrorWidget, path: 'features/startup/')
Widget usecaseStartupErrorWidget(BuildContext context) {
  return StartupErrorWidget(onRetry: () {});
}
