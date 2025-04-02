import 'package:flutter/material.dart';
import '../models/classroom.dart';
import '../models/session.dart';
import '../models/student.dart';
import '../services/classroom_service.dart';
import '../widgets/create_session_dialog.dart';
import '../widgets/session_qr_dialog.dart';
import '../widgets/student_list.dart';
import '../widgets/session_list.dart';

class ClassroomDetailScreen extends StatefulWidget {
  final Classroom classroom;

  const ClassroomDetailScreen({Key? key, required this.classroom})
      : super(key: key);

  @override
  State<ClassroomDetailScreen> createState() => _ClassroomDetailScreenState();
}

class _ClassroomDetailScreenState extends State<ClassroomDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ClassroomService _classroomService = ClassroomService();
  List<Student>? _students;
  List<Session>? _sessions;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Khi tab thay đổi, cập nhật lại UI để hiển thị/ẩn FAB
      setState(() {});
    });
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final students = await _classroomService.getClassroomStudents(
        widget.classroom.id,
      );
      final sessions = await _classroomService.getClassroomSessions(
        widget.classroom.id,
      );

      setState(() {
        _students = students;
        _sessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createSession() async {
    await showDialog(
      context: context,
      builder: (context) => CreateSessionDialog(
        classroomId: widget.classroom.id,
        onSessionCreated: _loadData,
      ),
    );
  }

  Future<void> _showQRCode(Session session) async {
    await showDialog(
      context: context,
      builder: (context) => SessionQRDialog(session: session),
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
        title: Text(widget.classroom.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Học sinh'), Tab(text: 'Buổi học')],
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
                        onPressed: _loadData,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    StudentList(students: _students!),
                    SessionList(
                      sessions: _sessions!,
                      onQRCodeTap: _showQRCode,
                      classroomId: widget.classroom.id,
                    ),
                  ],
                ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: _createSession,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
