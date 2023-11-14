import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/cancellation_dialog.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/ripple_button.dart';
import 'package:sixam_mart/view/screens/taxi_booking/select_map_location/widgets/dotted_line.dart';
import 'package:sixam_mart/view/screens/taxi_booking/select_map_location/widgets/pick_and_destination_address_info.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({Key key}) : super(key: key);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'order'.tr,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Column(
            children: [
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
              InkWell(
                  onTap: (){
                    print("tapped_inside_complete_screen");
                    Get.toNamed(RouteHelper.getTripHistoryScreen());
                  },
                  child: Image.asset(Images.booking_complete_car,width: 109,height: 83,)),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              Container(
                width: Get.width * .6,
                child: RichText(text: TextSpan(
                    children: [
                      TextSpan(
                          text: ' ${'10 - 5 '}',
                          style: robotoMedium.copyWith(
                              fontSize:Dimensions.PADDING_SIZE_DEFAULT,
                              color: Theme.of(context).primaryColor)),
                      TextSpan(
                          text: 'min_left_to_reach'.tr,
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5))
                      ),]),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Theme.of(context).primaryColor.withOpacity(.1),
                    ),
                    child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                        vertical: Dimensions.PADDING_SIZE_SMALL),
                      child: Text(
                        'track_on_map'.tr,
                        style: robotoRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.fontSizeSmall),),
                  ),),
                  Positioned.fill(child: RippleButton(onTap: () {
                    Get.toNamed(RouteHelper.getSelectRideMapLocationRoute('willArrived', null, null));
                  }, radius: Dimensions.RADIUS_DEFAULT))
                ],
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300], blurRadius: 5, spreadRadius: 1,)],),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:BorderRadius.all(Radius.circular(8)),
                        child: Image.asset(
                          Images.demo_car,
                          width: 120,
                          fit: BoxFit.fitHeight,
                          height: 120,),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Range Rover-2020',style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                          Row(
                            children: [
                              Image.asset(Images.demo_brand_car),
                              Text("ABC rent a car",style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),)
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'car_number'.tr,
                                style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),),
                              Text('B 45 55 23',style:  robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),),
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                          Text(
                            'contact_with_provider'.tr,
                            style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, ),),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Image.asset(Images.rider_call_icon,scale: 2.2,),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                                  Text(
                                    'call_now'.tr,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                      decoration: TextDecoration.underline,
                                  ),)
                                ],
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                              Row(
                                children: [
                                  Image.asset(Images.rider_chat_icon,scale: 2.2,),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                                  Text(
                                    'chat_now'.tr,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                      decoration: TextDecoration.underline,
                                  ),)
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300], blurRadius: 5, spreadRadius: 1,)],),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tuesday, 16 Auust 2022, 10.45 am',style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),),
                          Image.asset(
                            Images.edit,
                            width: 16,
                            height: 16,),
                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                      Container(
                        height: 90,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 33,
                                  width: 33,
                                  alignment: Alignment.center,
                                  decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.08)),
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        height: 18,
                                        width: 18,
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
                                            borderRadius: BorderRadius.all(Radius.circular(20))),
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
                                  decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.08)),
                                  child: Icon(Icons.location_on_sharp,color: Theme.of(context).primaryColor,),
                                ),
                              ],
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: RideAddressInfo(
                                    title: "Mirpur DOHS",
                                    subTitle: 'Road 9/a,house-666,Dhaka',
                                    isInsideCity:true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: RideAddressInfo(
                                    title: "Mirpur DOHS",
                                    subTitle: 'Road 9/a,house-666,Dhaka',
                                    isInsideCity:true,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                      Row(
                        children: [
                          Container(
                            height: 33,
                            width: 33, alignment: Alignment.center,
                            decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.08)),
                            child: Image.asset(Images.hour_cost,width: 20,height: 20,),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('rent_type'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,),),
                              Text('hourly'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                      Row(
                        children: [
                          Container(
                            height: 33,
                            width: 33, alignment: Alignment.center,
                            decoration: riderContainerDecoration.copyWith(color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.08)),
                            child: Image.asset(Images.ride_return,width: 20,height: 20,),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('return'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,),),
                              Text('N/A'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
              Stack(
                children: [
                  Container(
                    child: Center(child: Text('cancel_booking'.tr,style: robotoRegular.copyWith(color: Theme.of(context).cardColor),)),
                    width: 175,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Theme.of(context).colorScheme.error.withOpacity(.5),
                    ),
                  ),
                  Positioned.fill(child: RippleButton(onTap: () {
                    Get.dialog(CancellationDialog(
                      icon: Images.cancellation_icon,
                      title: 'do_you_want_to_cancel_this_booking'.tr,
                      onYesPressed: (){
                      },
                      onNoPressed: (){
                        Get.back();
                      },
                    ));
                  }))
                ],
              ),
              SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
