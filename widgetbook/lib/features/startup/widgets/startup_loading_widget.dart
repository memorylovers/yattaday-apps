import 'package:flutter/material.dart';
import 'package:myapp/features/_startup/presentation/widgets/startup_loading_widget.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: "Default", type: StartupLoadingWidget)
Widget usecaseStartupLoadingWidget(BuildContext context) {
  return StartupLoadingWidget();
}
