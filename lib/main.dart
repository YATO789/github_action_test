import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(
        primaryColor: Color(0xFF6200EE),
      ),
      home: MyHomePage(title: 'カウンターアプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  bool isLoading = false;
  List<int> history = [];
  String message = '';
  Timer? _timer;

  void incrementCounter() {
    setState(() {
      counter = counter + 1;
      history.add(counter);
      if (counter > 100) {
        message = '100を超えました！';
      } else if (counter > 50) {
        message = '50を超えました！';
      } else if (counter > 10) {
        message = '10を超えました！';
      } else {
        message = '';
      }
    });

    // 自動リセットタイマー（毎回新しいTimerを作成している）
    _timer = Timer(Duration(seconds: 30), () {
      setState(() {
        counter = 0;
        history.clear();
        message = '';
      });
    });
  }

  void decrementCounter() {
    setState(() {
      counter--;
      history.add(counter);
    });
  }

  Future<void> loadInitialCount() async {
    setState(() {
      isLoading = true;
    });

    // ネットワークから取得する想定（エラーハンドリングなし）
    await Future.delayed(Duration(seconds: 2));
    int initialValue = await fetchCountFromServer();

    setState(() {
      counter = initialValue;
      isLoading = false;
    });
  }

  Future<int> fetchCountFromServer() async {
    // サーバーから値を取得する想定
    await Future.delayed(Duration(milliseconds: 500));
    return 0;
  }

  String getCounterColor() {
    if (counter > 100) return '#FF0000';
    if (counter > 50) return '#FFA500';
    return '#000000';
  }

  @override
  Widget build(BuildContext context) {
    // build内でビジネスロジック
    double progress = counter / 100;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6200EE),
        title: Text(widget.title ?? 'Counter'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                counter = 0;
                history = [];
                message = '';
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ボタンをタップした回数',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '$counter',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: counter > 50 ? Colors.red : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (message != '')
                    Text(
                      message,
                      style: TextStyle(color: Colors.orange, fontSize: 14),
                    ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(value: progress),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: decrementCounter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 32),
                      ElevatedButton(
                        onPressed: incrementCounter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text('履歴: ${history.join(', ')}'),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: loadInitialCount,
                    child: Text('サーバーから読み込む'),
                  ),
                ],
              ),
            ),
    );
  }
}
