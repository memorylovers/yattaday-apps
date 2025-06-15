import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_payment/presentation/payment_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: PaymentPage, path: '[pages]')
Widget buildPaymentPageUseCase(BuildContext context) {
  return const ProviderScope(child: PaymentPage());
}
