import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:myapp/features/_payment/presentation/payment_page.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: PaymentPage,
)
Widget buildPaymentPageUseCase(BuildContext context) {
  return const ProviderScope(
    child: PaymentPage(),
  );
}