import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/confirm_dialog.dart';
import '../../../../core/dialog/drop_down_dialog.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/api.dart';
import '../../../../core/helper_function/helper_function.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/location.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/text_field_model.dart';
import '../../../../injection_container.dart';
import '../../../address/presentation/pages/map_page.dart';
import '../../../address/presentation/provider/bottom_map_sheet.dart';
import '../../../address/presentation/provider/map_provider.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../category/presentation/provider/category_provider.dart';
import '../../../cities/presentation/provider/city_provider.dart';
import '../../../home/presentation/provider/home_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../main/main_page.dart';
import '../../../main/main_provider.dart';
import '../../../order/presentation/provider/order_delivery_provider.dart';
import '../../../product/presentation/provider/search_product_provider.dart';
import '../../domain/entities/delivery_entity.dart';
import '../../domain/entities/user_class.dart';
import '../../domain/use_cases/auth_usecases.dart';
import '../pages/forget_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import 'otp_provider.dart';

class AuthenticationProvider extends ChangeNotifier{

  bool login = false;
  bool acceptTerms = false;
  XFile? image;
  UserClass? userEntity;
  bool imageUpdated = false;
  bool fromAuthRegister = true;
  List<TextFieldModel> registerInputs = [];
  String titleText() {
    return fromAuthRegister ? (deliveryEntity==null?"":"create_user") : "edit_profile";
  }
  void updateImage(XFile image) {
    imageUpdated = true;
    this.image = image;
    notifyListeners();
  }
  // showUserImage() {
  //   if (userEntity?.image != null || image != null) {
  //     if (image != null) {
  //       return FileImage(File(image!.path));
  //     } else {
  //       return CachedNetworkImageProvider(userEntity!.image,);
  //     }
  //   } else {
  //     return const AssetImage(Images.logo);
  //   }
  // }

  CityProvider cityProvider = Provider.of(Constants.globalContext(),listen: false);


  void goToRegisterPage({fromAuthRegister = true}) {
    this.fromAuthRegister = fromAuthRegister;
    image = null;
    imageUpdated = false;
    if (fromAuthRegister) {
      // isAskerLoan = true;
      registerInputs = [
        TextFieldModel(
            key: "name",
            controller: TextEditingController(),
            label: "name",
            // validator: (value) => validateName(value!),
            // image: Images.userIcon,
            next: true,
            hint: "name"),
        TextFieldModel(
          key: "phone",
          controller: TextEditingController(),
          label: "phone",
          // image: Images.mobileIcon,
          // validator: (value) => validatePhone(value!),
          textInputType: TextInputType.phone,
          hint: "phone",
          next: true,
        ),
        TextFieldModel(
          key: "email",
          controller: TextEditingController(),
          label: "email",
          // image: Images.mailIcon,
          // validator: (value) => validateEmail(value!),

          textInputType: TextInputType.emailAddress,
          hint: "email",
          next: true,
        ),
        TextFieldModel(
          key: "city_id",
          controller: TextEditingController(text: cityProvider.cityEntity?.name??""),
          label: "city",
          // image: Images.lockIcon,
          hint: "city",
          // validator: (value) => validatePassword(value!),
          readOnly: true,
          onTap: (){
            showDropDownDialog(cityProvider).then((v){
              registerInputs.firstWhere((element) => element.key=="city_id",).controller.text = cityProvider.cityEntity?.name??"";
              notifyListeners();
            });
          },
          next: true,
        ),
        TextFieldModel(
          key: "password",
          controller: TextEditingController(),
          label: "pass",
          // image: Images.lockIcon,
          hint: "************",
          // validator: (value) => validatePassword(value!),
          obscureText: true,
          next: true,
        ),
      ];
    } else {
      // downloadImages();
      registerInputs = [
        TextFieldModel(
            key: "name",
            controller: TextEditingController(text: userEntity?.name ?? ""),
            label: "name",
            image: Images.personSVG,
            // validator: (value) => validateName(value!),
            hint: "name"),
          TextFieldModel(
            key: "email",
            controller: TextEditingController(text: userEntity?.email ?? ""),
            label: "email",
            image: Images.emailSVG,
            textInputType: TextInputType.emailAddress,
            // validator: (value) => validateEmail(value!),
            hint: "email",
            next: true,
          ),
        TextFieldModel(
            key: "phone",
            controller: TextEditingController(text: userEntity?.phone ?? ""),
            label: "phone",
            image: Images.phoneSVG,
            textInputType: TextInputType.phone,
            // validator: (value) => validatePhone(value!),
            next: false,
            // suffix: const CountryWidget()
        ),
      ];
    }
    navP(RegisterPage());
  }

