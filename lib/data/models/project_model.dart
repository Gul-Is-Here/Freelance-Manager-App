import 'dart:typed_data';
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
  final Uint8List? logoBytes;
  final String? companyName;
  final String? companyAddress;
  final String? companyEmail;
  final String? companyPhone;

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
    this.logoBytes,
    this.companyName,
    this.companyAddress,
    this.companyEmail,
    this.companyPhone,
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
      'logoBytes': logoBytes,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyEmail': companyEmail,
      'companyPhone': companyPhone,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      title: map['title'] as String,
      clientName: map['clientName'] as String,
      isHourly: (map['isHourly'] as int) == 1,
      hourlyRate: (map['hourlyRate'] as num).toDouble(),
      fixedAmount: (map['fixedAmount'] as num).toDouble(),
      estimatedHours: (map['estimatedHours'] as num).toDouble(),
      deadline: DateTime.parse(map['deadline'] as String),
      notes: map['notes'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      reminderEnabled: (map['reminderEnabled'] as int) == 1,
      logoBytes: map['logoBytes'] as Uint8List?,
      companyName: map['companyName'] as String?,
      companyAddress: map['companyAddress'] as String?,
      companyEmail: map['companyEmail'] as String?,
      companyPhone: map['companyPhone'] as String?,
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
    Uint8List? logoBytes,
    String? companyName,
    String? companyAddress,
    String? companyEmail,
    String? companyPhone,
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
      logoBytes: logoBytes ?? this.logoBytes,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      companyEmail: companyEmail ?? this.companyEmail,
      companyPhone: companyPhone ?? this.companyPhone,
    );
  }
}