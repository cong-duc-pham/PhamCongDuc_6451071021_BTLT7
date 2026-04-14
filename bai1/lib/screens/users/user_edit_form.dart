
import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/styles/app_styles.dart';

class UserEditForm extends StatefulWidget {
  final UserModel user;
  final ValueChanged<Map<String, String>>? onSave;

  const UserEditForm({super.key, required this.user, this.onSave});

  @override
  State<UserEditForm> createState() => _UserEditFormState();
}

class _UserEditFormState extends State<UserEditForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController(text: widget.user.name);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave?.call({
      'name':  _nameCtrl.text,
      'email': _emailCtrl.text,
      'phone': _phoneCtrl.text,
    });
    Navigator.pop(context);
  }

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
          const Text('Chỉnh sửa thông tin', style: AppStyles.titleLarge),
          const Divider(height: 20),
          CustomTextField(
            label: 'Họ tên',
            prefixIcon: Icons.person_outline,
            controller: _nameCtrl,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            controller: _emailCtrl,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Điện thoại',
            prefixIcon: Icons.phone_outlined,
            controller: _phoneCtrl,
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Huỷ'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Lưu'),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}