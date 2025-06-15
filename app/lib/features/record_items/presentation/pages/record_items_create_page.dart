import 'package:flutter/material.dart';

import '../widgets/record_item_form.dart';

/// 記録項目作成ページ
class RecordItemsCreatePage extends StatelessWidget {
  const RecordItemsCreatePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('記録項目作成'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF5DD3DC),
              const Color(0xFF7EDBB7),
              const Color(0xFFF5D563),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            color: Colors.white,
            child: RecordItemForm(
              userId: userId,
              onSuccess: () {
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
