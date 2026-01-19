import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/admin_repository.dart';
import 'user_form_screen.dart';

final usersProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = AdminRepository();
  return repo.getAllUsers();
});

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการผู้ใช้งาน'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(usersProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );
          if (result == true) {
            ref.invalidate(usersProvider);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มผู้ใช้'),
        backgroundColor: Colors.deepPurple,
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('ยังไม่มีผู้ใช้งาน', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserCard(
                user: user,
                onToggleActive: () async {
                  final repo = AdminRepository();
                  await repo.toggleUserActive(user['id']);
                  ref.invalidate(usersProvider);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onToggleActive;

  const _UserCard({required this.user, required this.onToggleActive});

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'clinic_staff':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'แอดมิน';
      case 'clinic_staff':
        return 'เจ้าหน้าที่คลินิก';
      default:
        return 'ผู้ใช้ทั่วไป';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = user['is_active'] ?? true;
    final role = user['role'] ?? 'user';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? _getRoleColor(role).withValues(alpha: 0.15) : Colors.grey.shade200,
          child: Icon(
            role == 'admin' ? Icons.admin_panel_settings : Icons.person,
            color: isActive ? _getRoleColor(role) : Colors.grey,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user['full_name']?.isNotEmpty == true ? user['full_name'] : user['email'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? null : Colors.grey,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getRoleColor(role).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getRoleLabel(role),
                style: TextStyle(fontSize: 12, color: _getRoleColor(role)),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email'] ?? ''),
            if (!isActive)
              const Text(
                'บัญชีถูกระงับ',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
        trailing: Switch(
          value: isActive,
          onChanged: (_) => onToggleActive(),
          activeColor: Colors.green,
        ),
        isThreeLine: !isActive,
      ),
    );
  }
}
