import '../../../../core/constants/images.dart';

enum OrderStatusTypeEntity{
  newOrder,
  preparing,
  delivery,
  ended,
  canceled
}

Map<OrderStatusTypeEntity,String> orderStatusString = {
  OrderStatusTypeEntity.newOrder:"new",
  OrderStatusTypeEntity.preparing:"preparing",
  OrderStatusTypeEntity.delivery:"delivery",
  OrderStatusTypeEntity.ended:"ended",
  OrderStatusTypeEntity.canceled:"canceled",
};

Map<OrderStatusTypeEntity,String> orderStatusImage = {
  OrderStatusTypeEntity.newOrder:Images.newOrderStatusImage,
  OrderStatusTypeEntity.preparing:Images.preparingOrderStatusImage,
  OrderStatusTypeEntity.delivery:Images.deliveryOrderStatusImage,
  OrderStatusTypeEntity.ended:Images.endedOrderStatusImage,
  OrderStatusTypeEntity.canceled:Images.canceledOrderStatusImage,
};