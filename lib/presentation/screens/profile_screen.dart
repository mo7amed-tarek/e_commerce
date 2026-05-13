import 'package:ecommerce/auth/presentation/cubits/auth_cubit.dart';
import 'package:ecommerce/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/data/models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AuthCubit>();
    final UserModel? user = cubit.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: Text('No user data'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${user.name ?? ''}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? '',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),

                  _buildField(
                    context,
                    label: 'Your full name',
                    value: user.name ?? '',
                    onSave: (val) => cubit.updateUser(name: val),
                  ),
                  _buildField(
                    context,
                    label: 'Your E-mail',
                    value: user.email ?? '',
                    onSave: (val) => cubit.updateUser(email: val),
                  ),
                  _buildField(
                    context,
                    label: 'Your password',
                    value: '***************',
                  ),
                  _buildField(
                    context,
                    label: 'Your mobile number',
                    value: user.phone ?? '',
                    onSave: (val) => cubit.updateUser(phone: val),
                  ),
                  _buildField(
                    context,
                    label: 'Your Address',
                    value: user.address ?? '',
                    onSave: (val) => cubit.updateUser(address: val),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required String value,
    Function(String)? onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            readOnly: true,
            style: TextStyle(color: AppColors.primary),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              suffixIcon: onSave == null
                  ? null
                  : IconButton(
                      icon: Icon(Icons.edit_outlined, color: AppColors.primary),
                      onPressed: () {
                        _showEditSheet(
                          context,
                          label: label,
                          initialValue: value,
                          onSave: onSave,
                        );
                      },
                    ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(
    BuildContext context, {
    required String label,
    required String initialValue,
    required Function(String) onSave,
  }) {
    final controller = TextEditingController(text: initialValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit $label',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                style: TextStyle(color: AppColors.primary),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  onSave(controller.text.trim());
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
