import 'package:flutter/material.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            ListTile(title: Text('View Payroll')),
            ListTile(title: Text('Submit Daily Report')),
            ListTile(title: Text('Mark Attendance')),
          ],
        ),
      ),
    );
  }
}
