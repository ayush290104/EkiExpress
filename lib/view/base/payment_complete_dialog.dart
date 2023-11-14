import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PaymentCompleteDialog extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String shortDescription;
  final Function onYesPressed;
  final bool isLogOut;
  final Function onNoPressed;
  PaymentCompleteDialog({@required this.icon, this.title,
    @required this.description,
    @required this.shortDescription,
    @required this.onYesPressed,
    this.isLogOut = false, this.onNoPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(width: 500, child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Image.asset(icon, width: 50, height: 50, ),
            ),

            title != null ? Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
              child: Text(
                title, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
              ),
            ) : SizedBox(),

            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
            Text(description, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
            Text(shortDescription, style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).primaryColor,
            ),
                textAlign: TextAlign.center),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

            GetBuilder<OrderController>(builder: (orderController) {
              return !orderController.isLoading ? CustomButton(
                buttonText: isLogOut ? 'no'.tr : 'ok'.tr,
                onPressed: () => isLogOut ? Get.back() : onYesPressed(),
                radius: Dimensions.RADIUS_SMALL, height: 50,
                width: 90,
              ) : Center(child: CircularProgressIndicator());
            }),

          ]),
        )),
      ),
    );
  }
}
