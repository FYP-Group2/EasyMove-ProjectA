import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: AccountPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title});
  final String title;

  @override
  State<AccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 255, 168, 0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("Account content here"),
          ],
        ),
      ),
    );
  }
}
