import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/model/response/vehicle_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/ripple_button.dart';
import 'package:sixam_mart/view/screens/taxi_booking/widgets/cost_variations_dialog.dart';


class CarInfo extends StatelessWidget {
  final Vehicles vehicle;
  const CarInfo({Key key, @required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List carFeatureList = [
      {'icon': Images.rider_seat, 'name': '${vehicle.seatingCapacity} ${'seat'.tr}'},
      {'icon': Images.petrol_icon, 'name': '${vehicle.fuelType}'},
      {'icon': Images.rider_km, 'name': '${vehicle.engineCapacity}${vehicle.mileageType}'},
      {'icon': Images.car_hp, 'name': '${vehicle.engineCapacity}cc'},
      {'icon': Images.rider_seat, 'name': 'Auto'},
      {'icon': Images.ac_icon, 'name': '${vehicle.airCondition == 'yes' ? 'ac'.tr : 'non_ac'.tr}'},
    ];

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Theme.of(context).cardColor,
      child: Container(
        height: 200,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vehicle.name, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Theme.of(context).primaryColor.withOpacity(.04),
                            border: Border.all(color: Theme.of(context).primaryColor)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL,
                            vertical: Dimensions.PADDING_SIZE_SMALL,
                          ),
                          child: Text('cost_variation'.tr,style: robotoBold.copyWith(color: Theme.of(context).primaryColor),),
                        ),
                      ),
                      Positioned.fill(child: RippleButton(
                        radius: Dimensions.RADIUS_DEFAULT,
                          onTap: () {
                            Get.dialog(CostVariationsDialog(
                              onYesPressed: () {
                              },
                            ));
                          }),
                      )

                    ],
                  )
                ],
              ),
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
                  ),
                ],
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(
                  children: [
                    GridView.builder(
                      itemCount: carFeatureList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {

                        return carFeatureItem(
                            carFeatureList.elementAt(index)['icon'],
                            carFeatureList.elementAt(index)['name']);
                      },),

                  ],
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

            ],
          ),
        ),),
    );
  }

  Widget carFeatureItem(String imagePath,String title){
    return Row(
      children: [
        Image.asset(imagePath,height: 15,),
        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
        Text(title),
      ],
    );
  }
}
