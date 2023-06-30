import 'dart:convert';

import 'package:expense/screens/alltransactionlistscreen.dart';
import 'package:expense/screens/totalexpensescreen.dart';
import 'package:expense/screens/totalincomeScreen.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalIncome = 0;
  int totalExpense = 0;
  int totalSavings = 0;
  List<double> di = [];
  List<double> de = [];
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    getData();

    // print('$totalIncome');
  }

// get api for fetching data from firebase
  Future<void> getData() async {
    final url = Uri.https(
        'expenseapp-25cd7-default-rtdb.firebaseio.com', 'expensapp.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print(data);
      num totalIncomeAmount = 0;
      num totalExpenseAmount = 0;
      List<double> dailyIncome = [];
      List<double> dailyExpense = [];

/*totalIncomeAmount stores Addition of all income and dailyIncome store income in list
 which is further used for ploting graphh*/
      /*totalExpenseAmount stores Addition of all expense and dailyExense store expense in list
 which is further used for ploting graphh*/
      data.values.forEach((value) {
        if (value['type'] == 'income' &&
            value['amount'] != null &&
            value['amount'] is num) {
          totalIncomeAmount += (value['amount'] as num).toInt();
          dailyIncome.add((value['amount'] as num).toDouble());
        } else if (value['type'] == 'expense' &&
            value['amount'] != null &&
            value['amount'] is num) {
          totalExpenseAmount += (value['amount'] as num).toInt();
          dailyExpense.add((value['amount'] as num).toDouble());
        } else {
          print('Invalid or null amount value');
        }
      });

//this newDataList for displying all transation
      List<Map<String, dynamic>> newDataList = [];
      data.forEach((key, value) {
        newDataList.add({
          'amount': value['amount'],
          'type': value['type'],
          'note': value['note']
        });
      });

      setState(() {
        totalIncome = totalIncomeAmount.toInt();
        totalExpense = totalExpenseAmount.toInt();
        // print('Total Income: $totalIncome');
        // print('total Expense: $totalExpense');
        totalSavings = totalIncome - totalExpense;

        dataList = newDataList;
        // print(dataList);
        di = dailyIncome;
        de = dailyExpense;
      });
    } else {
      print('Error: ${response.statusCode}');
      print('Error response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TotalIncomeScreen(
                                  title: "TotalINcomeScreen",
                                )),
                      );
                    },
                    child: Card(
                      child: Column(
                        children: [
                          const Text(
                            'Total Income',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹$totalIncome',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TotalExpenseScreen(
                                  title: "TotalExpenseScreen",
                                )),
                      );
                    },
                    child: Card(
                      child: Column(
                        children: [
                          const Text(
                            'Total Expense',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\₹$totalExpense',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  await getData();
                },
                child: Card(
                  child: Column(
                    children: [
                      const Text(
                        'Total Savings',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\₹$totalSavings',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await getData();
                    },
                    child: const Text("Check Income"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await getData();
                    },
                    child: const Text("Check Expense"),
                  ),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Sparkline(
                      gridLinelabelPrefix: '\₹',
                      enableGridLines: true,
                      pointsMode: PointsMode.all,
                      data: di,
                      lineColor: Colors.green,
                      fillMode: FillMode.below,
                      fillGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green,
                          Colors.green.withOpacity(0.2),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Sparkline(
                      gridLinelabelPrefix: '\ ₹',
                      pointsMode: PointsMode.all,
                      enableGridLines: true,
                      data: de,
                      lineColor: Colors.red,
                      fillMode: FillMode.below,
                      fillGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.red,
                          Colors.red.withOpacity(0.2),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AllTransactionList(dataList: dataList),
                          ),
                        );
                      },
                      child: const Card(
                        child: Column(
                          children: [
                            Text(
                              'All transactions ',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
