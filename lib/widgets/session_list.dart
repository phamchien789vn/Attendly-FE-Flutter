import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';
import '../screens/session_detail_screen.dart';

class SessionList extends StatelessWidget {
  final List<Session> sessions;
  final Function(Session) onQRCodeTap;
  final int classroomId;

  const SessionList({
    Key? key,
    required this.sessions,
    required this.onQRCodeTap,
    required this.classroomId,
  }) : super(key: key);

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'IN_PROGRESS':
        return Colors.green;
      case 'UPCOMING':
        return Colors.blue;
      case 'ENDED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'IN_PROGRESS':
        return 'Đang diễn ra';
      case 'UPCOMING':
        return 'Sắp diễn ra';
      case 'ENDED':
        return 'Đã kết thúc';
      default:
        return status ?? 'Chưa xác định';
    }
  }

  void _navigateToSessionDetail(BuildContext context, Session session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionDetailScreen(
          classroomId: classroomId,
          sessionId: session.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(
        child: Text('Chưa có buổi học nào'),
      );
    }

    final dateFormat = DateFormat('HH:mm dd/MM/yyyy');

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buổi học ${session.id}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(session.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(session.status),
                        ),
                      ),
                      child: Text(
                        _getStatusText(session.status),
                        style: TextStyle(
                          color: _getStatusColor(session.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Thời gian: ${dateFormat.format(session.startTime)} - ${dateFormat.format(session.endTime)}',
                ),
                Text('Thời lượng: ${session.duration}'),
                if (session.status == 'IN_PROGRESS')
                  Text('Còn lại: ${session.remainingTime}'),
                const SizedBox(height: 8),
                Text('Điểm danh: ${session.totalAttendance} học sinh'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (session.isActive)
                      TextButton.icon(
                        onPressed: () => onQRCodeTap(session),
                        icon: const Icon(Icons.qr_code),
                        label: const Text('Mã QR'),
                      ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () =>
                          _navigateToSessionDetail(context, session),
                      icon: const Icon(Icons.people),
                      label: const Text('Chi tiết điểm danh'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
