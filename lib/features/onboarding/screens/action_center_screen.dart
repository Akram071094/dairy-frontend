import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/router/app_router.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/auth/providers/auth_provider.dart';
import 'package:dairy_frontend/shared/widgets/display/ai_assistant_avatar.dart';
import 'package:dairy_frontend/features/staff_management/widgets/invite_staff_sheet.dart';
import 'package:dairy_frontend/features/staff_management/widgets/staff_list_sheet.dart';
import 'package:dairy_frontend/features/staff_management/widgets/manage_roles_sheet.dart';
import 'package:dairy_frontend/features/staff_management/providers/staff_provider.dart';

class ActionCenterScreen extends StatefulWidget {
  const ActionCenterScreen({super.key});

  @override
  State<ActionCenterScreen> createState() => _ActionCenterScreenState();
}

class _ActionCenterScreenState extends State<ActionCenterScreen> {
  Future<void> _logout() async {
    final auth = context.read<AuthProvider>();
    await auth.logout();
    if (mounted) context.go(AppRouter.welcome);
  }

  void _runAutomation(_Automation item) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AutomationSheet(item: item),
    );
  }

  // Colorful feature roadmap shown inside the Action Center.
  final List<_Feature> _features = const [
    _Feature(
      title: 'Retailers',
      description: 'Mia registers and manages your retailer & shop network.',
      icon: Icons.storefront_rounded,
      gradient: [Color(0xFF0E7C66), Color(0xFF0A5A4A)],
    ),
    _Feature(
      title: 'Inventory',
      description: 'Real-time stock, products and batches — tracked for you.',
      icon: Icons.inventory_2_rounded,
      gradient: [Color(0xFF5BA82E), Color(0xFF3F7E1E)],
    ),
    _Feature(
      title: 'Planning & Delivery',
      description: 'Mia plans routes and schedules deliveries for you.',
      icon: Icons.local_shipping_rounded,
      gradient: [Color(0xFFE0A106), Color(0xFFB97E04)],
    ),
    _Feature(
      title: 'Collections',
      description: 'Payments recorded and dues chased by Mia, hands-free.',
      icon: Icons.payments_rounded,
      gradient: [Color(0xFFC2410C), Color(0xFF9A3412)],
    ),
    _Feature(
      title: 'Mia — Your AI Assistant',
      description: 'Onboards retailers, runs morning & evening briefs, and does the work for you.',
      icon: Icons.auto_awesome_rounded,
      gradient: [Color(0xFF0E7C66), Color(0xFF5BA82E)],
      isMia: true,
    ),
  ];

  final List<_Automation> _automations = const [
    _Automation(
      title: 'Ask Mia to onboard retailers & shops',
      description: 'Just tell Mia your retailers — she registers them and their shops, no forms.',
      icon: Icons.group_add_rounded,
      steps: [
        'Listening to your retailer list…',
        'Creating shop profiles…',
        'Setting credit limits…',
        'Done — your network is live!',
      ],
    ),
    _Automation(
      title: 'Ask Mia for your morning summary',
      description: 'Each morning Mia tells you what\'s due, what\'s low, and what to dispatch.',
      icon: Icons.wb_sunny_rounded,
      steps: [
        'Gathering yesterday\'s collections…',
        'Checking stock levels…',
        'Planning today\'s deliveries…',
        'Your morning brief is ready!',
      ],
    ),
    _Automation(
      title: 'Ask Mia for your evening brief',
      description: 'At day\'s end Mia reports collections, deliveries and follow-ups.',
      icon: Icons.nightlight_round,
      steps: [
        'Reconciling deliveries…',
        'Summarizing collections…',
        'Flagging pending dues…',
        'Your evening brief is ready!',
      ],
    ),
    _Automation(
      title: 'Ask Mia to handle collections',
      description: 'Mia follows up on outstanding dues and logs payments for you.',
      icon: Icons.receipt_long_rounded,
      steps: [
        'Scanning outstanding invoices…',
        'Sending reminders to retailers…',
        'Recording incoming payments…',
        'Collections up to date!',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<AuthProvider>().currentUser?.firstName;
    return Scaffold(
      backgroundColor: AppColors.surfaceDim,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(onLogout: _logout),
              const SizedBox(height: 20),
              _Hero(userName: userName),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0E7C66), Color(0xFF5BA82E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppDimensions.radiusLg,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.rocket_launch_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Launching soon — talk to Mia and she does the work for you, automatically.',
                        style: AppTypography.body.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Features', style: AppTypography.h3),
              const SizedBox(height: 12),
              ..._features.map((f) => _FeatureCard(feature: f)),
              const SizedBox(height: 24),
              Text('Talk to Mia', style: AppTypography.h3),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: _automations
                    .map((a) => _AutomationTile(
                          automation: a,
                          onTap: () => _runAutomation(a),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text('Staff', style: AppTypography.h3),
              const SizedBox(height: 12),
              _StaffStats(),
              const SizedBox(height: 12),
              _AccountTile(
                icon: Icons.person_add_rounded,
                title: 'Invite Staff',
                onTap: _showInviteStaffSheet,
              ),
              _AccountTile(
                icon: Icons.people_rounded,
                title: 'View All Staff',
                onTap: _showStaffListSheet,
              ),
              _AccountTile(
                icon: Icons.admin_panel_settings_rounded,
                title: 'Manage Roles',
                onTap: _showManageRolesSheet,
              ),
              const SizedBox(height: 24),
              Text('Account', style: AppTypography.h3),
              const SizedBox(height: 12),
              _AccountTile(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                onTap: _showChangePasswordSheet,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  void _showInviteStaffSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const InviteStaffSheet(),
    );
  }

  void _showStaffListSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const StaffListSheet(),
    );
  }

  void _showManageRolesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ManageRolesSheet(),
    );
  }
}

