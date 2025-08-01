import 'package:intl/intl.dart';

class Project {
  final String id;
  final String title;
  final String clientName;
  final bool isHourly;
  final double hourlyRate;
  final double fixedAmount;
  final double estimatedHours;
  final DateTime deadline;
  final String notes;
  final String status;
  final DateTime createdAt;
  final bool reminderEnabled;

  Project({
    required this.id,
    required this.title,
    required this.clientName,
    required this.isHourly,
    required this.hourlyRate,
    required this.fixedAmount,
    required this.estimatedHours,
    required this.deadline,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.reminderEnabled,
  });

  String get formattedDeadline => DateFormat('MMM dd, yyyy').format(deadline);
  String get formattedCreatedAt => DateFormat('MMM dd, yyyy').format(createdAt);
  double get totalAmount => isHourly ? hourlyRate * estimatedHours : fixedAmount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'clientName': clientName,
      'isHourly': isHourly ? 1 : 0,
      'hourlyRate': hourlyRate,
      'fixedAmount': fixedAmount,
      'estimatedHours': estimatedHours,
      'deadline': deadline.toIso8601String(),
      'notes': notes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'reminderEnabled': reminderEnabled ? 1 : 0,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      title: map['title'],
      clientName: map['clientName'],
      isHourly: map['isHourly'] == 1,
      hourlyRate: map['hourlyRate'],
      fixedAmount: map['fixedAmount'],
      estimatedHours: map['estimatedHours'],
      deadline: DateTime.parse(map['deadline']),
      notes: map['notes'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      reminderEnabled: map['reminderEnabled'] == 1,
    );
  }

  Project copyWith({
    String? id,
    String? title,
    String? clientName,
    bool? isHourly,
    double? hourlyRate,
    double? fixedAmount,
    double? estimatedHours,
    DateTime? deadline,
    String? notes,
    String? status,
    DateTime? createdAt,
    bool? reminderEnabled,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      clientName: clientName ?? this.clientName,
      isHourly: isHourly ?? this.isHourly,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      fixedAmount: fixedAmount ?? this.fixedAmount,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      deadline: deadline ?? this.deadline,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    );
  }
}