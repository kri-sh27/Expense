import 'package:flutter/material.dart';

class TotalExpenseScreen extends StatefulWidget {
  const TotalExpenseScreen({super.key, required this.title});
  final String title;

  @override
  State<TotalExpenseScreen> createState() => _TotalExpenseScreenState();
}

class _TotalExpenseScreenState extends State<TotalExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(),
    );
    ;
  }
}
