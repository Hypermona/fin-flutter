class Transaction {
  final DateTime? date;
  final String? amount;

  Transaction({required this.date, required this.amount});

  List getChartData() {
    return [date?.day.toDouble(), double.tryParse(amount?? "0") ?? 0];
  }
}
