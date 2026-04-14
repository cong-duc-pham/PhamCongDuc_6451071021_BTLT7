// ============================================================
// screens/users/user_table.dart
// ============================================================

import 'package:flutter/material.dart';
import '../../../controllers/user_controller.dart';
import '../../../common/styles/app_styles.dart';
import '../../../data/models/user_model.dart';
import 'user_form.dart';

class UserTable extends StatelessWidget {
  final UserController controller;

  const UserTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Loading
    if (controller.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải danh sách...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // Error
    if (controller.state == UserState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppStyles.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.loadUsers,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    // Empty
    if (controller.users.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Không tìm thấy người dùng', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // Header info
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppStyles.primary.withValues(alpha: 0.07),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${controller.users.length} người dùng',
            style: TextStyle(
              color: AppStyles.primary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),

        // ListView.builder
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  leading: CircleAvatar(
                    backgroundColor: AppStyles.primary,
                    radius: 22,
                    child: Text(
                      user.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  title: Text(user.name,
                      style: AppStyles.titleLarge.copyWith(fontSize: 15)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3),
                      _row(Icons.email_outlined, user.email),
                      _row(Icons.phone_outlined, user.phone),
                      _row(Icons.location_on_outlined, user.address.city),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline, color: AppStyles.primary),
                    onPressed: () => _showDetail(context, user, index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _row(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(children: [
      Icon(icon, size: 13, color: AppStyles.textSecondary),
      const SizedBox(width: 4),
      Expanded(
        child: Text(text,
            style: AppStyles.bodyMedium,
            overflow: TextOverflow.ellipsis),
      ),
    ]),
  );

  void _showDetail(BuildContext context, UserModel user, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => UserForm(user: user),
    );
  }
}