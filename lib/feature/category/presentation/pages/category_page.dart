import 'package:flutter/material.dart';

import '../../domain/entities/category_entity.dart';
import '../widgets/category_widget.dart';
import '../widgets/shimmer/shimmer_category_widget.dart';

class CategoryPage extends StatelessWidget {
  final List<CategoryEntity>? categories;
  const CategoryPage({required this.categories,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(categories==null){
      return Column(
        children: List.generate(3, (index) => ShimmerCategoryWidget(index: index)),
      );
    }
    return Column(
      children: List.generate(categories!.length, (index) =>
          CategoryWidget(index: index,category: categories![index],)),
    );
  }
}
