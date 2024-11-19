import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../helper/database_helper.dart';
import '../widget/scanner_overlay.dart';

class QrScreen extends ConsumerStatefulWidget {
  const QrScreen({super.key});

  @override
  ConsumerState createState() => _QrScreenState();
}

class _QrScreenState extends ConsumerState<QrScreen> {
  late final MobileScannerController controller;
  bool isDetecting = false;
  @override
  void initState() {
    controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
    );
    controller.start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          scanWindow: scanWindow,
          fit: BoxFit.contain,
          controller: controller,
          onDetect: (data) {
            if (!isDetecting) {
              isDetecting = true;
              _handleQRCodeDetected(data.barcodes[0].rawValue);
            }
          },
        ),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            if (!value.isInitialized ||
                !value.isRunning ||
                value.error != null) {
              return const SizedBox();
            }

            return CustomPaint(
              painter: ScannerOverlay(scanWindow: scanWindow),
            );
          },
        ),
      ],
    );
  }

  void _handleQRCodeDetected(String? qrCode) {
    if (qrCode != null) {
      // Handle the scanned QR code
      logger.info('Scanned QR Code: $qrCode');

      // Reset the detection flag after 2 seconds
      Future.delayed(const Duration(seconds: 1), () {
        isDetecting = false;
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scanned QR Code: $qrCode'),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
