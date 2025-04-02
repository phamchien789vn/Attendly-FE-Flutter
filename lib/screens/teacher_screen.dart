import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/classroom_service.dart';
import '../models/classroom.dart';
import '../screens/classroom_detail_screen.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final _classroomService = ClassroomService();
  bool _isLoading = false;
  String? _error;
  List<Classroom> _classrooms = [];

  @override
  void initState() {
    super.initState();
    _loadClassrooms();
  }

  Future<void> _loadClassrooms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final classrooms = await _classroomService.getTeacherClassrooms();
      setState(() {
        _classrooms = classrooms;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showCreateClassDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo lớp học mới'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Tên lớp học',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên lớp học';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                setState(() {
                  _isLoading = true;
                });

                try {
                  await _classroomService.createClassroom(
                    nameController.text,
                  );
                  await _loadClassrooms(); // Tải lại danh sách lớp
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tạo lớp học thành công'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _navigateToClassroomDetail(Classroom classroom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassroomDetailScreen(classroom: classroom),
      ),
    ).then((_) {
      // Tải lại danh sách lớp khi quay lại từ trang chi tiết
      _loadClassrooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách lớp học'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadClassrooms,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _classrooms.isEmpty
                  ? const Center(child: Text('Chưa có lớp học nào'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _classrooms.length,
                      itemBuilder: (context, index) {
                        final classroom = _classrooms[index];
                        return Card(
                          child: ListTile(
                            title: Text(classroom.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mã lớp: ${classroom.id}'),
                                Text('Số học sinh: ${classroom.totalStudents}'),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _navigateToClassroomDetail(classroom),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateClassDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
