
import '../../feature/cart/domain/entities/cart_product_entity.dart';
import '../../feature/order/domain/entities/order_entity.dart';

class OrderProvider{
  OrderEntity? orderEntity;
  List<Map> data() {
    throw UnimplementedError();
  }

  List<Map> reasons = [];

  List<CartProductEntity> products() {
    throw UnimplementedError();
  }
  bool showReasons() {
    return false;
  }
  bool showUpdatePaidButton() {
    return false;
  }
  bool showEditButton() {
    return false;
  }
  bool showTopButton() {
    return false;
  }
  bool showBottomButton() {
    return false;
  }
  void refreshOrder() {
  }
  void editOrder() {
  }
  void topButtonAction() {
  }
  void bottomButtonCancelAction() {
  }
  void bottomButtonAction() {
  }
  void updatePaidButton() {
  }
  String topButtonTitle() {
    throw UnimplementedError();
  }
  String bottomButtonTitle() {
    throw UnimplementedError();
  }
}