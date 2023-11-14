import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/data/model/body/user_information_body.dart';
import 'package:sixam_mart/data/model/response/vehicle_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/ripple_button.dart';

class RiderCarCard extends StatelessWidget {
  final Vehicles vehicle;
  final UserInformationBody filterBody;
  const RiderCarCard({Key key, @required this.vehicle, @required this.filterBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300], blurRadius: 5, spreadRadius: 1,)],
            ),
            margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
                    child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.vehicleImageUrl}/${vehicle.carImages.isNotEmpty ? vehicle.carImages[0] : ''}',
                      height: 130,width: Get.width),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      Text("${vehicle.name}",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Image.asset(Images.star_fill,height: 10,width: 10,),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                          Text('${vehicle.avgRating},',style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          ),),
                          Text(
                            "(${vehicle.ratingCount} ${'review'.tr})",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5),
                            ),
                          )
                        ]),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                carFeatureItem(Images.rider_seat, '${vehicle.seatingCapacity} ${'seat'.tr}'),
                                SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                                carFeatureItem(Images.ac_icon, '${vehicle.airCondition == 'yes' ? 'ac'.tr : 'non_ac'.tr}'),
                                SizedBox(width: Dimensions.PADDING_SIZE_LARGE,),
                                carFeatureItem(Images.rider_km, '${vehicle.engineCapacity}km/h'),
                              ],
                            ),
                          ),
                          SizedBox(height: 8,),

                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: '${Get.find<SplashController>().configModel.currencySymbol}',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                TextSpan(
                                    text: '${double.parse(vehicle.minFare.toString()).toStringAsFixed(Get.find<SplashController>().configModel.digitAfterDecimalPoint)}',
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                                TextSpan(
                                    text: '/hr',
                                    style: robotoBold.copyWith(
                                        color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5),
                                        fontSize: Dimensions.fontSizeSmall)),
                              ],
                            ),
                          ),

                        ],
                      ),


                    ],
                  ),
                )
              ],
            ),
          ),

          Positioned.fill(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            child: RippleButton(
              onTap: () => Get.toNamed(RouteHelper.getCarDetailsScreen(vehicle, filterBody)),
              radius: Dimensions.RADIUS_SMALL,
            ),
          )),

        ],
      ),
    );
  }

  Widget carFeatureItem(String imagePath,String title){
    return Row(
      children: [
        Image.asset(imagePath,height: 13,),
        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
        Text(title),
      ],
    );
  }
}
