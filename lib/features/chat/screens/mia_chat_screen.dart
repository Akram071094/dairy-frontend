import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dairy_frontend/core/constants/app_constants.dart';
import 'package:dairy_frontend/core/theme/app_colors.dart';
import 'package:dairy_frontend/core/theme/app_dimensions.dart';
import 'package:dairy_frontend/core/theme/app_typography.dart';
import 'package:dairy_frontend/features/auth/providers/auth_provider.dart';
import 'package:dairy_frontend/shared/widgets/display/ai_assistant_avatar.dart';

class MiaChatScreen extends StatefulWidget {
  const MiaChatScreen({super.key});

  @override
  State<MiaChatScreen> createState() => _MiaChatScreenState();
}

class _MiaChatScreenState extends State<MiaChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  final List<_FeatureStub> _features = const [
    _FeatureStub(
      title: 'Retailers',
      description: 'Add and manage your retailer network, credit limits & contacts.',
      icon: Icons.storefront_rounded,
      gradient: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    ),
    _FeatureStub(
      title: 'Inventory',
      description: 'Track products, stock and batches in real time.',
      icon: Icons.inventory_2_rounded,
      gradient: [Color(0xFF0D9488), Color(0xFF0F766E)],
    ),
    _FeatureStub(
      title: 'Planning & Delivery',
      description: 'Plan routes and schedule deliveries to retailers.',
      icon: Icons.local_shipping_rounded,
      gradient: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    ),
    _FeatureStub(
      title: 'Collections',
      description: 'Record payments and follow up on outstanding dues.',
      icon: Icons.payments_rounded,
      gradient: [Color(0xFFDB2777), Color(0xFFBE185D)],
    ),
  ];

  final List<String> _suggestions = const [
    'Add a retailer',
    'Check my inventory',
    'Plan today\'s deliveries',
    'Record a collection',
    'How can you help me?',
  ];

  @override
  void initState() {
    super.initState();
    final userName = context.read<AuthProvider>().currentUser?.firstName;
    _messages.add(
      _ChatMessage(
        isUser: false,
        text: userName != null && userName.isNotEmpty
            ? 'Hi $userName! I\'m ${AppConstants.aiAssistantName}, your AI assistant for ${AppConstants.appName}.'
            : 'Hi! I\'m ${AppConstants.aiAssistantName}, your AI assistant for ${AppConstants.appName}.',
      ),
    );
    _messages.add(
      _ChatMessage(
        isUser: false,
        text:
            'Everything you need runs right here through me. Tap a feature below or just ask — I\'ll take care of it. Most modules are launching soon, so tell me what you\'d like to do and I\'ll set it up for you.',
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: trimmed));
    });
    _messageController.clear();
    _scrollToBottom();
    _simulateMiaReply(trimmed);
  }

  void _simulateMiaReply(String userMessage) {
    final reply = _buildReply(userMessage);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(isUser: false, text: reply));
      });
      _scrollToBottom();
    });
  }

  String _buildReply(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('retailer')) {
      return 'Great — I can add a new retailer and set their credit limit. The Retailers module is launching soon, but tell me the name and location and I\'ll prepare the record for you. 🚀';
    }
    if (lower.contains('inventory') || lower.contains('stock')) {
      return 'Inventory tracking is launching soon! Once it\'s live I\'ll show you real-time stock and low-stock alerts right here. What product should we keep an eye on?';
    }
    if (lower.contains('deliver') || lower.contains('route') || lower.contains('plan')) {
      return 'Planning & Delivery is launching soon. When it\'s ready I\'ll build optimized routes and dispatch schedules for you — just say the word and I\'ll queue it up.';
    }
    if (lower.contains('collect') || lower.contains('payment') || lower.contains('due')) {
      return 'Collections is launching soon. I\'ll help you log payments and chase outstanding dues the moment it\'s live. Want me to note a pending collection?';
    }
    if (lower.contains('help') || lower.contains('what can') || lower.contains('how')) {
      return 'I can help you with Retailers, Inventory, Planning & Delivery and Collections — all managed through this chat. These modules are launching soon, so for now just tell me what you need and I\'ll get it ready. 💡';
    }
    return 'Got it! I\'ve noted that. Most features are launching soon, but I\'ll handle the work for you right here — tell me a bit more and I\'ll take care of it. ✨';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDim,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  ..._messages.map((m) => _ChatBubble(message: m)),
                  const SizedBox(height: 16),
                  _buildFeatureStubs(),
                  const SizedBox(height: 12),
                  _buildSuggestions(),
                ],
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const AiAssistantAvatar(size: 44, mood: AiMood.smiling),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.aiAssistantName,
                  style: AppTypography.h3.copyWith(color: Colors.white),
                ),
                Text(
                  'Your AI assistant · ${AppConstants.appName}',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppDimensions.radiusFull,
            ),
            child: Text(
              'Online',
              style: AppTypography.caption.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureStubs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What I can do', style: AppTypography.h3),
        const SizedBox(height: 12),
        ..._features.map((f) => _FeatureStubCard(stub: f)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFDB2777)],
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
                  'Launching soon — these modules are being prepared. For now, just chat with me and I\'ll handle the rest!',
                  style: AppTypography.body.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _suggestions
          .map(
            (s) => InkWell(
              onTap: () => _sendMessage(s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppDimensions.radiusFull,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                ),
                child: Text(
                  s,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDim,
                borderRadius: AppDimensions.radiusFull,
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _messageController,
                onSubmitted: _sendMessage,
                decoration: const InputDecoration(
                  hintText: 'Ask ${'Mia'} anything…',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: () => _sendMessage(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;

  const _ChatMessage({required this.isUser, required this.text});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const AiAssistantAvatar(size: 32, mood: AiMood.smiling),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.primary : AppColors.surface,
                borderRadius: AppDimensions.radiusLg.copyWith(
                  bottomLeft: message.isUser
                      ? AppDimensions.radiusLg.bottomLeft
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : AppDimensions.radiusLg.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: AppTypography.bodySmall.copyWith(
                  color: message.isUser ? Colors.white : AppColors.text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureStub {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  const _FeatureStub({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}

class _FeatureStubCard extends StatelessWidget {
  final _FeatureStub stub;

  const _FeatureStubCard({required this.stub});

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
                colors: stub.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppDimensions.radiusMd,
            ),
            child: Icon(stub.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stub.title, style: AppTypography.h4),
                const SizedBox(height: 4),
                Text(
                  stub.description,
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
