import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../_gen/i18n/strings.g.dart';
import '../../../components/scaffold/gradient_scaffold.dart';

/// 課金画面
class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientScaffold(
      showBackButton: true,
      bottomSafeArea: true,
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          // ヘッダー
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                Text(
                  i18n.payment.header.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  i18n.payment.header.subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    i18n.payment.currentPlan(
                      plan: i18n.payment.plans.free.name,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // プラン一覧
          _buildPlanCard(
            context,
            title: i18n.payment.plans.free.name,
            price: '¥0',
            priceUnit: i18n.payment.price.perMonth,
            features: [
              i18n.payment.plans.free.features.items,
              i18n.payment.plans.free.features.basicRecording,
              i18n.payment.plans.free.features.simpleStats,
            ],
            isSelected: true,
          ),
          const SizedBox(height: 16),
          _buildPlanCard(
            context,
            title: i18n.payment.plans.standard.name,
            price: '¥480',
            priceUnit: i18n.payment.price.perMonth,
            features: [
              i18n.payment.plans.standard.features.items,
              i18n.payment.plans.standard.features.detailedStats,
              i18n.payment.plans.standard.features.dataExport,
              i18n.payment.plans.standard.features.reminder,
            ],
            isRecommended: true,
          ),
          const SizedBox(height: 16),
          _buildPlanCard(
            context,
            title: i18n.payment.plans.premium.name,
            price: '¥980',
            priceUnit: i18n.payment.price.perMonth,
            features: [
              i18n.payment.plans.premium.features.allStandard,
              i18n.payment.plans.premium.features.aiAnalysis,
              i18n.payment.plans.premium.features.teamShare,
              i18n.payment.plans.premium.features.prioritySupport,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String priceUnit,
    required List<String> features,
    bool isSelected = false,
    bool isRecommended = false,
  }) {
    return Stack(
      children: [
        Card(
          elevation: isRecommended ? 8 : 2,
          color: Colors.white.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side:
                isSelected
                    ? BorderSide(color: const Color(0xFF5DD3DC), width: 2)
                    : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5DD3DC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          i18n.payment.buttons.currentPlan,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5DD3DC),
                      ),
                    ),
                    Text(
                      priceUnit,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: const Color(0xFF5DD3DC),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isSelected) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: 課金処理
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(i18n.payment.buttons.selectPlan),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isRecommended)
          Positioned(
            top: 0,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5D563),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                i18n.payment.buttons.recommended,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
