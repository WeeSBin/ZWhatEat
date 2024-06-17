import 'package:flutter/material.dart';

import 'model/category_model.dart';

class CategoryScreen extends StatefulWidget {
  final void Function() onLastItem;

  const CategoryScreen({super.key, required this.onLastItem});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  List<CategoryModel> categories = [
    CategoryModel(color: Colors.red, text: '한식'),
    CategoryModel(color: Colors.green, text: '중식'),
    CategoryModel(color: Colors.blue, text: '양식'),
    CategoryModel(color: Colors.yellow, text: '일식'),
    CategoryModel(color: Colors.purple, text: '분식'),
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
        key: Key(category.text),
        onDismissed: (direction) {
          setState(() {
            categories.removeWhere((item) => item.text == category.text);
            if (categories.length == 1) {
              widget.onLastItem();
            }
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
