import 'package:flutter/material.dart';
import 'package:whateat/category/category_screen.dart';
import 'package:whateat/store/store_screen.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool showCategory = true;

  void toggleScreen() {
    setState(() {
      showCategory = !showCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: showCategory
          ? CategoryScreen(onLastItem: toggleScreen)
          : const StoreScreen(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        height: 50,
        child: Container(
          child: const Center(
            child: Text('Bottom Area'),
          ),
        ),
      ),
    );
  }
}
