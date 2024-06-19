import 'package:flutter/material.dart';

class Jurnaltidur extends StatelessWidget {
  const Jurnaltidur({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JurnaltidurPage(),
    );
  }
}

class JurnaltidurPage extends StatelessWidget {
  const JurnaltidurPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
    );
  }
}