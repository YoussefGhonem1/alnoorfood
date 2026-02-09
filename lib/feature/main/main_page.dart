import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart';
import '../../config/text_style.dart';
import '../../core/constants/constants.dart';
import '../../core/constants/images.dart';
import '../../core/constants/var.dart';
import '../../core/widget/appbar_widget.dart';
import '../../core/widget/svg_widget.dart';
import '../cart/presentation/pages/cart_page.dart';
import '../cart/presentation/provider/cart_provider.dart';
import '../home/presentation/pages/home_page.dart';
import '../language/presentation/provider/language_provider.dart';
import '../product/presentation/pages/favorite_page.dart';
import '../product/presentation/pages/new_page.dart';
import '../settings/presentation/pages/settings_page.dart';
import 'main_model.dart';
import 'main_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<CartProvider>(Constants.globalContext(),listen: false).refresh();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.resumed == state) {
    }
  }
  final List<MainModel> _items = [
    MainModel(disActiveSVG: Images.homeSVG,label: 'home',svg: Images.activeHomeSVG),
    MainModel(disActiveSVG: Images.supportSVG,label: 'support_live',svg: Images.activeNewSVG),
    MainModel(disActiveSVG: Images.favSVG,label: 'fav',svg: Images.activeFavSVG),
    MainModel(disActiveSVG: Images.cartSVG,label: 'cart',svg: Images.activeCartSVG),
    MainModel(disActiveSVG: Images.personSVG,label: 'person',svg: Images.activePersonSVG),
  ];
  List<Widget> bottomWidget = [
    HomePage(),
    // NewPage(),
    SizedBox(),
    FavoritePage(),
    const CartPage(),
    const SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    var main = Provider.of<MainProvider>(context,listen: true);
    return PopScope(
      canPop: true,
      onPopInvoked: (val)async{

      },
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: appBarWidget(),
          bottomNavigationBar: isGuest?null:Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.3),
                    offset: Offset(0, -8),spreadRadius: 3,
                blurRadius: 9),
              ],
            ),
            child: BottomNavigationBar(
              items: List.generate(_items.length, (index) => BottomNavigationBarItem(
                icon: index==3?Badge(
                  textStyle: TextStyleClass.smallStyle(),
                  label: Text((Provider.of<CartProvider>(context,listen: true).cartProducts?.length??0).toString()),
                  backgroundColor: AppColor.defaultColor,
                  child: SvgWidget(color: index==main.index?AppColor.defaultColor:AppColor.greyColor,
                    svg: index==main.index?_items[index].svg:_items[index].disActiveSVG,),
                ):SvgWidget(color: index==main.index?AppColor.defaultColor:AppColor.greyColor,
                  svg: index==main.index?_items[index].svg:_items[index].disActiveSVG,),
                label: LanguageProvider.translate("main", _items[index].label),
                backgroundColor: Colors.white,
              ),),
              onTap: (int value){
                main.setIndex(value);
              },

              currentIndex: main.index,
              selectedLabelStyle: TextStyleClass.normalStyle(),
              unselectedLabelStyle: TextStyleClass.normalStyle(),
              showSelectedLabels: true,
              elevation: 0,
              selectedFontSize: 10,
              type: BottomNavigationBarType.fixed,
              fixedColor: AppColor.defaultColor,
              unselectedItemColor: AppColor.greyColor,
              showUnselectedLabels: true,
              backgroundColor: Colors.white,
            ),
          ),
          body: bottomWidget[main.index],
        ),
      ),
    );
  }
}