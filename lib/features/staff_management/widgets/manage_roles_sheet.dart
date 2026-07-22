import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/staff_management/providers/staff_provider.dart';
import 'package:dairy_frontend/features/staff_management/models/role_model.dart';

class ManageRolesSheet extends StatefulWidget {
  const ManageRolesSheet({super.key});

  @override
  State<ManageRolesSheet> createState() => _ManageRolesSheetState();
}

class _ManageRolesSheetState extends State<ManageRolesSheet> {
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _initialLoading = true);
    await context.read<StaffProvider>().loadRoles();
    if (mounted) setState(() => _initialLoading = false);
  }

  void _showCreateRoleSheet() {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _CreateRoleSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffProvider>();
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
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
              Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text('Manage Roles', style: AppTypography.h3),
              const Spacer(),
              GestureDetector(
                onTap: _showCreateRoleSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppDimensions.radiusSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16, color: AppColors.textOnPrimary),
                      const SizedBox(width: 4),
                      Text('New Role', style: AppTypography.caption.copyWith(color: AppColors.textOnPrimary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_initialLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (provider.roleList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.admin_panel_settings_outlined, size: 48,
                        color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    Text('No roles yet', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _showCreateRoleSheet,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create your first role'),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: provider.roleList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final role = provider.roleList[index];
                  return _RoleCard(role: role);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final RoleModel role;

  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.secondaryLight,
            child: Icon(Icons.shield_rounded, size: 18, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role.name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                if (role.description.isNotEmpty)
                  Text(
                    role.description,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${role.userCount}', style: AppTypography.h4),
              Text('users', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateRoleSheet extends StatefulWidget {
  const _CreateRoleSheet();

  @override
  State<_CreateRoleSheet> createState() => _CreateRoleSheetState();
}

class _CreateRoleSheetState extends State<_CreateRoleSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _descCtl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.add_moderator_rounded, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text('Create Role', style: AppTypography.h3),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameCtl,
              decoration: const InputDecoration(
                labelText: 'Role Name *',
                prefixIcon: Icon(Icons.badge_outlined, size: 20),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Role name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 48),
                  child: Icon(Icons.description_outlined, size: 20),
                ),
              ),
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
                    : const Text('Create Role'),
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
    final error = await provider.createRole(
      _nameCtl.text.trim(),
      _descCtl.text.trim(),
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
          content: Text('Role created!'),
          backgroundColor: Color(0xFF0E7C66),
        ),
      );
    }
  }
}
