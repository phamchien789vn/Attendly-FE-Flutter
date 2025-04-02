import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session_detail.dart';
import '../models/student.dart';
import '../services/classroom_service.dart';

class SessionDetailScreen extends StatefulWidget {
  final int classroomId;
  final int sessionId;

  const SessionDetailScreen({
    Key? key,
    required this.classroomId,
    required this.sessionId,
  }) : super(key: key);

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ClassroomService _classroomService = ClassroomService();
  SessionDetail? _sessionDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSessionDetail();
  }

  Future<void> _loadSessionDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final sessionDetail = await _classroomService.getSessionDetail(
        widget.classroomId,
        widget.sessionId,
      );
      setState(() {
        _sessionDetail = sessionDetail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildStudentList(List<Student> students, bool isAttended) {
    if (students.isEmpty) {
      return Center(
        child: Text(
          isAttended
              ? 'Chưa có học sinh nào điểm danh'
              : 'Tất cả học sinh đã điểm danh',
        ),
      );
    }

    final dateFormat = DateFormat('HH:mm:ss dd/MM/yyyy');

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(student.name.isNotEmpty ? student.name[0] : '?'),
          ),
          title: Text(student.name),
          subtitle: Text(student.email),
          trailing: isAttended && student.attendedAt != null
              ? Text(
                  'Điểm danh lúc:\n${dateFormat.format(student.attendedAt!)}',
                  textAlign: TextAlign.end,
                )
              : null,
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_sessionDetail?.className ?? 'Chi tiết điểm danh'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đã điểm danh'),
            Tab(text: 'Chưa điểm danh'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSessionDetail,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Tổng số',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _sessionDetail!.attendance.total.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Đã điểm danh',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _sessionDetail!.attendance.attended.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.green,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Tỷ lệ',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _sessionDetail!.attendance.attendanceRate,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildStudentList(
                              _sessionDetail!.attendedStudents, true),
                          _buildStudentList(
                              _sessionDetail!.notAttendedStudents, false),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
