import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class CostVariationsDialog extends StatelessWidget {
  final Function onYesPressed;
  final bool isLogOut;
  CostVariationsDialog({

    @required this.onYesPressed,
    this.isLogOut = false,
  });

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
            Text('cost_variations'.tr,style: robotoMedium.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeLarge),),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

            ListView.builder(
                itemCount: 4,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    border: Border.all(color:index != 0 ? Theme.of(context).disabledColor.withOpacity(.5):Theme.of(context).primaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color:Theme.of(Get.context).textTheme.bodyLarge.color.withOpacity(.5),
                            ),
                            children: [
                              TextSpan(
                                  text: '\$',
                                  style: robotoRegular.copyWith(
                                      color: Theme.of(Get.context).textTheme.bodyLarge.color,
                                      fontSize: Dimensions.fontSizeSmall)),
                              TextSpan(
                                  text: '85',
                                  style: robotoBold.copyWith(
                                      color: Theme.of(Get.context).textTheme.bodyLarge.color,
                                      fontSize: Dimensions.fontSizeExtraLarge)),
                              TextSpan(
                                  text: '/hr',
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),

                              TextSpan(
                                  text: ' (inside city)',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),
                            ],
                          ),
                        ),

                        if(index == 0)
                        Container(
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.check, size: 12, color: Colors.white),
                        ),

                      ],
                    ),
                  ),),
              );
            }),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

            CustomButton(
              buttonText: 'see_total_cost'.tr,
              fontSize: Dimensions.fontSizeDefault,
              onPressed: () => onYesPressed(),
              radius: Dimensions.RADIUS_SMALL, height: 40,
              width: 120,
            )

          ]),
        )),
      ),
    );
  }
}
