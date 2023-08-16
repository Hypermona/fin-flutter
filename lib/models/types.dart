enum AccountType { CARD, WALLET, ACCOUNT }

enum BalanceKeyWordsType { AVAILABLE, OUTSTANDING }

enum TransactionType {
  debit,
  credit,
  others;
}

class TransactionInfo {
  final AccountInfo account;
  int? transactionAmount;
  final TransactionType transactionType;
  final Balance balance;

  TransactionInfo(
      {required this.account,
      this.transactionAmount,
      required this.transactionType,
      required this.balance});
}

class AccountInfo {
  AccountType? type;
  String? number;
  String? name;

  AccountInfo({required this.type, required this.number, required this.name});
}

class CominedWords {
  final RegExp? regExp;
  final String? word;
  final AccountType? type;

  CominedWords({required this.regExp, required this.word, required this.type});
}

var cominedWords =
    CominedWords(regExp: RegExp(r"hell"), word: "word", type: AccountType.CARD);

class Balance {
  final String? available;
   String? outstanding;

  Balance({required this.available, required this.outstanding});
}
