class Bet {
  Bet({
    required this.uid,
    required this.amount,
    required this.timestamp,
    this.isSold = false,
  });

  final String uid;
  final double amount;
  final bool isSold;
  final int timestamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'amount': amount,
      'is_sold': isSold,
      'timestamp': timestamp,
    };
  }

  // ignore: sort_constructors_first
  factory Bet.fromMap(Map<String, dynamic> map) {
    return Bet(
      uid: map['uid'] ?? '',
      amount: double.parse(map['amount'].toString()),
      isSold: map['is_sold'] ?? false,
      timestamp: int.parse(map['timestamp'].toString()),
    );
  }
}
