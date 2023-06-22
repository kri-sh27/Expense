import 'package:expense/screens/totalexpensescreen.dart';
import 'package:expense/screens/totalincomeScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    child: const Card(
                      child: Column(
                        children: [
                          Text(
                            'Total Income',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\₹5000',
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
                    child: const Card(
                      child: Column(
                        children: [
                          Text(
                            'Total Expense',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\₹3000',
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
            const Card(
              child: Column(
                children: [
                  Text(
                    'Total Savings',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\₹2000',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
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
