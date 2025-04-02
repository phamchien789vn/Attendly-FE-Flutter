import 'package:flutter/material.dart';
import '../services/classroom_service.dart';

class CreateSessionDialog extends StatefulWidget {
  final int classroomId;
  final Function() onSessionCreated;

  const CreateSessionDialog({
    Key? key,
    required this.classroomId,
    required this.onSessionCreated,
  }) : super(key: key);

  @override
  State<CreateSessionDialog> createState() => _CreateSessionDialogState();
}

class _CreateSessionDialogState extends State<CreateSessionDialog> {
  final ClassroomService _classroomService = ClassroomService();
  bool _isLoading = false;
  String? _error;

  Future<void> _createSession() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _classroomService.createSession(widget.classroomId);
      if (mounted) {
        widget.onSessionCreated(); // Gọi callback để cập nhật danh sách
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo buổi học thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo buổi học mới'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_error != null) ...[
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
          ],
          if (_isLoading) const CircularProgressIndicator()
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _createSession,
          child: const Text('Tạo'),
        ),
      ],
    );
  }
}
