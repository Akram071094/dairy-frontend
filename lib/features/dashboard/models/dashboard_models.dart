import 'package:flutter/material.dart';

class DashboardSummary {
  final int totalRetailers;
  final int activeDeliveries;
  final double todayCollections;
  final int pendingOrders;
  final int lowStockItems;
  final double totalOutstanding;
  final List<RecentActivity> recentActivities;

  DashboardSummary({
    this.totalRetailers = 0,
    this.activeDeliveries = 0,
    this.todayCollections = 0.0,
    this.pendingOrders = 0,
    this.lowStockItems = 0,
    this.totalOutstanding = 0.0,
    this.recentActivities = const [],
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalRetailers: json['total_retailers'] ?? 0,
      activeDeliveries: json['active_deliveries'] ?? 0,
      todayCollections: (json['today_collections'] ?? 0).toDouble(),
      pendingOrders: json['pending_orders'] ?? 0,
      lowStockItems: json['low_stock_items'] ?? 0,
      totalOutstanding: (json['total_outstanding'] ?? 0).toDouble(),
      recentActivities: (json['recent_activities'] as List<dynamic>?)
              ?.map((e) => RecentActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'total_retailers': totalRetailers,
    'active_deliveries': activeDeliveries,
    'today_collections': todayCollections,
    'pending_orders': pendingOrders,
    'low_stock_items': lowStockItems,
    'total_outstanding': totalOutstanding,
    'recent_activities': recentActivities.map((e) => e.toJson()).toList(),
  };
}

class RecentActivity {
  final String id;
  final String type;
  final String description;
  final String entityType;
  final String entityId;
  final DateTime? timestamp;

  RecentActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.entityType,
    required this.entityId,
    this.timestamp,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id']?.toString() ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'description': description,
    'entity_type': entityType,
    'entity_id': entityId,
    'timestamp': timestamp?.toIso8601String(),
  };

  IconData get icon {
    switch (type) {
      case 'retailer_added':
        return Icons.person_add_rounded;
      case 'order_created':
        return Icons.receipt_long_rounded;
      case 'collection_recorded':
        return Icons.payments_rounded;
      case 'delivery_completed':
        return Icons.local_shipping_rounded;
      case 'stock_updated':
        return Icons.inventory_rounded;
      case 'payment_received':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get color {
    switch (type) {
      case 'retailer_added':
        return Colors.green;
      case 'order_created':
        return Colors.orange;
      case 'collection_recorded':
        return Colors.blue;
      case 'delivery_completed':
        return Colors.teal;
      case 'stock_updated':
        return Colors.purple;
      case 'payment_received':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}

class KpiCardData {
  final String label;
  final String value;
  final String? change;
  final bool isPositive;
  final IconData icon;

  KpiCardData({
    required this.label,
    required this.value,
    this.change,
    this.isPositive = true,
    required this.icon,
  });
}
