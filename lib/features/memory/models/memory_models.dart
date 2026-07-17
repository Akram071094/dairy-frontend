enum EntityType { retailer, product, sku, supplier, staff, delivery }

extension EntityTypeExtension on EntityType {
  String get value {
    switch (this) {
      case EntityType.retailer:
        return 'retailer';
      case EntityType.product:
        return 'product';
      case EntityType.sku:
        return 'sku';
      case EntityType.supplier:
        return 'supplier';
      case EntityType.staff:
        return 'staff';
      case EntityType.delivery:
        return 'delivery';
    }
  }

  static EntityType fromString(String value) {
    switch (value) {
      case 'retailer':
        return EntityType.retailer;
      case 'product':
        return EntityType.product;
      case 'sku':
        return EntityType.sku;
      case 'supplier':
        return EntityType.supplier;
      case 'staff':
        return EntityType.staff;
      case 'delivery':
        return EntityType.delivery;
      default:
        return EntityType.retailer;
    }
  }
}

enum ObservationType {
  paymentPattern,
  orderPattern,
  deliveryPreference,
  collectionBehavior
}

extension ObservationTypeExtension on ObservationType {
  String get value {
    switch (this) {
      case ObservationType.paymentPattern:
        return 'payment_pattern';
      case ObservationType.orderPattern:
        return 'order_pattern';
      case ObservationType.deliveryPreference:
        return 'delivery_preference';
      case ObservationType.collectionBehavior:
        return 'collection_behavior';
    }
  }

  static ObservationType fromString(String value) {
    switch (value) {
      case 'payment_pattern':
        return ObservationType.paymentPattern;
      case 'order_pattern':
        return ObservationType.orderPattern;
      case 'delivery_preference':
        return ObservationType.deliveryPreference;
      case 'collection_behavior':
        return ObservationType.collectionBehavior;
      default:
        return ObservationType.paymentPattern;
    }
  }
}

enum PatternFrequency { daily, weekly, monthly, quarterly }

extension PatternFrequencyExtension on PatternFrequency {
  String get value {
    switch (this) {
      case PatternFrequency.daily:
        return 'daily';
      case PatternFrequency.weekly:
        return 'weekly';
      case PatternFrequency.monthly:
        return 'monthly';
      case PatternFrequency.quarterly:
        return 'quarterly';
    }
  }

  static PatternFrequency fromString(String value) {
    switch (value) {
      case 'daily':
        return PatternFrequency.daily;
      case 'weekly':
        return PatternFrequency.weekly;
      case 'monthly':
        return PatternFrequency.monthly;
      case 'quarterly':
        return PatternFrequency.quarterly;
      default:
        return PatternFrequency.daily;
    }
  }
}

enum DecisionOutcome { positive, negative, neutral }

extension DecisionOutcomeExtension on DecisionOutcome {
  String get value {
    switch (this) {
      case DecisionOutcome.positive:
        return 'positive';
      case DecisionOutcome.negative:
        return 'negative';
      case DecisionOutcome.neutral:
        return 'neutral';
    }
  }

  static DecisionOutcome fromString(String value) {
    switch (value) {
      case 'positive':
        return DecisionOutcome.positive;
      case 'negative':
        return DecisionOutcome.negative;
      case 'neutral':
        return DecisionOutcome.neutral;
      default:
        return DecisionOutcome.neutral;
    }
  }
}

enum BehaviourTrend { increasing, decreasing, stable, volatile }

extension BehaviourTrendExtension on BehaviourTrend {
  String get value {
    switch (this) {
      case BehaviourTrend.increasing:
        return 'increasing';
      case BehaviourTrend.decreasing:
        return 'decreasing';
      case BehaviourTrend.stable:
        return 'stable';
      case BehaviourTrend.volatile:
        return 'volatile';
    }
  }

  static BehaviourTrend fromString(String value) {
    switch (value) {
      case 'increasing':
        return BehaviourTrend.increasing;
      case 'decreasing':
        return BehaviourTrend.decreasing;
      case 'stable':
        return BehaviourTrend.stable;
      case 'volatile':
        return BehaviourTrend.volatile;
      default:
        return BehaviourTrend.stable;
    }
  }
}

class BusinessObservation {
  final String id;
  final EntityType? entityType;
  final String entityId;
  final ObservationType? observationType;
  final String observation;
  final double confidence;
  final String? source;
  final String? sourceId;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;

  BusinessObservation({
    required this.id,
    this.entityType,
    required this.entityId,
    this.observationType,
    required this.observation,
    this.confidence = 0,
    this.source,
    this.sourceId,
    this.metadata,
    this.createdAt,
  });

