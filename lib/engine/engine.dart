import 'package:fin/engine/accounts.dart';
import 'package:fin/engine/balance.dart';
import 'package:fin/engine/utils.dart';
import 'package:fin/models/types.dart';

getTransactionAmount(List<String> message) {
  int index = message.indexOf('rs.');

  // If "rs." does not exist
  // Return ""
  if (index == -1) {
    return '';
  }
  String money = message[index + 1];

  money = money.replaceAll(',', '');

  // If data is false positive
  // Look ahead one index and check for valid money
  // Else return the found money
  if (num.tryParse(money) == null) {
    money = message.elementAt(index + 2);
    money = money.replaceAll(',', '');

    // If this is also false positive, return ""
    // Else return the found money
    if (num.tryParse(money) == null) {
      return '';
    }
    return padCurrencyValue(money);
  }
  return padCurrencyValue(money);
}

getTransactionType(List<String> processedMessage) {
  RegExp creditPattern = RegExp(
      r'(?:credited|credit|deposited|added|received|refund|repayment)',
      caseSensitive: false);
  RegExp debitPattern =
      RegExp(r'(?:debited|debit|deducted)', caseSensitive: false);
  RegExp miscPattern = RegExp(
      r'(?:payment|spent|paid|used\sat|charged|transaction\son|transaction\sfee|tran|booked|purchased)',
      caseSensitive: false);

  // const messageStr = typeof message !== 'string' ? message.join(' ') : message;
  String messageStr = processedMessage.join(" ");

  if (debitPattern.allMatches(messageStr).isNotEmpty) {
    return 'debit';
  }
  if (creditPattern.allMatches(messageStr).isNotEmpty) {
    return 'credit';
  }
  if (miscPattern.allMatches(messageStr).isNotEmpty) {
    return 'debit';
  }

  return null;
}

getTransactionInfo(String message) {
  List<String> processedMessage = processMessage(message);
  AccountInfo account = getAccount(processedMessage);
  String availableBalance = getBalance(processedMessage: processedMessage);
  String transactionAmount = getTransactionAmount(processedMessage);
  bool isValid =
    [availableBalance, transactionAmount, account.number].where(
      (x) => x != ''
    ).length >= 2;
  String transactionType = isValid ? getTransactionType(processedMessage) : null;
Balance balance = Balance(available: availableBalance, outstanding: null);

  if (account.type == AccountType.CARD) {
    balance.outstanding = getBalance(
      processedMessage:processedMessage,
      keyWordType:BalanceKeyWordsType.OUTSTANDING
    );
  }

  // console.log(processedMessage);
  // console.log(account, balance, transactionAmount, transactionType);
  // console.log('-----------------------------------------------------');
  // return {
  //   account,
  //   balance,
  //   transactionAmount,
  //   transactionType,
  // };
  return {
    "account name": account.name,
    "account number": account.number,
    "account type":account.type,
    "Avl Bal":balance.available,
    "transaction Amt":transactionAmount,
    "transaction Type":transactionType
  };
}


