import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/rider_controller.dart';
import 'package:sixam_mart/data/model/body/user_information_body.dart';
import 'package:sixam_mart/data/model/response/vehicle_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/screens/search/widget/custom_check_box.dart';
import 'package:sixam_mart/view/screens/taxi_booking/select_map_location/widgets/service_type_card.dart';
import 'dotted_line.dart';
import 'pick_and_destination_address_info.dart';

class AvailableServiceInfo extends StatefulWidget {
  final Vehicles vehicle;
  const AvailableServiceInfo({Key key, @required this.vehicle}) : super(key: key);

  @override
  State<AvailableServiceInfo> createState() => _AvailableServiceInfoState();
}

class _AvailableServiceInfoState extends State<AvailableServiceInfo> {
  @override
  void initState() {
    super.initState();
    Get.find<RiderController>().initSetup();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderController>(
      builder: (riderController){
        return Container(
          height: 550,
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                    Center(
                      child: Container(
                        height: 5, width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('trip_info'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),),
                        // Image.asset(Images.edit, width: 16.0, height: 16.0),
                        SizedBox()
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),
                    ///pick up and destination address
                    Container(
                      height: 90,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 33, width: 33,
                                alignment: Alignment.center,
                                decoration: riderContainerDecoration,
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      height: 18, width: 18,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.all(Radius.circular(2)),
                                      ),
                                    ),
                                    Container(
                                      height: 4,
                                      width: 4,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DottedLine(
                                lineLength: 20,
                                direction: Axis.vertical,
                                dashLength: 3,
                                dashGapLength: 1  ,
                                dashColor: Theme.of(context).primaryColor,
                              ),
                              Container(
                                height: 33,
                                width: 33, alignment: Alignment.center,
                                decoration: riderContainerDecoration,
                                child: Icon(Icons.location_on_sharp,color: Theme.of(context).primaryColor,),
                              ),
                            ],
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: RideAddressInfo(
                                    title: riderController.fromAddress.address,
                                    subTitle: 'Road 9/a,house-666,Dhaka',
                                    isInsideCity:true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: RideAddressInfo(
                                    title: riderController.toAddress.address,
                                    subTitle: 'Road 9/a,house-666,Dhaka',
                                    isInsideCity:true,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    Divider(color: Theme.of(context).primaryColor),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    Row(
                      children: [
                        Container(
                          height: 33, width: 33, alignment: Alignment.center,
                          decoration: riderContainerDecoration,
                          child: Icon(Icons.calendar_month,color: Theme.of(context).primaryColor),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('date'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  Text(
                                    riderController.tripDate ?? 'not set yet',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                                        color: riderController.tripDate != null ? Theme.of(context).textTheme.bodyMedium.color : Colors.red),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  riderController.setDate();
                                },
                                child: Image.asset(Images.edit, width: 16.0, height: 16.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    Row(
                      children: [
                        Container(
                          height: 33, width: 33, alignment: Alignment.center,
                          decoration: riderContainerDecoration,
                          child: Icon(Icons.calendar_month,color: Theme.of(context).primaryColor),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('time'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  Text(
                                    riderController.tripTime != null ? DateConverter.convertTimeToTime(riderController.tripTime) : 'not set yet',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                                        color: riderController.tripTime != null ? Theme.of(context).textTheme.bodyMedium.color : Colors.red),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  riderController.setTime(context);
                                },
                                child: Image.asset(Images.edit, width: 16.0, height: 16.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    ///service card
                    Row(
                      children: [
                        ServiceTypeCard(
                          rentType: 'hourly'.tr + '(hr)',
                          rentPrice: "45",
                          isSelected: riderController.carType == 0,
                          onTap: () => riderController.setCarType(0),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        ServiceTypeCard(
                          rentType: 'distance_wise'.tr + '(km)',
                          rentPrice: "35",
                          isSelected: riderController.carType == 1,
                          onTap: () => riderController.setCarType(1),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: CustomCheckBox(
                    title: 'return_same_location'.tr,
                    value: riderController.isReturnSameLocation,
                    onClick: (){
                      riderController.toggleIsReturnSameLocation(!riderController.isReturnSameLocation);
                    }),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: CustomButton(
                  buttonText: 'confirm_and_search_car'.tr,
                  onPressed: (){
                    if(riderController.tripDate == null || riderController.tripTime == null){
                      showCustomSnackBar('please_set_your_rent_date_and_time'.tr);
                    }else{
                      UserInformationBody _taxiBody = UserInformationBody(
                        from: riderController.fromAddress, to: riderController.toAddress,
                        fareCategory: riderController.carType == 0 ? 'hourly' : 'per_km',
                        distance: riderController.distance, filterType: 'top_rated',
                        rentTime: riderController.tripDate + ' ' + riderController.tripTime, duration: riderController.duration,
                      );
                      if(widget.vehicle == null) {
                        Get.toNamed(RouteHelper.getSelectCarScreenRoute(_taxiBody));
                      }else{
                        Get.toNamed(RouteHelper.getCarDetailsScreen(widget.vehicle, _taxiBody));
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
            ],
          ),

        );
      },
    );
  }
}
