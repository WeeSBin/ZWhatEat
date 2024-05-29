import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '뭐먹지'),
    );
  }
}

class Category {
  final Color color;
  final String text;

  Category({required this.color, required this.text});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Category> categories = [
    Category(color: Colors.red, text: '한식'),
    Category(color: Colors.green, text: '중식'),
    Category(color: Colors.blue, text: '양식'),
    Category(color: Colors.yellow, text: '일식'),
    Category(color: Colors.purple, text: '분식'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
          children: categories
              .map((category) => buildDismissibleContainer(category))
              .toList()),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        height: 50,
        child: Container(
          child: Center(
            child: Text('Bottom Area'),
          ),
        ),
      ),
    );
  }

  Widget buildDismissibleContainer(Category category) {
    return Expanded(
      child: Dismissible(
        key: Key(category.text),
        onDismissed: (direction) {
          setState(() {
            categories.removeWhere((item) => item.text == category.text);
          });
        },
        background: Container(color: Colors.red),
        secondaryBackground: Container(color: Colors.green),
        child: Container(
          color: category.color,
          child: Center(
            child: Text(category.text,
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
