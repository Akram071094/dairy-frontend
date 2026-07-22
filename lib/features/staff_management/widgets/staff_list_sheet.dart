import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/staff_management/providers/staff_provider.dart';
import 'package:dairy_frontend/features/staff_management/models/staff_model.dart';

class StaffListSheet extends StatefulWidget {
  const StaffListSheet({super.key});

  @override
  State<StaffListSheet> createState() => _StaffListSheetState();
}

class _StaffListSheetState extends State<StaffListSheet> {
  final _searchCtl = TextEditingController();
  String? _statusFilter;
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _initialLoading = true);
    await context.read<StaffProvider>().loadStaff();
    if (mounted) setState(() => _initialLoading = false);
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
              Icon(Icons.people_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text('Staff (${provider.totalStaff})', style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchCtl,
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchCtl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchCtl.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _filterChip('All', null),
              const SizedBox(width: 8),
              _filterChip('Active', 'active'),
              const SizedBox(width: 8),
              _filterChip('Inactive', 'inactive'),
              const SizedBox(width: 8),
              _filterChip('Pending', 'pending'),
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
          else if (_displayedStaff(provider).isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.people_outline, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    Text('No staff found', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _displayedStaff(provider).length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final staff = _displayedStaff(provider)[index];
                  return _StaffListTile(staff: staff);
                },
              ),
            ),
        ],
      ),
    );
  }

  List<StaffModel> _displayedStaff(StaffProvider provider) {
    var list = provider.staffList;
    final query = _searchCtl.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((s) =>
        s.fullName.toLowerCase().contains(query) ||
        s.email.toLowerCase().contains(query)
      ).toList();
    }
    if (_statusFilter != null) {
      list = list.where((s) => s.status == _statusFilter).toList();
    }
    return list;
  }

  Widget _filterChip(String label, String? status) {
    final selected = _statusFilter == status;
    return GestureDetector(
      onTap: () => setState(() => _statusFilter = selected ? null : status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _StaffListTile extends StatelessWidget {
  final StaffModel staff;

  const _StaffListTile({required this.staff});

  Color _statusColor(String status) {
    switch (status) {
      case 'active': return AppColors.success;
      case 'inactive': return AppColors.textSecondary;
      case 'pending': return AppColors.warning;
      case 'suspended': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'active': return 'Active';
      case 'inactive': return 'Inactive';
      case 'pending': return 'Pending';
      case 'suspended': return 'Suspended';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              staff.initials,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.fullName.isNotEmpty ? staff.fullName : staff.email,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
                ),
                if (staff.fullName.isNotEmpty)
                  Text(staff.email, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor(staff.status).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _statusLabel(staff.status),
              style: AppTypography.caption.copyWith(
                color: _statusColor(staff.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
