import 'package:flutter/material.dart';


import '../../../../controller/cart_controller.dart';
import '../../../../controller/item_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/images.dart';
import '../../../base/confirmation_dialog.dart';
import '../../../base/custom_snackbar.dart';
import '../../checkout/checkout_screen.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;


ApiCal(item) {

  debugPrint("name of item is ${item.id}");

  if(GetPlatform.isWeb){
    String urlString = "http://localhost:63004/item-details?id=${item.id}&page=item";
    Uri uri = Uri.parse(urlString);
    String itemId = uri.queryParameters['id'];
    debugPrint("url of the webpage i am using is ${int.parse(itemId)}");
    print("----------- else line 25 ---- ${item.id}");
    Get.find<ItemController>()
        .getProductDetails(item, int.parse(itemId));
  }
  else{
    print("----------- else line 30 ---- $item");

    Get.find<ItemController>()
        .getProductDetails(item, item.id);
  }
}


Widget AddToCart(itemController,cartModel,stock,item){
debugPrint("Stock of all the elements here is stock and that is ${stock}");

  return stock!=0?GestureDetector(
      onTap: (){
        //Get.snackbar("item is item name is ${item.name}","");

        debugPrint("item is item name is ${item.name}");
        print(stock);
        print("item id prinrted -------------- ${item.id}");
        ApiCal(item);

        if(itemController.item.availableDateStarts != null) {
          Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
            storeId: null, fromCart: false, cartList: [cartModel],
          ));
        }else if (Get.find<CartController>().existAnotherStoreItem(cartModel.item.storeId, Get.find<SplashController>().module.id)) {
          Get.dialog(ConfirmationDialog(
            icon: Images.warning,
            title: 'are_you_sure_to_reset'.tr,
            description: Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
                ? 'if_you_continue'.tr : 'if_you_continue_without_another_store'.tr,
            onYesPressed: () {
              Get.back();
              Get.find<CartController>().removeAllAndAddToCart(cartModel);
              showCustomSnackBar('item_added_to_cart'.tr, isError: false);
            },
          ), barrierDismissible: false);
        } else {
          if(itemController.cartIndex == -1) {
            print('--------------itemController.cartIndex--------------------${itemController.cartIndex}');
            Get.find<CartController>().addToCart(cartModel, itemController.cartIndex);
          }

          showCustomSnackBar('item_added_to_cart'.tr, isError: false);
        }},
      child: Icon(Icons.add)):Image(image: AssetImage('assets/image/outofstock.jpg'),height: 30,width: 30,);
}

