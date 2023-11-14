import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class CancellationDialog extends StatelessWidget {
  final String icon;
  final String title;
  final Function onYesPressed;
  final bool isLogOut;
  final Function onNoPressed;
  CancellationDialog({
    @required this.icon,
    this.title,
    @required this.onYesPressed,
    this.isLogOut = false,
    this.onNoPressed});

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
              child: Image.asset(icon, width: 50, height: 50,),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

            title != null ? Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: Text(
                title, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, ),
              ),
            ) : SizedBox(),
            SizedBox(height: 50),

            GetBuilder<OrderController>(builder: (orderController) {
              return !orderController.isLoading ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                TextButton(
                  onPressed: () =>  onNoPressed != null ? onNoPressed() : Get.back(),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: Size(80, 50), padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                  ),
                  child: Text( 'no'.tr, textAlign: TextAlign.center,
                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge.color),
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                Container(
                  child: Center(child: Text('yes'.tr,style: robotoRegular.copyWith(color: Theme.of(context).cardColor),)),
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(.7),
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                ),
              ]) : Center(child: CircularProgressIndicator());
            }),

          ]),
        )),
      ),
    );
  }
}
