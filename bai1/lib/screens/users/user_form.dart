
import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/styles/app_styles.dart';

class UserForm extends StatelessWidget {
  final UserModel user;

  const UserForm({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(children: [
            CircleAvatar(
              backgroundColor: AppStyles.primary,
              radius: 24,
              child: Text(user.initials,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: AppStyles.titleLarge),
                  Text(user.company.name, style: AppStyles.bodyMedium),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ]),
          const Divider(height: 24),

          // Fields (read-only)
          CustomTextField(
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            controller: TextEditingController(text: user.email),
            readOnly: true,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Điện thoại',
            prefixIcon: Icons.phone_outlined,
            controller: TextEditingController(text: user.phone),
            readOnly: true,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Địa chỉ',
            prefixIcon: Icons.location_on_outlined,
            controller: TextEditingController(text: user.address.fullAddress),
            readOnly: true,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Website',
            prefixIcon: Icons.language_outlined,
            controller: TextEditingController(text: user.website),
            readOnly: true,
          ),
        ],
      ),
    );
  }
}