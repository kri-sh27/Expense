import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TotalExpenseScreen extends StatefulWidget {
  const TotalExpenseScreen({super.key, required this.title});
  final String title;

  @override
  State<TotalExpenseScreen> createState() => _TotalExpenseScreenState();
}

class _TotalExpenseScreenState extends State<TotalExpenseScreen> {
  DateTime selectedDate = DateTime.now();
  int? amount;
  String note = "Expence";
  String type = "Income";
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: const Color(0xffe2e7ef),
      //
      body: ListView(
        padding: const EdgeInsets.all(
          12.0,
        ),
        children: [
          const Text(
            "\nAdd Transaction",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          //
          const SizedBox(
            height: 20.0,
          ),
          //
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                padding: const EdgeInsets.all(
                  12.0,
                ),
                child: const Icon(
                  Icons.attach_money,
                  size: 24.0,
                  // color: Colors.grey[700],
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "0",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val) {
                    try {
                      amount = int.parse(val);
                    } catch (e) {
                      // show Error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(
                            seconds: 2,
                          ),
                          content: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                "Enter only Numbers as Amount",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  // textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          //
          const SizedBox(
            height: 20.0,
          ),
          //
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                padding: const EdgeInsets.all(
                  12.0,
                ),
                child: const Icon(
                  Icons.description,
                  size: 24.0,
                  // color: Colors.grey[700],
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Note on Transaction",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  onChanged: (val) {
                    note = val;
                  },
                ),
              ),
            ],
          ),
          //
          const SizedBox(
            height: 20.0,
          ),
          //

          //
          const SizedBox(
            height: 20.0,
          ),
          //
          SizedBox(
            height: 50.0,
            child: TextButton(
              onPressed: () {
                _selectDate(context);
                //
                // to make sure that no keyboard is shown after selecting Date
                FocusScope.of(context).unfocus();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.zero,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                      12.0,
                    ),
                    child: const Icon(
                      Icons.date_range,
                      size: 24.0,
                      // color: Colors.grey[700],
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    "${selectedDate.day} ${months[selectedDate.month - 1]}",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //
          const SizedBox(
            height: 20.0,
          ),
          //
          SizedBox(
            height: 50.0,
            child: ElevatedButton(
              onPressed: () async {
                if (amount != null) {
                  final url = Uri.https(
                      'expenseapp-25cd7-default-rtdb.firebaseio.com',
                      'expensapp.json');

                  final response = await http.get(url);
                  final responseData = json.decode(response.body);

                  bool dateExists = false;

                  responseData.forEach((key, value) {
                    if (value['date'] == selectedDate.toString() &&
                        value['type'] == "expense") {
                      dateExists = true;
                      final int existingAmount = value['amount'] as int;
                      final updatedAmount = (existingAmount + amount!);
                      final updatedNote = value['note'] + ", " + note;

                      http.patch(
                        Uri.https(
                          'expenseapp-25cd7-default-rtdb.firebaseio.com',
                          'expensapp/$key.json',
                        ),
                        body: json.encode({
                          'amount': updatedAmount,
                          'note': updatedNote,
                        }),
                      );
                    }
                  });

                  if (!dateExists) {
                    final response = await http.post(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: json.encode(
                        {
                          'amount': amount,
                          'note': note,
                          'date': selectedDate.toString(),
                          'type': "expense",
                        },
                      ),
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color.fromARGB(255, 31, 151, 51),
                          content: Text(
                            "Expense Added Successfully",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      Navigator.pop(
                          context); // Navigate back to the previous screen
                    } else {
                      print('Failed to add expense');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text(
                          "Expense Updated Successfully",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                    Navigator.pop(
                        context); // Navigate back to the previous screen
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red[700],
                      content: const Text(
                        "Please enter a valid amount",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
