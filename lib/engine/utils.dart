import 'package:fin/engine/constants.dart';

List<String> processMessage(String message) {
  String messageStr = message.toLowerCase();
  messageStr = messageStr.replaceAll(RegExp(r'-'), "");
  messageStr = messageStr.replaceAll(RegExp(r':'), " ");
  messageStr = messageStr.replaceAll(RegExp(r'\/'), "");
  messageStr = messageStr.replaceAll(RegExp(r'='), " ");
  messageStr = messageStr.replaceAll(RegExp(r'[{}]'), " ");
  messageStr = messageStr.replaceAll(RegExp(r'\n'), " ");
  messageStr = messageStr.replaceAll(RegExp(r'\r'), " ");
  messageStr = messageStr.replaceAll(RegExp(r'ending '), "");
  messageStr = messageStr.replaceAll(RegExp(r'x|[*]'), "");
  messageStr = messageStr.replaceAll(RegExp(r'is '), "");
  messageStr = messageStr.replaceAll(RegExp(r'with '), "");
  messageStr = messageStr.replaceAll(RegExp(r'no. '), "");
  messageStr =
      messageStr.replaceAll(RegExp(r'\bac\b|\bacct\b|\baccount\b'), "ac");
  messageStr = messageStr.replaceAll(RegExp(r'rs(?=\w)'), "rs. ");
  messageStr = messageStr.replaceAll(RegExp(r'rs '), "rs. ");
  messageStr = messageStr.replaceAll(RegExp(r'inr(?=\w)'), "rs. ");
  messageStr = messageStr.replaceAll(RegExp(r'inr '), "rs. ");
  messageStr = messageStr.replaceAll(RegExp(r'rs. '), "rs.");
  messageStr = messageStr.replaceAll(RegExp(r'rs.(?=\w)'), "rs. ");
  messageStr = messageStr.replaceAll(RegExp(r'-'), "");
  messageStr = messageStr.replaceAll(RegExp(r'-'), "");
  messageStr = messageStr.replaceAll(RegExp(r'-'), "");
  messageStr = messageStr.replaceAll(RegExp(r'-'), "");
  messageStr = messageStr.replaceAll(RegExp(r'-'), "");
  messageStr = messageStr.replaceAll(RegExp(r'-'), "");
  combinedWordsList.forEach((word) {
    messageStr = messageStr.replaceAll(word.regExp!, word.word!);
  });
  return messageStr.split(" ").where((e) => e != "").toList();
}

String trimLeadingAndTrailingChars(String str) {
  String first = str[0];
  String last = str[str.length - 1];
  String finalStr =
      (num.tryParse(last) != null) ? str : str.substring(0, str.length - 1);
  finalStr =
      (num.tryParse(first) != null) ? finalStr : finalStr.substring(0, 1);
  return finalStr;
}

String extractBondedAccountNo(String accountNo) {
  String strippedAccountNo = accountNo.replaceAll(r'ac', "");
  return num.tryParse(strippedAccountNo) != null ? strippedAccountNo : "";
}

// can expect some error then check for . exxtance
padCurrencyValue(String balance) {
  if (balance.contains('.')) {
    List<String?> temp = balance.split('.');
    return '${temp[0]}.${(temp[1] ?? '').padRight(2, '0')}';
  } else {
    return balance;
  }
}
