class PaymentEntryModel {
  final String entryId; // unique id for this transaction
  final String userId; // which user it belongs to
  final DateTime date;
  final String status; // "Paid" or "Consumed"
  final double amount;
  final String notes;

  PaymentEntryModel({
    required this.entryId,
    required this.userId,
    required this.date,
    required this.status,
    required this.amount,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'entryId': entryId,
      'userId': userId,
      'date': date.toIso8601String(),
      'status': status,
      'amount': amount,
      'notes': notes,
    };
  }

  factory PaymentEntryModel.fromMap(Map<String, dynamic> map) {
    return PaymentEntryModel(
      entryId: map['entryId'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
    );
  }
}
