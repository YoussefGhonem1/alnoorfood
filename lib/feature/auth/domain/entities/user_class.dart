import 'package:equatable/equatable.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/models/selected_class.dart';
import '../../../address/domain/entities/address_entity.dart';
import '../../../language/presentation/provider/language_provider.dart';
import 'pay_type_class.dart';

class UserClass extends Equatable{
  int id;
  String name;
  String userName;
  String email;
  String phone;
  num discount;
  num points;
  String workTime;
  String type;
  PayType payType;
  String token;
  String? clientDirective;
  int? code;//use this on otp
  AddressEntity addressEntity;

  UserClass(
      {required this.id,
        required this.name,
        required this.userName,
        required this.email,
        required this.type,
        required this.points,
        required this.phone,
        required this.addressEntity,
        required this.discount,
        required this.workTime,
        required this.payType,
        required this.code,
        required this.clientDirective,
        required this.token});

  @override
  List<Object?> get props => [id,name,userName,email,phone,discount,addressEntity,points,
    workTime,payType,token,code,clientDirective];

  SelectedClass selectedClass(){
    return SelectedClass(image: Images.walletSVG,
        title: LanguageProvider.translate('orders', 'payment'), onTap: null, body: payType==PayType.bolla?'bolla':'fattura');
  }

  String getPayTypeString(){
    return payTypeString[payType]!;
  }

  @override
  String body() {
    return payType==PayType.bolla?'bolla':'fattura';
  }

  @override
  void Function() onTap() {
    // return (){
    //   showModalBottomSheet(context: context,shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    //   ), builder: (ctx){
    //     return Container(
    //       width: 100.w,
    //       height: 25.h,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    //       ),
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
    //         child: Column(
    //           children: [
    //             Row(
    //               children: [
    //                 InkWell(onTap: (){navPop();},child: Icon(Icons.close,size: 20,)),
    //                 SizedBox(width: 5.w,),
    //                 Text(LanguageProvider.translate('check_out', 'payment_method'),
    //                   style: TextStyleClass.semiBoldStyle(),),
    //               ],
    //             ),
    //             OptionWidget(onTap: (){}, image: Images.walletSVG, title: 'bolla'),
    //             OptionWidget(onTap: (){}, image: Images.contoSVG, title: 'conto'),
    //           ],
    //         ),
    //       ),
    //     );
    //   });
    // };
    return (){};
  }

  @override
  String title() {
    return LanguageProvider.translate('orders', 'payment');
  }
}