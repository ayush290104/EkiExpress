import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/rider_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'price_stack_tag.dart';

class TopRatedCars extends StatelessWidget {
  const TopRatedCars({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        Text(
          'top_rated_cars'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        GetBuilder<RiderController>(
          builder: (riderController) {
            return riderController.topRatedVehicleModel != null && riderController.topRatedVehicleModel.vehicles.isNotEmpty ? Container(
              height: 177,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: riderController.topRatedVehicleModel.vehicles.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: 5),
                  child: InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getSelectRideMapLocationRoute("initial", null, riderController.topRatedVehicleModel.vehicles[index])),
                    child: Container(
                      width: Get.width / 2.6,
                      decoration: BoxDecoration(
                        color:Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200], offset: Offset(0, 3.75), blurRadius: 9.29)],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          child: CustomImage(
                                              image: '${Get.find<SplashController>().configModel.baseUrls.vehicleImageUrl}/${riderController.topRatedVehicleModel.vehicles[index].carImages.isNotEmpty
                                                  ? riderController.topRatedVehicleModel.vehicles[index].carImages[0] : ''}',
                                              height: 130,width: Get.width),
                                        ),
                                        ReviewStackTag(value: "${riderController.topRatedVehicleModel.vehicles[index].avgRating}, (${riderController.topRatedVehicleModel.vehicles[index].ratingCount} ${'review'.tr})")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    riderController.topRatedVehicleModel.vehicles[index].name,
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                              Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                      child: CustomImage(height: 18, width: 18, image: '${Get.find<SplashController>().configModel.baseUrls.vehicleImageUrl}/'
                                          '${riderController.topRatedVehicleModel.vehicles[index].provider != null ? riderController.topRatedVehicleModel.vehicles[index].provider.logo : ''}'),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                  Text(
                                      riderController.topRatedVehicleModel.vehicles[index].provider != null ? riderController.topRatedVehicleModel.vehicles[index].provider.name : '',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                  )
                                ],
                              )
                            ]),
                      ),
                    ),
                  ),
                );
              }),
            ) : SizedBox();
          }
        )


      ],
    );
  }
}
