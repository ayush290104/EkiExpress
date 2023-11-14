import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class ServiceTypeCard extends StatelessWidget {
  final String rentType;
  final String rentPrice;
  final bool isSelected;
  final Function onTap;
  const ServiceTypeCard({Key key,@required this.rentPrice, @required this.rentType,@required this.isSelected,@required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ?  Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).colorScheme.background.withOpacity(.5),
          borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
          border:isSelected ?  Border.all(color: Theme.of(context).primaryColor.withOpacity(.5)):null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'rent'.tr + ' ',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      TextSpan(
                          text: rentType,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(Images.car_icon,width: 54,height: 38,),
                      Column(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: '\$',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                TextSpan(
                                    text: rentPrice,
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                                TextSpan(
                                    text: '/hr',
                                    style: robotoBold.copyWith(
                                        color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5),
                                        fontSize: Dimensions.fontSizeSmall)),
                              ],
                            ),
                          ),
                          SizedBox(height: 6,),
                          Text('start_form'.tr),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
