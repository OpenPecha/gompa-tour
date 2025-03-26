import 'package:flutter/material.dart';

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
    this.overlayColor =
        Colors.black54, // Configurable overlay color with increased opacity
  });

  final Rect scanWindow;
  final double borderRadius;
  final Color overlayColor; // New parameter to allow customization

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the scaling factors to ensure the overlay matches the camera preview
    final double scaleX = size.width / scanWindow.width;
    final double scaleY = size.height / scanWindow.height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    // Calculate the centered scan window based on the canvas size
    // This ensures the scan area is perfectly centered in the camera preview
    final Rect centeredScanWindow = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanWindow.width,
      height: scanWindow.height,
    );

    // Create a background that covers the entire canvas
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create the cutout path with the centered scan window
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          centeredScanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = overlayColor // Use the configurable overlay color
      ..style = PaintingStyle.fill;

    // Create the background with cutout using path combine
    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      centeredScanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // Draw the background with cutout
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    // Draw the border around the scan window
    canvas.drawRRect(borderRect, borderPaint);

    // Add corner markers for better visibility
    // final cornerPaint = Paint()
    //   ..color = Colors.white
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 5.0;

    // // Length of corner markers
    // const cornerLength = 30.0;

    // // Top-left corner
    // canvas.drawLine(
    //   Offset(centeredScanWindow.left, centeredScanWindow.top + cornerLength),
    //   Offset(centeredScanWindow.left, centeredScanWindow.top),
    //   cornerPaint,
    // );
    // canvas.drawLine(
    //   Offset(centeredScanWindow.left, centeredScanWindow.top),
    //   Offset(centeredScanWindow.left + cornerLength, centeredScanWindow.top),
    //   cornerPaint,
    // );

    // // Top-right corner
    // canvas.drawLine(
    //   Offset(centeredScanWindow.right - cornerLength, centeredScanWindow.top),
    //   Offset(centeredScanWindow.right, centeredScanWindow.top),
    //   cornerPaint,
    // );
    // canvas.drawLine(
    //   Offset(centeredScanWindow.right, centeredScanWindow.top),
    //   Offset(centeredScanWindow.right, centeredScanWindow.top + cornerLength),
    //   cornerPaint,
    // );

    // // Bottom-left corner
    // canvas.drawLine(
    //   Offset(centeredScanWindow.left, centeredScanWindow.bottom - cornerLength),
    //   Offset(centeredScanWindow.left, centeredScanWindow.bottom),
    //   cornerPaint,
    // );
    // canvas.drawLine(
    //   Offset(centeredScanWindow.left, centeredScanWindow.bottom),
    //   Offset(centeredScanWindow.left + cornerLength, centeredScanWindow.bottom),
    //   cornerPaint,
    // );

    // // Bottom-right corner
    // canvas.drawLine(
    //   Offset(
    //       centeredScanWindow.right - cornerLength, centeredScanWindow.bottom),
    //   Offset(centeredScanWindow.right, centeredScanWindow.bottom),
    //   cornerPaint,
    // );
    // canvas.drawLine(
    //   Offset(centeredScanWindow.right, centeredScanWindow.bottom),
    //   Offset(
    //       centeredScanWindow.right, centeredScanWindow.bottom - cornerLength),
    //   cornerPaint,
    // );
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius ||
        overlayColor != oldDelegate.overlayColor;
  }
}
