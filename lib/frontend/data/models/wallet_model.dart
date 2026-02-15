class WalletModel {
  int userId;
  double balance;
  List<WalletTransaction> transactions;

  WalletModel({
    required this.userId,
    required this.balance,
    required this.transactions,
  });
}

class WalletTransaction {
  final int id;
  final double amount;
  final String type; // شحن - دفع
  final DateTime date;

  WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
  });

}
final WalletModel mockWallet = WalletModel(
  userId: 1,
  balance: 12500,
  transactions: [
    WalletTransaction(
      id: 1,
      amount: 5000,
      type: 'شحن',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    WalletTransaction(
      id: 2,
      amount: -2000,
      type: 'دفع',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    WalletTransaction(
      id: 3,
      amount: 3000,
      type: 'شحن',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ],
);