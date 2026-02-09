import 'package:get_it/get_it.dart';
import 'package:homsfood/feature/chat/data/repositories/chat_repository_impl.dart';
import 'package:homsfood/feature/chat/domain/repositories/chat_repository.dart';
import 'package:homsfood/feature/delivery_visit/data/repositories/delivery_visit_repository_impl.dart';
import 'package:homsfood/feature/delivery_visit/domain/repositories/delivery_visit_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'core/helper_function/sql.dart';
import 'feature/address/data/repositories/address_repository_impl.dart';
import 'feature/address/domain/repositories/address_repository.dart';
import 'feature/auth/data/repositories/auth_repository_impl.dart';
import 'feature/auth/domain/repositories/auth_repository.dart';
import 'feature/cart/data/repositories/cart_repository_impl.dart';
import 'feature/cart/domain/repositories/cart_repository.dart';
import 'feature/category/data/repositories/category_repository_impl.dart';
import 'feature/category/domain/repository/category_repository.dart';
import 'feature/cities/data/repositories/cities_repo_impl.dart';
import 'feature/cities/domain/repositories/cities_repo.dart';
import 'feature/home/data/repository/home_repository_impl.dart';
import 'feature/home/domain/repository/home_repositorry.dart';
import 'feature/material/data/repositories/material_repository_impl.dart';
import 'feature/material/domain/repositories/material_repository.dart';
import 'feature/notification/data/repositories/notification_repository_impl.dart';
import 'feature/notification/domain/repositories/notification_repository.dart';
import 'feature/order/data/repositories/order_delivery_repository_impl.dart';
import 'feature/order/data/repositories/order_repository_impl.dart';
import 'feature/order/domain/repositories/order_delivery_repository.dart';
import 'feature/order/domain/repositories/order_repository.dart';
import 'feature/product/data/repositories/product_repository_impl.dart';
import 'feature/product/domain/repositories/product_repository.dart';
import 'feature/settings/data/repositories/settings_repository_impl.dart';
import 'feature/settings/domain/repositories/settings_repository.dart';
import 'feature/support/data/repositories/support_repository_impl.dart';
import 'feature/support/domain/repositories/support_repository.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  // Dio
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<HomeRepository>(HomeRepositoryImpl());
  sl.registerSingleton<ProductRepository>(ProductRepositoryImpl());
  sl.registerSingleton<CartRepository>(CartRepositoryImpl());
  sl.registerSingleton<AddressRepository>(AddressRepositoryImpl());
  sl.registerSingleton<OrderRepository>(OrderRepositoryImpl());
  sl.registerSingleton<MaterialRepository>(MaterialRepositoryImpl());
  sl.registerSingleton<SupportRepository>(SupportRepositoryImpl());
  sl.registerSingleton<SettingsRepository>(SettingsRepositoryImpl());
  sl.registerSingleton<NotificationRepository>(NotificationRepositoryImpl());
  sl.registerSingleton<OrderDeliveryRepository>(OrderDeliveryRepositoryImpl());
  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl());
  sl.registerSingleton<CitiesRepo>(CitiesRepoImpl());
  sl.registerSingleton<DeliveryVisitRepository>(DeliveryVisitRepositoryImpl());
  sl.registerSingleton<ChatRepository>(ChatRepositoryImpl());
  sl.registerSingleton<Database>(await SQLHelper().database);

}