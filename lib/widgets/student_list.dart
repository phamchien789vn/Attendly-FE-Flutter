import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentList extends StatelessWidget {
  final List<Student> students;

  const StudentList({Key? key, required this.students}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Center(child: Text('Chưa có học sinh nào trong lớp'));
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(
          leading: CircleAvatar(child: Text(student.name[0])),
          title: Text(student.name),
          subtitle: Text(student.email),
        );
      },
    );
  }
}
