import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Repository Issues',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Repository Issues'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Issue {
  Issue ({
    this.title,
    this.avatarUrl,
  });

  final String title;
  final String avatarUrl;
}

class _MyHomePageState extends State<MyHomePage> {

  // Store the issue data from web site
  List<Issue> _issues = <Issue>[];
  
  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Get data from specified URL
  ///
  /// This asynchronous method wait the result of HTTP transaction.
  /// Then parse the JSON structure to list.
  Future<void> _load() async {
    final res = await http.get(
        'https://api.github.com/repositories/31792824/issues');
    final data = json.decode(res.body);

    setState(() {
      final issues = data as List;
      issues.forEach((dynamic element) {
        final issue = element as Map;
        _issues.add(Issue(
          title: issue['title'] as String,
          avatarUrl: issue['user']['avatar_url'] as String,
        )); // Add Issue title and avatar to list
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index >= _issues.length) {
            return null;
          }

          final issue = _issues[index];
          return ListTile(
            leading: ClipOval(
              child: Image.network(issue.avatarUrl),
            ),
            title: Text(issue.title)
          );
        },
      ),
    );
  }
}
