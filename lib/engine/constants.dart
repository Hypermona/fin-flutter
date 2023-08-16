
import 'package:fin/models/types.dart';

 const List availableBalanceKeywords = [
  'avbl bal',
  'available balance',
  'available limit',
  'available credit limit',
  'limit available',
  'a/c bal',
  'ac bal',
  'available bal',
  'avl bal',
  'updated balance',
  'total balance',
  'new balance',
  'bal',
  'avl lmt',
  'available',
];

const List outstandingBalanceKeywords = ['outstanding'];

const List wallets = ['paytm', 'simpl', 'lazypay', 'amazon_pay'];

final List<CominedWords> combinedWordsList = [
  CominedWords(regExp: RegExp(r"credit\scard"), word: "c_card", type: AccountType.CARD),
  CominedWords(regExp: RegExp(r"amazon\spay"), word: "amazon_pay", type: AccountType.WALLET),
  CominedWords(regExp: RegExp(r"uni\scard"), word: "uni_card", type: AccountType.CARD),
  CominedWords(regExp: RegExp(r"niyo\scard"), word: "niyo", type: AccountType.ACCOUNT),
  CominedWords(regExp: RegExp(r"slice\scard"), word: "slice_card", type: AccountType.CARD),
];

