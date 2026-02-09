// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import '../../../../core/dialog/snack_bar.dart';
// import '../../../../core/models/drop_down_class.dart';
// import '../../../../injection_container.dart';
// import '../../../language/presentation/provider/language_provider.dart';
// import '../../domain/entities/options_entity.dart';
// import '../../domain/use_cases/option_usecases.dart';
//
//
// class OptionsProvider extends ChangeNotifier implements DropDownClass<OptionsEntity>{
//   List<OptionsEntity> options = [];
//   static OptionsEntity defaultOptionsEntity = OptionsEntity(id: 0, price: 0, amount: -1);
//   OptionsEntity optionsEntity = defaultOptionsEntity;
//   void clear(){
//     options.clear();
//     optionsEntity = defaultOptionsEntity;
//     notifyListeners();
//   }
//   void setOption(OptionsEntity? optionsEntity){
//     this.optionsEntity = optionsEntity??defaultOptionsEntity;
//     notifyListeners();
//   }
//   Future refresh()async{
//     clear();
//     await getOptions();
//   }
//   Future getOptions()async{
//     Either<DioException,List<OptionsEntity>> value = await OptionUseCases(sl()).getOptions();
//     value.fold((l) {
//       showToast(l.message!);
//     }, (r) {
//       options.clear();
//       options.addAll(r);
//       notifyListeners();
//     });
//   }
//
//   @override
//   String displayedName() {
//     if(optionsEntity.amount==-1){
//       return LanguageProvider.translate("global", 'all');
//     }
//     return optionsEntity.amount.toString();
//   }
//
//   @override
//   String displayedOptionName(OptionsEntity optionsEntity) {
//     return optionsEntity.amount.toString();
//   }
//
//   @override
//   List<OptionsEntity> list() {
//     return options;
//   }
//
//   @override
//   Future onTap(data) async{
//     setOption(data);
//   }
//
//   @override
//   OptionsEntity? selected() {
//     return optionsEntity;
//   }
// }