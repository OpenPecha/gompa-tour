import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/states/festival_state.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/states/statue_state.dart';
import 'package:gompa_tour/ui/screen/deities_detail_screen.dart';
import 'package:gompa_tour/ui/screen/festival_detail_screen.dart';
import 'package:gompa_tour/ui/screen/organization_detail_screen.dart';
import 'package:gompa_tour/util/qr_extractor.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../helper/database_helper.dart';
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
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Define a fixed size for the scan window
    const double scanSize = 250;

    // Calculate center point - ensure it's precisely at the center of the screen
    final Offset center = Offset(screenSize.width / 2, screenSize.height / 2);
    final scanWindow = Rect.fromCenter(
      center: center,
      width: scanSize,
      height: scanSize,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          scanWindow: scanWindow,
          fit: BoxFit.cover,
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
              painter: ScannerOverlay(
                scanWindow: scanWindow,
              ),
              size: Size.infinite,
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
      case QrType.statue:
        _fetchStatueDetails(qrCodeValidator.idValue!);
        return;
      case QrType.gonpa:
        _fetchOrganizationDetails(qrCodeValidator.idValue!);
        return;
      case QrType.festival:
        _fetchEventDetails(qrCodeValidator.idValue!);
      case QrType.site:
        showGonpaSnackBar(context, 'Site not found');
        Navigator.pop(context);
        _resetScanner();
        break;
      default:
        showGonpaSnackBar(context, 'Invalid QR Code');
        Navigator.pop(context);
        _resetScanner();
        break;
    }
  }

  Future<void> _fetchStatueDetails(String id) async {
    try {
      final statue =
          await ref.read(statueNotifierProvider.notifier).fetchStatueById(id);

      // Dismiss loading dialog
      Navigator.of(context).pop();

      if (statue != null) {
        // Update selected deity and navigate
        ref.read(selectedStatueProvider.notifier).state = statue;
        context.push(DeityDetailScreen.routeName).then((_) {
          _resetScanner();
        });
      } else {
        showGonpaSnackBar(context, 'Deity not found');
        Future.delayed(Duration(seconds: 2), () {
          _resetScanner();
        });
      }
    } catch (e) {
      // Dismiss loading dialog
      Navigator.of(context).pop();

      showGonpaSnackBar(context, 'Error fetching deity details');
      _resetScanner();
    }
  }

  Future<void> _fetchOrganizationDetails(String id) async {
    try {
      final gonpa =
          await ref.read(gonpaNotifierProvider.notifier).getGonpaById(id);

      // Dismiss loading dialog
      Navigator.of(context).pop();

      if (gonpa != null) {
        // Update selected deity and navigate
        ref.read(selectedGonpaProvider.notifier).state = gonpa;
        context.push(OrganizationDetailScreen.routeName).then((_) {
          _resetScanner();
        });
      } else {
        showGonpaSnackBar(context, 'Gonpa not found');
        _resetScanner();
      }
    } catch (e) {
      // Dismiss loading dialog
      Navigator.of(context).pop();

      showGonpaSnackBar(context, 'Error fetching gonpa details');
      _resetScanner();
    }
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

  Future<void> _fetchEventDetails(String id) async {
    try {
      final event = null;
      await ref.read(festivalNotifierProvider.notifier).fetchFestivalById(id);

      // Dismiss loading dialog
      Navigator.of(context).pop();

      if (event != null) {
        // Update selected deity and navigate
        ref.read(selectedFestivalProvider.notifier).state = event;
        context.push(FestivalDetailScreen.routeName).then((_) {
          _resetScanner();
        });
      } else {
        showGonpaSnackBar(context, 'Event not found');
        _resetScanner();
      }
    } catch (e) {
      // Dismiss loading dialog
      Navigator.of(context).pop();

      showGonpaSnackBar(context, 'Error fetching Event details');
      _resetScanner();
    }
  }
}
