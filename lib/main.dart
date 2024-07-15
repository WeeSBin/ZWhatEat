import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:whateat/screen/category_screen.dart';
import 'package:whateat/screen/store_screen.dart';

import 'model/category_model.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
  late CategoryModel lastCategory;
  DateTime? lastPressed;

  void toggleScreen(CategoryModel lastCategory) {
    setState(() {
      showCategory = !showCategory;
      this.lastCategory = lastCategory;
    });
  }

  // todo 전체 색상 팔레트 정하기
  // todo 구글 광고 올리기

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (showCategory) {
          final now = DateTime.now();
          final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed = lastPressed == null ||
              now.difference(lastPressed!) > const Duration(seconds: 2);

          if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
            lastPressed = DateTime.now();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('한 번 더 뒤로 가면 앱이 닫힙니다.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          }
        } else {
          setState(() {
            showCategory = true;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: showCategory
            ? CategoryScreen(onLastItem: toggleScreen)
            : StoreScreen(lastCategory: lastCategory),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey[200],
          height: 50,
          child: Container(
            child: const Center(
              child: Text('Bottom Area'),
            ),
          ),
        ),
      ),
    );
  }
}
