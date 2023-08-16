import 'package:fin/engine/constants.dart';
import 'package:fin/engine/utils.dart';
import 'package:fin/models/types.dart';

AccountInfo getAccount(List<String> processedMessage) {
  int accountIndex = -1;
  int n = processedMessage.length;
  AccountInfo account = AccountInfo(type: null, number: null, name: null);
  for (int i = 0; i < n; i++) {
    if (processedMessage[i] == 'ac') {
      if (i + 1 < n) {
        var accountNo = trimLeadingAndTrailingChars(processedMessage[i + 1]);
        if (num.tryParse(accountNo) == null) {
          continue;
        } else {
          accountIndex = i;
          account.type = AccountType.ACCOUNT;
          account.number = accountNo;
          break;
        }
      } else {
        continue;
      }
    } else if (processedMessage[i].contains(r'ac')) {
      String extractedAccountNo = extractBondedAccountNo(processedMessage[i]);
      if (extractedAccountNo == "") {
        continue;
      } else {
        accountIndex = i;
        account.type = AccountType.ACCOUNT;
        account.number = extractedAccountNo;
        break;
      }
    }
  }
  if (accountIndex == -1) {
    account = getCard(processedMessage);
  }
  // test pending
  if (account.type == null) {
    String wallet = processedMessage.firstWhere(
      (word) => wallets.contains(word),
    );
    if (wallet != "") {
      account.type = AccountType.WALLET;
      account.name = account.name;
    }
  }

  if (account.type == null) {
    CominedWords? specialAccount = combinedWordsList
        .where((word) => word.type == AccountType.ACCOUNT)
        .firstWhere((word) => processedMessage.contains(word.word),
            orElse: () => CominedWords(regExp: null, word: null, type: null));
    if (specialAccount.type != null) {
      account.type = specialAccount.type;
      account.name = specialAccount.word;
    }
  }
  if (account.number != null && account.number!.length > 4) {
    account.number = account.number!.substring(account.number!.length - 4);
  }
  return account;
}

AccountInfo getCard(List<String> processedMessage) {
  String combinedCardName = "";
  int cardIndex = processedMessage.indexWhere((word) =>
      word == "card" ||
      combinedWordsList.where((w) => w.type == AccountType.CARD).any((w) {
        if (w.word == word) {
          combinedCardName = w.word!;
          return true;
        }
        return false;
      }));
  AccountInfo card = AccountInfo(type: null, number: null, name: null);
  if (cardIndex != -1) {
    card.number = processedMessage[cardIndex + 1];
    card.type = AccountType.CARD;

    if (num.tryParse(card.number!)!=null) {
      return AccountInfo(type: combinedCardName.isNotEmpty?card.type:null, number: null, name: combinedCardName);
    }
    return card;
  }
  return AccountInfo(type: null, number: null, name: null);
}
