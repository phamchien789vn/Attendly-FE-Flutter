import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../models/session.dart';

class SessionQRDialog extends StatelessWidget {
  final Session session;

  const SessionQRDialog({Key? key, required this.session}) : super(key: key);

  String _getBase64Image(String base64String) {
    // Loại bỏ prefix 'data:image/png;base64,' nếu có
    if (base64String.contains(',')) {
      return base64String.split(',')[1];
    }
    return base64String;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Buổi học ngày ${dateFormat.format(session.startTime)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Image.memory(
              base64Decode(_getBase64Image(session.qrCode)),
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        ),
      ),
    );
  }
}