  void changeAcceptTerms() {
    acceptTerms = !acceptTerms;
    notifyListeners();
  }
  String token = '123';
  List<Map> loginInputs = [
    {"key":"email","image":Images.emailSVG,"value":TextEditingController(),"label":"email"},
    {"key":"password","image":Images.passSVG,"value":TextEditingController(),"label":"pass"},
  ];

  final List<Map> updatePassInputs = [
    {"key":"password","image":Images.passSVG,
      "value":TextEditingController(),"label":"new_pass"},
    {"key":"confirm_pass","image":Images.passSVG,
      "value":TextEditingController(),"label":"confirm_pass"},
  ];

  Future<bool> checkLogin()async{
    var prefs = await SharedPreferences.getInstance();
    login = prefs.getBool('login')??false;
    return login;
  }

  void forgetPass()async{
    navP(ForgetPage());
  }
  void loginButton({bool fromSplash = false,bool fromRegister = false})async{
    try{
      token = await FirebaseMessaging.instance.getToken()??"123";
    }catch(e){
      token = '123';
    }
    Map<String,dynamic> data = {};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(fromSplash){
      loginInputs.firstWhere((element) => element['key']=='email')['value'] =
          TextEditingController(text: sharedPreferences.getString("email")!);
      loginInputs.firstWhere((element) => element['key']=='password')['value'] =
          TextEditingController(text: sharedPreferences.getString("password")!);
    }else if (fromRegister){
      loginInputs.firstWhere((element) => element['key']=='email')['value'] =
          TextEditingController(text: registerInputs.firstWhere((element) => element.key=='email').controller.text);
      loginInputs.firstWhere((element) => element['key']=='password')['value'] =
          TextEditingController(text: registerInputs.firstWhere((element) => element.key=='password').controller.text);
      for (var element in registerInputs) {
        element.controller.clear();
      }
      for (var element in bottomMapSheetProvider.inputs) {
        element['value'].clear();
      }
      cityProvider.cityEntity = null;
    }
    for (var element in loginInputs) {
      data[element['key']] = element['value'].text;
    }
    data['fcm_token'] = token;
    print(data['fcm_token']);
    print(data);
    if(!fromSplash)loading();
    Either<DioException, Either<UserClass,DeliveryEntity>> login = await AuthUseCases(sl()).login(data);
    login.fold((l)  {
      if(!fromSplash)navPop();
      if(fromSplash){
        navPARU(LoginPage());
      }else{
        showToast(l.message!);
      }
    }, (r) async {
      isGuest = false;
      sharedPreferences.setBool('login', true);
      sharedPreferences.setString('email', data['email']);
      sharedPreferences.setString('password', data['password']);
      Provider.of<CartProvider>(Constants.globalContext(),listen: false).setOrder(null);
      r.fold((l) async{
        isUser = true;
        // userClass = l;
        userEntity = l;

        ApiHandel.getInstance.updateHeader(l.token);
        await delay(300);
        Provider.of<MainProvider>(Constants.globalContext(),listen: false).setIndex(0);
        var home = Provider.of<HomeProvider>(Constants.globalContext(),listen: false);
        home.clearList();
        home.getHomeData(back: false,showLoading: false);
        await Future.wait([
          Provider.of<CategoryProvider>(Constants.globalContext(),listen: false).refresh(),
          // Provider.of<OptionsProvider>(Constants.globalContext(),listen: false).refresh(),
        ]).then((value) {

          Provider.of<SearchProductProvider>(Constants.globalContext(),listen: false).refresh();
        });
        navPARU(const MainPage());
      }, (r) {
        isUser = false;
        deliveryEntity = r;
        ApiHandel.getInstance.updateHeader(r.token);
        Provider.of<CategoryProvider>(Constants.globalContext(),listen: false).refresh();
        // Provider.of<OptionsProvider>(Constants.globalContext(),listen: false).refresh();
        OrdersDeliveryProvider ordersDeliveryProvider =
        Provider.of(Constants.globalContext(),listen: false);
        ordersDeliveryProvider.goOrdersPage();
      });
    });
  }

