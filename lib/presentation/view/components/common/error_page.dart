import 'package:flutter/material.dart';

import 'margin.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.retryMethod});
  final VoidCallback retryMethod;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('エラーが発生しました'),
          const MarginVertical(10),
          ElevatedButton(
            onPressed: retryMethod,
            child: const Text('リトライ'),
          ),
        ],
      ),
    );
  }
}
