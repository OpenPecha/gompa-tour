import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/states/organization_state.dart';
import 'package:gompa_tour/ui/screen/deties_detail_screen.dart';
import 'package:gompa_tour/util/qr_extractor.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../helper/database_helper.dart';
import '../../states/deties_state.dart';
import '../../util/util.dart';
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
              logger.info('Detected QR Code: ${data.barcodes[0].rawValue}');
              _handleQRCodeDetection(data.barcodes[0].rawValue);
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

  void _handleQRCodeDetection(String? qrCode) {
    if (qrCode == null) return;

    setState(() => isDetecting = true);
    controller.stop();

    // Validate QR Code
    final qrCodeValidator = extractQrAndValidate(qrCode);

    if (!qrCodeValidator.isValid) {
      _handleInvalidQrCode(qrCodeValidator.error);
      return;
    }

    _processValidQrCode(qrCodeValidator);
  }

  void _handleInvalidQrCode(String? error) {
    showGonpaSnackBar(context, error ?? 'Invalid QR Code');
    _resetScanner();
  }

  void _processValidQrCode(QrCodeValidator qrCodeValidator) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    switch (qrCodeValidator.type) {
      case QrType.tensum:
        _fetchDeityDetails(qrCodeValidator.urlValue!);
        return;
      case QrType.organization:
        _fetchOrganizationDetails(qrCodeValidator.urlValue!);
        return;
      default:
        showGonpaSnackBar(context, 'Invalid QR Code');
        Navigator.pop(context);
        _resetScanner();
        break;
    }
  }

  Future<void> _fetchDeityDetails(String slug) async {
    try {
      final deity = await ref
          .read(detiesNotifierProvider.notifier)
          .fetchDeityBySlug(slug);

      // Dismiss loading dialog
      Navigator.of(context).pop();

      if (deity != null) {
        // Update selected deity and navigate
        ref.read(selectedDeityProvider.notifier).state = deity;
        _navigateToDeityDetail();
      } else {
        showGonpaSnackBar(context, 'Deity not found');
        _resetScanner();
      }
    } catch (e) {
      // Dismiss loading dialog
      Navigator.of(context).pop();

      showGonpaSnackBar(context, 'Error fetching deity details');
      _resetScanner();
    }
  }

  Future<void> _fetchOrganizationDetails(String slug) async {
    try {
      final org = await ref
          .read(organizationNotifierProvider.notifier)
          .fetchOrganizationBySlug(slug);

      // Dismiss loading dialog
      Navigator.of(context).pop();

      if (org != null) {
        // Update selected deity and navigate
        ref.read(selectedOrganizationProvider.notifier).state = org;
        _navigateToDeityDetail();
      } else {
        showGonpaSnackBar(context, 'org not found');
        _resetScanner();
      }
    } catch (e) {
      // Dismiss loading dialog
      Navigator.of(context).pop();

      showGonpaSnackBar(context, 'Error fetching org details');
      _resetScanner();
    }
  }

  void _navigateToDeityDetail() {
    context.push(DeityDetailScreen.routeName).then((_) {
      _resetScanner();
    });
  }

  void _resetScanner() {
    setState(() => isDetecting = false);
    controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
