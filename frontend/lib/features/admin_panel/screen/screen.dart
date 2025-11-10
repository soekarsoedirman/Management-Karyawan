import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            ListTile(title: Text('Manage Users')),
            ListTile(title: Text('Manage Schedules')),
            ListTile(title: Text('Manage Roles')),
            ListTile(title: Text('Payroll / Bonuses')),
            ListTile(title: Text('View Reports')),
          ],
        ),
      ),
    );
  }
}