  factory BusinessObservation.fromJson(Map<String, dynamic> json) {
    return BusinessObservation(
      id: json['id']?.toString() ?? '',
      entityType: json['entity_type'] != null
          ? EntityTypeExtension.fromString(json['entity_type'])
          : null,
      entityId: json['entity_id']?.toString() ?? '',
      observationType: json['observation_type'] != null
          ? ObservationTypeExtension.fromString(json['observation_type'])
          : null,
      observation: json['observation'] ?? '',
      confidence: (json['confidence'] ?? 0).toDouble(),
      source: json['source'],
      sourceId: json['source_id']?.toString(),
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (entityType != null) 'entity_type': entityType!.value,
    'entity_id': entityId,
    if (observationType != null) 'observation_type': observationType!.value,
    'observation': observation,
    'confidence': confidence,
    if (source != null) 'source': source,
    if (sourceId != null) 'source_id': sourceId,
    if (metadata != null) 'metadata': metadata,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
  };
}

class BusinessPattern {
  final String id;
  final String entityType;
  final String entityId;
  final String patternType;
  final String pattern;
  final double confidence;
  final PatternFrequency? frequency;
  final DateTime? firstObserved;
  final DateTime? lastObserved;
  final int observationCount;

  BusinessPattern({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.patternType,
    required this.pattern,
    this.confidence = 0,
    this.frequency,
    this.firstObserved,
    this.lastObserved,
    this.observationCount = 0,
  });

  factory BusinessPattern.fromJson(Map<String, dynamic> json) {
    return BusinessPattern(
      id: json['id']?.toString() ?? '',
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id']?.toString() ?? '',
      patternType: json['pattern_type'] ?? '',
      pattern: json['pattern'] ?? '',
      confidence: (json['confidence'] ?? 0).toDouble(),
      frequency: json['frequency'] != null
          ? PatternFrequencyExtension.fromString(json['frequency'])
          : null,
      firstObserved: json['first_observed'] != null
          ? DateTime.parse(json['first_observed'])
          : null,
      lastObserved: json['last_observed'] != null
          ? DateTime.parse(json['last_observed'])
          : null,
      observationCount: json['observation_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'entity_type': entityType,
    'entity_id': entityId,
    'pattern_type': patternType,
    'pattern': pattern,
    'confidence': confidence,
    if (frequency != null) 'frequency': frequency!.value,
    if (firstObserved != null) 'first_observed': firstObserved!.toIso8601String(),
    if (lastObserved != null) 'last_observed': lastObserved!.toIso8601String(),
    'observation_count': observationCount,
  };
}

class ManagerDecision {
  final String id;
  final String entityType;
  final String entityId;
  final String decisionType;
  final String decision;
  final String? rationale;
  final DecisionOutcome? outcome;
  final DateTime? decisionDate;
  final List<String> relatedObservationIds;

  ManagerDecision({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.decisionType,
    required this.decision,
    this.rationale,
    this.outcome,
    this.decisionDate,
    this.relatedObservationIds = const [],
  });

  factory ManagerDecision.fromJson(Map<String, dynamic> json) {
    return ManagerDecision(
      id: json['id']?.toString() ?? '',
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id']?.toString() ?? '',
      decisionType: json['decision_type'] ?? '',
      decision: json['decision'] ?? '',
      rationale: json['rationale'],
      outcome: json['outcome'] != null
          ? DecisionOutcomeExtension.fromString(json['outcome'])
          : null,
      decisionDate: json['decision_date'] != null
          ? DateTime.parse(json['decision_date'])
          : null,
      relatedObservationIds: json['related_observation_ids'] != null
          ? List<String>.from(json['related_observation_ids'])
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'entity_type': entityType,
    'entity_id': entityId,
    'decision_type': decisionType,
    'decision': decision,
    if (rationale != null) 'rationale': rationale,
    if (outcome != null) 'outcome': outcome!.value,
    if (decisionDate != null) 'decision_date': decisionDate!.toIso8601String(),
    'related_observation_ids': relatedObservationIds,
  };
}

class Knowledge {
  final String entityType;
  final String entityId;
  final int observationsCount;
  final int patternsCount;
  final int decisionsCount;
  final int behavioursCount;
  final String? knowledgeSummary;
  final double confidenceScore;

  Knowledge({
    required this.entityType,
    required this.entityId,
    this.observationsCount = 0,
    this.patternsCount = 0,
    this.decisionsCount = 0,
    this.behavioursCount = 0,
    this.knowledgeSummary,
    this.confidenceScore = 0,
  });

  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id']?.toString() ?? '',
      observationsCount: json['observations_count'] ?? 0,
      patternsCount: json['patterns_count'] ?? 0,
      decisionsCount: json['decisions_count'] ?? 0,
      behavioursCount: json['behaviours_count'] ?? 0,
      knowledgeSummary: json['knowledge_summary'],
      confidenceScore: (json['confidence_score'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'entity_type': entityType,
    'entity_id': entityId,
    'observations_count': observationsCount,
    'patterns_count': patternsCount,
    'decisions_count': decisionsCount,
    'behaviours_count': behavioursCount,
    if (knowledgeSummary != null) 'knowledge_summary': knowledgeSummary,
    'confidence_score': confidenceScore,
  };
}
