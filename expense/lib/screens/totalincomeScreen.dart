import 'package:flutter/material.dart';

class TotalIncomeScreen extends StatefulWidget {
  const TotalIncomeScreen({super.key, required this.title});
  final String title;

  @override
  State<TotalIncomeScreen> createState() => _TotalIncomeScreenState();
}

class _TotalIncomeScreenState extends State<TotalIncomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(),
    );
  }
}
