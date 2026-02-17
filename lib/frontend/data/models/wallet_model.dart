class WalletModel {
  final double balance;
  final List<WalletTransaction> transactions;

  WalletModel({
    required this.balance,
    required this.transactions,
  });
}

class WalletTransaction {
  final int id;
  final double amount;
  final String type;
  final String? description;
  final DateTime date;
  final int? orderId;

  WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    this.description,
    required this.date,
    this.orderId,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      description: json['description'],
      date: DateTime.parse(json['created_at']),
      orderId: json['order_id'],
    );
  }
}
