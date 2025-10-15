/// Transacción individual
class Transaction {
  final String id;
  final double amount;
  final String recipientName;
  final String destinationBank;

  Transaction({
    required this.id,
    required this.amount,
    required this.recipientName,
    required this.destinationBank,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      recipientName: json['recipientName'] ?? '',
      destinationBank: json['destinationBank'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'recipientName': recipientName,
      'destinationBank': destinationBank,
    };
  }
}

/// Respuesta del servicio de balance
class BalanceResponse {
  final String code;
  final String accountNumber;
  final String currency;
  final double amount;
  final List<Transaction> last5Transactions;

  BalanceResponse({
    required this.code,
    required this.accountNumber,
    required this.currency,
    required this.amount,
    required this.last5Transactions,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) {
    return BalanceResponse(
      code: json['code'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      currency: json['currency'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      last5Transactions: (json['last5Transactions'] as List<dynamic>? ?? [])
          .map((t) => Transaction.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'accountNumber': accountNumber,
      'currency': currency,
      'amount': amount,
      'last5Transactions': last5Transactions.map((t) => t.toJson()).toList(),
    };
  }
}