class _Hero extends StatelessWidget {
  final String? userName;

  const _Hero({this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7C66), Color(0xFF0A5A4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDimensions.radiusXl,
      ),
      child: Row(
        children: [
          const AiAssistantAvatar(size: 60, mood: AiMood.smiling),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName != null && userName!.isNotEmpty
                      ? 'Welcome, $userName!'
                      : 'Welcome to ${AppConstants.appName}!',
                  style: AppTypography.h3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppConstants.aiAssistantName} runs your dairy business — onboarding, briefs and collections, all automated.',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onLogout;

  const _Header({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7C66), Color(0xFF5BA82E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDimensions.radiusLg,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: AppDimensions.radiusMd,
            ),
            child: const Center(
              child: Icon(
                Icons.agriculture_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppConstants.appName} · Action Center',
                  style: AppTypography.h3.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Your smart dairy command center',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final bool isMia;

  const _Feature({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    this.isMia = false,
  });
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.radiusLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: feature.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppDimensions.radiusMd,
            ),
            child: Icon(feature.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.title, style: AppTypography.h4),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: AppDimensions.radiusFull,
            ),
            child: Text(
              'Soon',
              style: AppTypography.caption.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Automation {
  final String title;
  final String description;
  final IconData icon;
  final List<String> steps;

  const _Automation({
    required this.title,
    required this.description,
    required this.icon,
    required this.steps,
  });
}

class _AutomationTile extends StatelessWidget {
  final _Automation automation;
  final VoidCallback onTap;

  const _AutomationTile({
    required this.automation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.radiusLg,
      child: Container(
        padding: AppDimensions.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppDimensions.radiusLg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppDimensions.radiusMd,
              ),
              child: Icon(automation.icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 12),
            Text(automation.title, style: AppTypography.h4),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                automation.description,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: AppDimensions.radiusFull,
              ),
              child: Text(
                'Tap to run',
                style: AppTypography.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffProvider>();
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
          _statItem(context, '${provider.totalStaff}', 'Total', Icons.people_rounded),
          Container(width: 1, height: 32, color: AppColors.border),
          _statItem(context, '${provider.activeStaff}', 'Active', Icons.check_circle_rounded),
          Container(width: 1, height: 32, color: AppColors.border),
          _statItem(context, '${provider.pendingInvitations}', 'Pending', Icons.hourglass_empty_rounded),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.h4.copyWith(color: AppColors.text)),
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AccountTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppDimensions.radiusMd,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(title, style: AppTypography.body),
                const Spacer(),
                Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentPwdCtl = TextEditingController();
  final _newPwdCtl = TextEditingController();
  final _confirmPwdCtl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _submitting = false;

  @override
  void dispose() {
    _currentPwdCtl.dispose();
    _newPwdCtl.dispose();
    _confirmPwdCtl.dispose();
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
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Change Password', style: AppTypography.h3),
            const SizedBox(height: 4),
            Text(
              'Enter your current password and a new one.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _currentPwdCtl,
              obscureText: _obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility, size: 20),
                  onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPwdCtl,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility, size: 20),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (v.length < 6) return 'At least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPwdCtl,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, size: 20),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (v != _newPwdCtl.text) return 'Passwords do not match';
                return null;
              },
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
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.radiusMd,
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Change Password'),
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
    final auth = context.read<AuthProvider>();
    final error = await auth.changePassword(
      _currentPwdCtl.text,
      _newPwdCtl.text,
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
          content: Text('Password changed successfully'),
          backgroundColor: Color(0xFF0E7C66),
        ),
      );
    }
  }
}

class _AutomationSheet extends StatefulWidget {
  final _Automation item;

  const _AutomationSheet({required this.item});

  @override
  State<_AutomationSheet> createState() => _AutomationSheetState();
}

class _AutomationSheetState extends State<_AutomationSheet> {
  int _step = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    for (var i = 0; i < widget.item.steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() => _step = i + 1);
    }
    if (mounted) setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const AiAssistantAvatar(size: 44, mood: AiMood.thinking),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${AppConstants.aiAssistantName} is working',
                  style: AppTypography.h3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(widget.item.title, style: AppTypography.body),
          const SizedBox(height: 16),
          ...widget.item.steps.asMap().entries.map((e) {
            final index = e.key;
            final text = e.value;
            final active = index < _step;
            final current = index == _step - 1 && !_done;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.success
                          : AppColors.surfaceDim,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      active ? Icons.check : Icons.circle,
                      size: 14,
                      color: active ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTypography.bodySmall.copyWith(
                        color: active ? AppColors.text : AppColors.textSecondary,
                        fontWeight: current ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (current)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          if (_done)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.radiusMd,
                  ),
                ),
                child: const Text('Done'),
              ),
            )
          else
            Text(
              'Automating for you…',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
