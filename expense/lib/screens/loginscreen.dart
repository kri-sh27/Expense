import 'package:expense/main.dart';
import 'package:expense/screens/resetpasswordscreen.dart';
import 'package:expense/screens/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});
  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _getData() async {
    final url = Uri.https(
        'expenseapp-25cd7-default-rtdb.firebaseio.com', 'signup.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      bool credentialsMatch = false;

      data.values.forEach((value) {
        if (value['email'] == emailController.text &&
            value['password'] == passwordController.text) {
          credentialsMatch = true;
        } else {
          print("Invalid or null value");
        }
      });
      if (credentialsMatch) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "Myhomepage"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[700],
            content: const Text(
              "Invalid Credentials!",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
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
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login Page",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter Your Email',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter Your Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _getData();
                    },
                    child: const Text("Login"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text("SignUp"),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text("Forgot password"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
