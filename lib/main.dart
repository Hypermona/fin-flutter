import 'package:fin/lineChart.dart';
import 'package:fin/models/transaction.dart';
import 'package:transaction_sms_parser/transaction_sms_parser.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

void main() {
  // print(getTransactionInfo(
  //     "INR 2000 debited from A/c no. XX3423 on date IST at SMAPLE Avl Bal- INR 2343.23."));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Telephony telephony = Telephony.instance;
  List<Map<String, dynamic>> cleanedMessages = [];
  getSmsFromSmsMessages(List<SmsMessage> smsMessage) {
    List<String> sms = [];
    smsMessage.forEach((message) {
      if (message.body != null) {
        print(message.address);
        sms.add(message.body!);
      }
    });
    return cleanMessages(sms);
  }

  Future<List<String>> getSMS() async {
    List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
        filter: SmsFilter.where(SmsColumn.ADDRESS)
            .like("%-UNIONB")
            .or(SmsColumn.ADDRESS)
            .like("%-CANBNK")
        // .and(SmsColumn.BODY)
        // .like("%Credit%")
        // .or(SmsColumn.BODY)
        // .like("%Debit%")
        // .and(SmsColumn.BODY)
        // .not
        // .like("%OTP%"),
        );
    return getSmsFromSmsMessages(messages);
  }

  callme() async {
    List<String> sms = await getSMS();
    List<Map<String, dynamic>> transactionInfoList = [];
    sms.forEach(
      (msg) {
        Map<String, dynamic> transactionInfo = getTransactionInfo(msg);
        if (transactionInfo['accountType'] != null &&
            transactionInfo["accountNumber"] != null &&
            transactionInfo["transactionAmt"] != null &&
            transactionInfo["AvlBal"] != null &&
            transactionInfo['transactionType'] != null) {
          transactionInfoList.add(transactionInfo);
        }
      },
    );
    setState(() {
      cleanedMessages = transactionInfoList;
    });
  }

  Future<List<List<dynamic>>> convertToChartData(List data) async {
    print("data lenght ${data.length - 30}");
    var last30 = data.sublist(data.length - 30);
    List<List> chartData = [];
    last30.forEach((e) {
      DateTime? date = e['transactionDate'];
      String? amount = e['avlBalance'];
      chartData.add(Transaction(date: date, amount: amount).getChartData());
    });
    return chartData;
  }

  @override
  void initState() {
    super.initState();
    callme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Total SMS ${cleanedMessages.length}"),
        ),
        // body: Container(
        //   child: Center(
        //     child: ListView.builder(
        //       itemCount: cleanedMessages.length,
        //       itemBuilder: (context, index) => Container(
        //         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //         child: Column(children: [
        //           Text(cleanedMessages[index]['accountNumber'] ?? "null"),
        //           Text(cleanedMessages[index]['transactionAmt'] ?? "null"),
        //           Text(cleanedMessages[index]['transactionType'] ?? "null"),
        //           Text(cleanedMessages[index]['transactionDate'].toString() ?? ""),
        //         ]),
        //       ),
        //     ),
        //   ),
        // ),
        body: LineChart(
          data: cleanedMessages,
        ));
  }
}
