enum RecommendationStatus { pending, approved, rejected, expired }

extension RecommendationStatusExtension on RecommendationStatus {
  String get value {
    switch (this) {
      case RecommendationStatus.pending:
        return 'pending';
      case RecommendationStatus.approved:
        return 'approved';
      case RecommendationStatus.rejected:
        return 'rejected';
      case RecommendationStatus.expired:
        return 'expired';
    }
  }

  static RecommendationStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return RecommendationStatus.pending;
      case 'approved':
        return RecommendationStatus.approved;
      case 'rejected':
        return RecommendationStatus.rejected;
      case 'expired':
        return RecommendationStatus.expired;
      default:
        return RecommendationStatus.pending;
    }
  }
}

enum RecommendationType {
  creditLimitAdjustment,
  supplyModelChange,
  orderQuantityAdjustment,
  collectionPriorityChange,
  deliverySessionChange
}

extension RecommendationTypeExtension on RecommendationType {
  String get value {
    switch (this) {
      case RecommendationType.creditLimitAdjustment:
        return 'credit_limit_adjustment';
      case RecommendationType.supplyModelChange:
        return 'supply_model_change';
      case RecommendationType.orderQuantityAdjustment:
        return 'order_quantity_adjustment';
      case RecommendationType.collectionPriorityChange:
        return 'collection_priority_change';
      case RecommendationType.deliverySessionChange:
        return 'delivery_session_change';
    }
  }

  static RecommendationType fromString(String value) {
    switch (value) {
      case 'credit_limit_adjustment':
        return RecommendationType.creditLimitAdjustment;
      case 'supply_model_change':
        return RecommendationType.supplyModelChange;
      case 'order_quantity_adjustment':
        return RecommendationType.orderQuantityAdjustment;
      case 'collection_priority_change':
        return RecommendationType.collectionPriorityChange;
      case 'delivery_session_change':
        return RecommendationType.deliverySessionChange;
      default:
        return RecommendationType.creditLimitAdjustment;
    }
  }
}

enum FeedbackType { accuracy, relevance, timeliness, helpfulness }

extension FeedbackTypeExtension on FeedbackType {
  String get value {
    switch (this) {
      case FeedbackType.accuracy:
        return 'accuracy';
      case FeedbackType.relevance:
        return 'relevance';
      case FeedbackType.timeliness:
        return 'timeliness';
      case FeedbackType.helpfulness:
        return 'helpfulness';
    }
  }

  static FeedbackType fromString(String value) {
    switch (value) {
      case 'accuracy':
        return FeedbackType.accuracy;
      case 'relevance':
        return FeedbackType.relevance;
      case 'timeliness':
        return FeedbackType.timeliness;
      case 'helpfulness':
        return FeedbackType.helpfulness;
      default:
        return FeedbackType.accuracy;
    }
  }
}

class Recommendation {
  final String id;
  final String entityType;
  final String entityId;
  final RecommendationType? recommendationType;
  final String recommendation;
  final String explanation;
  final double confidence;
  final RecommendationStatus status;
  final Map<String, dynamic>? context;
  final DateTime? createdAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final int version;

  Recommendation({
    required this.id,
    required this.entityType,
    required this.entityId,
    this.recommendationType,
    required this.recommendation,
    required this.explanation,
    this.confidence = 0,
    this.status = RecommendationStatus.pending,
    this.context,
    this.createdAt,
    this.approvedAt,
    this.rejectedAt,
    this.version = 1,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id']?.toString() ?? '',
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id']?.toString() ?? '',
      recommendationType: json['recommendation_type'] != null
          ? RecommendationTypeExtension.fromString(json['recommendation_type'])
          : null,
      recommendation: json['recommendation'] ?? '',
      explanation: json['explanation'] ?? '',
      confidence: (json['confidence'] ?? 0).toDouble(),
      status: json['status'] != null
          ? RecommendationStatusExtension.fromString(json['status'])
          : RecommendationStatus.pending,
      context: json['context'] != null
          ? Map<String, dynamic>.from(json['context'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
      rejectedAt: json['rejected_at'] != null
          ? DateTime.parse(json['rejected_at'])
          : null,
      version: json['version'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'entity_type': entityType,
    'entity_id': entityId,
    if (recommendationType != null) 'recommendation_type': recommendationType!.value,
    'recommendation': recommendation,
    'explanation': explanation,
    'confidence': confidence,
    'status': status.value,
    if (context != null) 'context': context,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    if (approvedAt != null) 'approved_at': approvedAt!.toIso8601String(),
    if (rejectedAt != null) 'rejected_at': rejectedAt!.toIso8601String(),
    'version': version,
  };
}

class ManagerFeedback {
  final String id;
  final String recommendationId;
  final FeedbackType? feedbackType;
  final int rating;
  final String? comments;
  final String? improvementSuggestions;
  final DateTime? submittedAt;

  ManagerFeedback({
    required this.id,
    required this.recommendationId,
    this.feedbackType,
    this.rating = 3,
    this.comments,
    this.improvementSuggestions,
    this.submittedAt,
  });

  factory ManagerFeedback.fromJson(Map<String, dynamic> json) {
    return ManagerFeedback(
      id: json['id']?.toString() ?? '',
      recommendationId: json['recommendation_id']?.toString() ?? '',
      feedbackType: json['feedback_type'] != null
          ? FeedbackTypeExtension.fromString(json['feedback_type'])
          : null,
      rating: json['rating'] ?? 3,
      comments: json['comments'],
      improvementSuggestions: json['improvement_suggestions'],
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'recommendation_id': recommendationId,
    if (feedbackType != null) 'feedback_type': feedbackType!.value,
    'rating': rating,
    if (comments != null) 'comments': comments,
    if (improvementSuggestions != null) 'improvement_suggestions': improvementSuggestions,
    if (submittedAt != null) 'submitted_at': submittedAt!.toIso8601String(),
  };
}
