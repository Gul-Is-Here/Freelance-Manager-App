class Calculation {
  final String id;
  final double hourlyRate;
  final double hours;
  final double commission;
  final double discount;
  final double total;
  final double netAmount;
  final DateTime createdAt;

  Calculation({
    required this.id,
    required this.hourlyRate,
    required this.hours,
    required this.commission,
    required this.discount,
    required this.total,
    required this.netAmount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hourlyRate': hourlyRate,
      'hours': hours,
      'commission': commission,
      'discount': discount,
      'total': total,
      'netAmount': netAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      id: map['id'],
      hourlyRate: map['hourlyRate'],
      hours: map['hours'],
      commission: map['commission'],
      discount: map['discount'],
      total: map['total'],
      netAmount: map['netAmount'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}