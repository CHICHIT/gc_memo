import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'memo_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _dotCount = 1;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _navigateToMemoScreen();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _dotCount = (_dotCount % 3) + 1;
      });
    });
  }


  Future<void> _navigateToMemoScreen() async {
    await Future.delayed(Duration(seconds: 3));
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MemoScreen()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital,
              size: 80,
              color: Color(0xFF00ADE6),
            ),
            SizedBox(height: 20),
            Text(
              'GC병원',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00ADE6),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                SizedBox(height: 20),
                Text(
                  '로딩중${'.' * _dotCount}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
