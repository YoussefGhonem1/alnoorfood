import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/models/drop_down_class.dart';
import '../../../../injection_container.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/use_cases/category_usecases.dart';


class CategoryProvider extends ChangeNotifier implements DropDownClass<CategoryEntity>{
  List<CategoryEntity> categories = [];
  late CategoryEntity defaultCategoryEntity;
  late CategoryEntity categoryEntity;
  void clear(){
    defaultCategoryEntity = CategoryEntity(id: 0, name: LanguageProvider.translate('global', 'all'),
        productEntity: const [], key: GlobalKey());
    categories.clear();
    categoryEntity = defaultCategoryEntity;
    notifyListeners();
  }
  void setCategory(CategoryEntity? categoryEntity){
    this.categoryEntity = categoryEntity??defaultCategoryEntity;
    notifyListeners();
  }
  Future refresh()async{
    clear();
    await getCategories();
  }
  Future getCategories()async{
    Either<DioException,List<CategoryEntity>> value = await CategoryUseCases(sl()).getCategory();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      categories.clear();
      categories.add(defaultCategoryEntity);
      categories.addAll(r);
      notifyListeners();
    });
  }

  @override
  String displayedName() {
    return categoryEntity.name;
  }

  @override
  String displayedOptionName(CategoryEntity categoryEntity) {
    return categoryEntity.name;
  }

  @override
  List<CategoryEntity> list() {
    return categories;
  }

  @override
  Future onTap(data) async{
    setCategory(data);
  }

  @override
  CategoryEntity? selected() {
    return categoryEntity;
  }
}