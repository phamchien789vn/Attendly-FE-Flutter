import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;
import '../providers/auth_provider.dart';
import '../services/attendance_service.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  MobileScannerController? controller;
  bool _isScanning = false;
  bool _isProcessing = false;
  String? _error;
  String? _success;
  final AttendanceService _attendanceService = AttendanceService();
  final ImagePicker _picker = ImagePicker();
  final mlkit.BarcodeScanner _barcodeScanner =
      mlkit.BarcodeScanner(formats: [mlkit.BarcodeFormat.qrCode]);

  @override
  void dispose() {
    controller?.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  void _startScanning() {
    controller = MobileScannerController();
    setState(() {
      _isScanning = true;
      _error = null;
      _success = null;
    });
  }

  void _stopScanning() {
    controller?.dispose();
    controller = null;
    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _processQRCode(String code) async {
    try {
      // Kiểm tra định dạng mã QR
      if (!code.startsWith('attendance/class:')) {
        throw Exception('Mã QR không hợp lệ');
      }

      // Tách thông tin từ mã QR
      final parts = code.split('/');
      if (parts.length != 3) {
        throw Exception('Định dạng mã QR không đúng');
      }

      final classPart = parts[1];
      final sessionPart = parts[2];

      if (!classPart.startsWith('class:') ||
          !sessionPart.startsWith('session:')) {
        throw Exception('Định dạng mã QR không đúng');
      }

      final classId = classPart.replaceAll('class:', '');
      final sessionId = sessionPart.replaceAll('session:', '');

      // Gọi API điểm danh với thông tin đã tách
      await _attendanceService.markAttendance(code);

      setState(() {
        _success = 'Điểm danh thành công!';
        _isScanning = false;
      });
      _stopScanning();

      // Hiển thị dialog xác nhận
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Điểm danh thành công'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bạn đã điểm danh thành công!'),
                const SizedBox(height: 8),
                Text('Mã lớp: $classId'),
                Text('Mã phiên: $sessionId'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startScanning(); // Bắt đầu quét tiếp
                },
                child: const Text('Quét tiếp'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _stopScanning(); // Dừng quét và quay lại màn hình chính
                },
                child: const Text('Hoàn thành'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isProcessing = false;
      });
    }
  }

  Future<void> _pickQRCode() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        _isProcessing = true;
        _error = null;
        _success = null;
      });

      final inputImage = mlkit.InputImage.fromFile(File(image.path));
      final List<mlkit.Barcode> barcodes =
          await _barcodeScanner.processImage(inputImage);

      if (barcodes.isEmpty) {
        setState(() {
          _error = 'Không tìm thấy mã QR trong ảnh';
          _isProcessing = false;
        });
        return;
      }

      final String? code = barcodes.first.rawValue;
      if (code == null) {
        setState(() {
          _error = 'Không thể đọc được mã QR';
          _isProcessing = false;
        });
        return;
      }

      await _processQRCode(code);
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isProcessing = false;
      });
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || !_isScanning) return;
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    setState(() {
      _isProcessing = true;
    });

    await _processQRCode(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điểm danh'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isScanning && controller != null
                ? MobileScanner(
                    controller: controller!,
                    onDetect: _onDetect,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner,
                          size: 100,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nhấn nút bên dưới để bắt đầu quét mã QR\nhoặc chọn ảnh mã QR từ thư viện',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        if (_success != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _success!,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing
                          ? null
                          : () {
                              if (_isScanning) {
                                _stopScanning();
                              } else {
                                _startScanning();
                              }
                            },
                      icon: Icon(
                          _isScanning ? Icons.stop : Icons.qr_code_scanner),
                      label: Text(_isScanning ? 'Dừng quét' : 'Quét mã QR'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _isProcessing || _isScanning ? null : _pickQRCode,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Chọn từ thư viện'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
