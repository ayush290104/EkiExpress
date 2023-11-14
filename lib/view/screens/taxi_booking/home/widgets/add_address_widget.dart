import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';

class AddAddressWidget extends StatelessWidget {
  final bool isLogin;
  const AddAddressWidget({Key key, @required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('add_address'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault))),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200], blurRadius: 5, spreadRadius: 1)]
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          child: InkWell(
            onTap: (){
              if(isLogin){
                Get.toNamed(RouteHelper.getAddAddressRoute(false, true, 0));
              }else{
                showCustomSnackBar('please_login_first'.tr);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    child: Icon(Icons.add,color: Theme.of(context).primaryColor,),
                    height: 33,
                    width: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
                        color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.rectangle),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('add_address'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),),
                      Text('type_or_select_from_map'.tr,style: robotoRegular.copyWith(fontSize: 10),),
                    ],
                  ),
                ],),
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Image.asset(Images.rider_add_address,height: 95,width: 70,),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
      ],
    );
  }
}