  void guestLogin({bool fromLogin = false})async{
    isGuest = true;
    userEntity = null;
    deliveryEntity = null;
    var home = Provider.of<HomeProvider>(Constants.globalContext(),listen: false);
    Provider.of<MainProvider>(Constants.globalContext(),listen: false).setIndex(0);
    home.getHomeDataGuest(back: false,showLoading: false,);
    if(fromLogin)loading();
    await Future.wait([
      Provider.of<CategoryProvider>(Constants.globalContext(),listen: false).refresh(),
      // Provider.of<OptionsProvider>(Constants.globalContext(),listen: false).refresh(),
    ]).then((value) async{
      await delay(200);
      Provider.of<SearchProductProvider>(Constants.globalContext(),listen: false).refresh();
    });
    navPARU(MainPage());
  }
  void updateUser(UserClass user){
    userEntity = user;
  }
  void updateDelivery(DeliveryEntity delivery){
    deliveryEntity = delivery;
  }
  void updatePass()async{
    Map<String,dynamic> data = {};
    data['email'] = Provider.of<OTPProvider>
      (Constants.globalContext(),listen: false).email;
    data['password'] = updatePassInputs[0]['value'].text;
    loading();
    Either<DioException, bool> login;
    if(isUser){
      login = await AuthUseCases(sl()).updatePass(data);
    }else{
      login = await AuthUseCases(sl()).updateDeliveryPass(data);
    }
    navPop();
    login.fold((l)  {
      showToast(l.message!);
    }, (r)  {
      successDialog(msg: 'pass',then: (){
        navPU();
      });
    });
  }

