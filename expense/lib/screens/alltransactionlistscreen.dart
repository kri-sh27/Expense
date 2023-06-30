import 'package:flutter/material.dart';

class AllTransactionList extends StatelessWidget {
  const AllTransactionList({super.key, required this.dataList});
  final List<Map<String, dynamic>> dataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Transactions"),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          final amount = item['amount'];
          final type = item['type'];
          final note = item['note'];

          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$amount',
                  style: TextStyle(
                    color: type == 'income' ? Colors.green : Colors.red,
                  ),
                ),
                if (note != null) Text(note),
              ],
            ),
            trailing: type == 'income'
                ? Icon(
                    Icons.add,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.remove,
                    color: Colors.red,
                  ),
          );
        },
      ),
    );
  }
}
