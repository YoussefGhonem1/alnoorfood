

abstract class DropDownClass<T>{
  String displayedName();
  String displayedOptionName(T type);
  Future onTap(T data);
  List<T> list();
  T? selected();
}