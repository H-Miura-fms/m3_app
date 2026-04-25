import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../controller/circle_map/circle_map_controller.dart';
import '../../components/common/error_page.dart';
import '../../components/common/loading_page.dart';

class CircleMapPage extends ConsumerWidget {
  const CircleMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(circleMapControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('マップ'),
      ),
      body: mapController.when(
        data: (data) {
          return _MapPdfView(filePath: data);
        },
        error: (error, stackTrace) {
          return ErrorPage(
            retryMethod: () {
              ref.invalidate(circleMapControllerProvider);
            },
          );
        },
        loading: LoadingPage.new,
      ),
    );
  }
}

class _MapPdfView extends StatelessWidget {
  const _MapPdfView({required this.filePath});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PDFView(
        filePath: filePath,
      ),
    );
  }
}