  void userLogout()async{
    Map<String,dynamic> data = {};
    data['token'] = token;
    loading();
    Either<DioException, bool> login = await AuthUseCases(sl()).logout(data);
    navPop();
    login.fold((l)  {
      showToast(l.message!);
    }, (r)  async{
      isUser = false;
      deliveryEntity = null;
      userEntity = null;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool('login', false);
      sharedPreferences.remove("email");
      sharedPreferences.remove("password");
      navPARU(LoginPage());
    });
  }
  void deliveryLogout()async{
    Map<String,dynamic> data = {};
    data['token'] = token;
    loading();
    Either<DioException, bool> login = await AuthUseCases(sl()).logoutDelivery(data);
    navPop();
    login.fold((l)  {
      showToast(l.message!);
    }, (r)  async{
      deliveryEntity = null;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool('login', false);
      sharedPreferences.remove("email");
      sharedPreferences.remove("password");
      navPARU(LoginPage());
    });
  }
  void logout(){
    if(isUser){
      userLogout();
    }else{
      deliveryLogout();
    }
  }
  void deleteAccount()async{
    Map<String,dynamic> data = {};
    data['token'] = token;
    loading();
    Either<DioException, bool> login = await AuthUseCases(sl()).deleteAccount(data);
    navPop();
    login.fold((l)  {
      showToast(l.message!);
    }, (r)  async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool('login', false);
      sharedPreferences.remove("email");
      sharedPreferences.remove("password");
      navPARU(LoginPage());
    });
  }
  void confirmLogout(){
    confirmDialog(Constants.globalContext(), LanguageProvider.translate('confirm_dialog', 'logout'),
        LanguageProvider.translate('buttons', 'yes'), () {
      logout();
        });
  }
  void confirmDeleteAccount(){
    confirmDialog(Constants.globalContext(), LanguageProvider.translate('buttons', 'delete_account'),
        LanguageProvider.translate('buttons', 'delete_account'), () {
          deleteAccount();
        });
  }

  //
  // void canRegister({bool isResend = false}) async {
  //   Map<String, dynamic> data = {};
  //
  //   loading();
  //   for (var element in registerInputs) {
  //     data[element.key!] = element.controller.text == '' ? null : element.controller.text;
  //   }
  //   Either<DioException, String> login = await AuthUseCases(sl()).canRegister(data);
  //   navPop();
  //   login.fold((l) {
  //     showToast(l.message!);
  //   }, (r) async {
  //     // Provider.of<OtpProvider>(Constants.globalContext(), listen: false).sendCodeFromRegister(code: r, isResend: isResend);
  //   });
  // }


  void updateProfileButton() async {
    Map<String, dynamic> data = {};
    for (var element in registerInputs) {
      data[element.key!] = element.controller.text == '' ? null : element.controller.text;
    }
    if (image != null && imageUpdated) {
      data['image'] = await MultipartFile.fromFile(image!.path);
    }
    if (data['phone'].toString().startsWith('0')) {
      data['phone'].toString().substring(1);
    }
    loading();

    Either<DioException, UserClass> login = await AuthUseCases(sl()).updateProfile(data);
    login.fold((l) {
      navPop();
      showToast(l.message!);
    }, (r) async {
      userEntity = r;
      await delay(100);
      Provider.of<LanguageProvider>(Constants.globalContext(), listen: false).rebuild();
      // Provider.of<MainProvider>(Constants.globalContext(), listen: false).setIndex(0);
      successDialog(then: () {
        navPop();
        navPop();
      });
      notifyListeners();
    });
  }


  void goToAddAddressPage()async{

    if(userEntity==null){
      fromAuthRegister = true;
      await determinePosition();
    }
    // navPop();

    bottomMapSheetProvider.inputs =  [
      {"key":"address_name","image":Images.locationSVG,"value":TextEditingController(text: userEntity?.addressEntity.name??"work"),
        "label":"address_name","show":false},
      {"key":"recipient_name","image":Images.activePersonSVG,"value":TextEditingController(text: userEntity?.addressEntity.recipientName??(registerInputs.firstWhere((e)=> e.key=='name').controller.text)),
        "label":"address_receiver_name","show":false},
      {"key":"recipient_number","image":Images.phoneSVG,"value":TextEditingController(text: userEntity?.addressEntity.recipientNumber??(registerInputs.firstWhere((e)=> e.key=='phone').controller.text)),
        "label":"phone","type":TextInputType.phone,"show":true},
      {"key":"address","image":Images.locationSVG,"value":TextEditingController(text: userEntity?.addressEntity.address??""),
        "label":"address_street","show":true},
    ];
    bottomMapSheetProvider.expanded = false;
    if(userEntity!=null){
      fromAuthRegister = false;
      MapProvider mapProvider = Provider.of(Constants.globalContext(),listen: false);
      mapProvider.setData(userEntity!.addressEntity.lat, userEntity!.addressEntity.lng);
    }
    navP(const MapPage(),then: (val){});
  }
  BottomMapSheetProvider bottomMapSheetProvider = Provider.of(Constants.globalContext(),listen: false);

  void registerButton() async {
    token = await FirebaseMessaging.instance.getToken() ?? "123";
    loading();

    // token = "aaa";
    // loading();
    Map<String, dynamic> data = {};
    data['fcm_token'] = token;
    for (var element in registerInputs) {
      if(element.key!="city"){
        data[element.key!] = element.controller.text == '' ? null : element.controller.text;

      }
    }
    for (var element in bottomMapSheetProvider.inputs) {
      data[element['key']] = element['value'].text == '' ? null : element['value'].text;
    }
    MapProvider mapProvider = Provider.of(Constants.globalContext(),listen: false);
    data['latitude'] = mapProvider.lat;
    data['longitude'] = mapProvider.lng;

    data["city_id"] = Provider.of<CityProvider>(Constants.globalContext(),listen: false).cityEntity?.id;

    print('ssssss$data');
    Either<DioException, UserClass> login = await AuthUseCases(sl()).register(data);
    navPop();

    // navPop();
    login.fold((l) {
      showToast(l.message!);
    }, (r) async {

      if(deliveryEntity==null){
        loginButton(fromRegister:true);
      }else{
        successDialog(then: (){
          CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
          cartProvider.addUser(r);
          navPop();
          navPop();
        });
      }

    });
  }

}