import 'dart:async';

import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  final String message;

  const LoadingPage({Key? key, required this.message}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              widget.message,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
