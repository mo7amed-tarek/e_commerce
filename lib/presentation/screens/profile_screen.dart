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
      backgroundColor: const Color(0xFFF8F9FB),
      body: user == null
          ? const Center(child: Text('No user data'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(user),
                  const SizedBox(height: 24),
                  _buildInfoSection(context, user, cubit),
                  const SizedBox(height: 24),
                  _buildActionsSection(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.05),
                  child: Text(
                    user.name?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.name ?? 'Guest User',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            user.email ?? '',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, UserModel user, AuthCubit cubit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileItem(
            icon: Icons.person_outline,
            label: 'Full Name',
            value: user.name ?? 'Not set',
            onTap: () => _showEditSheet(
              context,
              label: 'Full Name',
              initialValue: user.name ?? '',
              onSave: (val) => cubit.updateUser(name: val),
            ),
          ),
          const Divider(height: 32),
          _buildProfileItem(
            icon: Icons.email_outlined,
            label: 'Email Address',
            value: user.email ?? 'Not set',
            onTap: () => _showEditSheet(
              context,
              label: 'Email Address',
              initialValue: user.email ?? '',
              onSave: (val) => cubit.updateUser(email: val),
            ),
          ),
          const Divider(height: 32),
          _buildProfileItem(
            icon: Icons.phone_android_outlined,
            label: 'Phone Number',
            value: user.phone ?? 'Not set',
            onTap: () => _showEditSheet(
              context,
              label: 'Phone Number',
              initialValue: user.phone ?? '',
              onSave: (val) => cubit.updateUser(phone: val),
            ),
          ),
          const Divider(height: 32),
          _buildProfileItem(
            icon: Icons.location_on_outlined,
            label: 'Home Address',
            value: user.address ?? 'Not set',
            onTap: () => _showEditSheet(
              context,
              label: 'Home Address',
              initialValue: user.address ?? '',
              onSave: (val) => cubit.updateUser(address: val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.black.withOpacity(0.2)),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildActionButton(
            label: 'Order History',
            icon: Icons.shopping_bag_outlined,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: 'Logout',
            icon: Icons.logout_rounded,
            isDanger: true,
            onTap: () {
              context.read<AuthCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isDanger ? Colors.red.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDanger ? Colors.red.withOpacity(0.1) : Colors.transparent,
          ),
          boxShadow: isDanger
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Row(
          children: [
            Icon(icon, color: isDanger ? Colors.red : AppColors.primary, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDanger ? Colors.red : AppColors.primary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: isDanger ? Colors.red.withOpacity(0.3) : AppColors.black.withOpacity(0.2),
            ),
          ],
        ),
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
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Edit $label',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: AppColors.primary),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: AppColors.primary),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    onSave(controller.text.trim());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
