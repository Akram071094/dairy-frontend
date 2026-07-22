import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/staff_management/providers/staff_provider.dart';

class InviteStaffSheet extends StatefulWidget {
  const InviteStaffSheet({super.key});

  @override
  State<InviteStaffSheet> createState() => _InviteStaffSheetState();
}

class _InviteStaffSheetState extends State<InviteStaffSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _firstNameCtl = TextEditingController();
  final _lastNameCtl = TextEditingController();
  String? _selectedRoleId;
  bool _submitting = false;
  bool _rolesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _firstNameCtl.dispose();
    _lastNameCtl.dispose();
    super.dispose();
  }

  Future<void> _loadRoles() async {
    setState(() => _rolesLoading = true);
    await context.read<StaffProvider>().loadRoles();
    if (mounted) setState(() => _rolesLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffProvider>();
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person_add_rounded, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text('Invite Staff', style: AppTypography.h3),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Add a new team member to your organization.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailCtl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email *',
                prefixIcon: Icon(Icons.email_outlined, size: 20),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameCtl,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameCtl,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_rolesLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 12),
                    Text('Loading roles...', style: TextStyle(fontSize: 14)),
                  ],
                ),
              )
            else if (provider.roleList.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: AppDimensions.radiusSm,
                ),
                child: Text(
                  'No roles available. Create one first.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Assign Role', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.roleList.map((role) {
                      final selected = _selectedRoleId == role.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedRoleId = selected ? null : role.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : AppColors.surface,
                            borderRadius: AppDimensions.radiusSm,
                            border: Border.all(
                              color: selected ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Text(
                            role.name,
                            style: AppTypography.bodySmall.copyWith(
                              color: selected ? AppColors.textOnPrimary : AppColors.text,
                              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(borderRadius: AppDimensions.radiusMd),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Send Invitation'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    final provider = context.read<StaffProvider>();
    final error = await provider.inviteStaff(
      email: _emailCtl.text.trim(),
      firstName: _firstNameCtl.text.trim(),
      lastName: _lastNameCtl.text.trim(),
      roleId: _selectedRoleId,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invitation sent!'),
          backgroundColor: Color(0xFF0E7C66),
        ),
      );
    }
  }
}
