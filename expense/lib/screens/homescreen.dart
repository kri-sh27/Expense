import 'dart:convert';

import 'package:expense/screens/totalexpensescreen.dart';
import 'package:expense/screens/totalincomeScreen.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _getData();
    print('$totalIncome');
  }

  Future<void> _getData() async {
    final url = Uri.https(
        'expenseapp-25cd7-default-rtdb.firebaseio.com', 'expensapp.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      num totalIncomeAmount = 0;
      num totalExpenseAmount = 0;

      data.values.forEach((value) {
        if (value['type'] == 'income' &&
            value['amount'] != null &&
            value['amount'] is num) {
          totalIncomeAmount += (value['amount'] as num).toInt();
        } else if (value['type'] == 'expense' &&
            value['amount'] != null &&
            value['amount'] is num) {
          totalExpenseAmount += (value['amount'] as num).toInt();
        } else {
          print('Invalid or null amount value');
        }
      });

      setState(() {
        totalIncome = totalIncomeAmount.toInt();
        totalExpense = totalExpenseAmount.toInt();
        print('Total Income: $totalIncome');
        print('total Expense: $totalExpense');
        totalSavings = totalIncome - totalExpense;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
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
                          SizedBox(height: 8),
                          Text(
                            '₹$totalIncome',
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
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
                          Text(
                            'Total Expense',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\₹$totalExpense',
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                await _getData();
              },
              child: Card(
                child: Column(
                  children: [
                    Text(
                      'Total Savings',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\₹$totalSavings',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _getData();
                  },
                  child: Text("Check Income"),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _getData();
                  },
                  child: Text("Check Expense"),
                ),
              ],
            ),
            const Divider(),

            const Text(
              'Graph of Total Income and Total Expense will get added here',
              style: TextStyle(fontSize: 20),
            ),
            //  graph widget will be added here
          ],
        ),
      ),
    );
  }
}
