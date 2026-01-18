import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/services/ticket_service.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  final TicketService _ticketService = TicketService();
  bool _isProcessing = false;
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Ticket'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                );
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera View
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Scan Frame Overlay
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryAccent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 100,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkContrast.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.primaryAccent,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Point camera at ticket QR code',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (_isProcessing) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(
                      color: AppColors.primaryAccent,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verifying ticket...',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Corner overlays for scan area
          _buildCornerOverlay(top: 0, left: 0),
          _buildCornerOverlay(top: 0, right: 0),
          _buildCornerOverlay(bottom: 0, left: 0),
          _buildCornerOverlay(bottom: 0, right: 0),
        ],
      ),
    );
  }

  Widget _buildCornerOverlay({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        color: AppColors.darkContrast.withOpacity(0.5),
      ),
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    // Prevent multiple scans
    if (_isProcessing || _hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? qrData = barcodes.first.rawValue;
    if (qrData == null || qrData.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _hasScanned = true;
    });

    // Pause the scanner
    _controller.stop();

    try {
      // Validate the ticket
      final result = await _ticketService.validateTicket(qrData);

      if (!mounted) return;

      // Show result dialog
      await _showResultDialog(result);
    } catch (e) {
      if (mounted) {
        await _showResultDialog({
          'valid': false,
          'error': e.toString(),
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _hasScanned = false;
        });
        // Resume scanning
        _controller.start();
      }
    }
  }

  Future<void> _showResultDialog(Map<String, dynamic>? result) async {
    final isValid = result?['valid'] == true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkContrast,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isValid ? Colors.green : Colors.red,
            width: 2,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isValid
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isValid ? Icons.check_circle : Icons.cancel,
                color: isValid ? Colors.green : Colors.red,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              isValid ? 'VALID TICKET' : 'INVALID TICKET',
              style: AppTypography.heading2.copyWith(
                color: isValid ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // Details
            if (isValid) ...[
              _buildDetailRow('Ticket ID', result?['ticketId'] ?? 'Unknown'),
              _buildDetailRow('Event', result?['eventName'] ?? 'Unknown'),
              _buildDetailRow('Name', result?['userName'] ?? 'Unknown'),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Entry Approved',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                result?['error'] ?? 'Unknown error',
                style: AppTypography.bodyMedium.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              if (result?['usedAt'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  'This ticket was already used',
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? Colors.green : AppColors.primaryAccent,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(isValid ? 'CONTINUE SCANNING' : 'TRY AGAIN'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(
            value,
            style:
                AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
