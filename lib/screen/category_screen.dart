import 'package:flutter/material.dart';

import '../model/category_model.dart';

class CategoryScreen extends StatefulWidget {
  final void Function(CategoryModel lastCategory) onLastItem;

  const CategoryScreen({super.key, required this.onLastItem});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  // todo 색상 대신 이미지 추가
  List<CategoryModel> categories = [
    CategoryModel(color: Colors.red, name: '한식'),
    CategoryModel(color: Colors.green, name: '중식'),
    CategoryModel(color: Colors.blue, name: '양식'),
    CategoryModel(color: Colors.yellow, name: '일식'),
    CategoryModel(color: Colors.purple, name: '분식'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: categories
            .map((category) => buildDismissibleContainer(category))
            .toList()
    );
  }

  Widget buildDismissibleContainer(CategoryModel category) {
    return Expanded(
      child: Dismissible(
        key: Key(category.name),
        onDismissed: (direction) {
          setState(() {
            categories.removeWhere((item) => item.name == category.name);
            if (categories.length == 1) {
              widget.onLastItem(categories.first);
            }
          });
        },
        background: Container(color: Colors.red),
        // todo 색상 대신 이미지로? 어쨋든 초록색은 아님
        secondaryBackground: Container(color: Colors.green),
        child: Container(
          color: category.color,
          child: Center(
            child: Text(category.name,
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
