import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/rider_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class CarWillArrivedInfo extends StatelessWidget {
  const CarWillArrivedInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderController>(
      builder: (riderController){
        return InkWell(
          onTap: (){
            Get.toNamed(RouteHelper.getTripCompletedConfirmationScreen());
          },
          child: Container(
            height: 310,
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
                      Text('the_car_will_arrived_within'.tr,style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5),
                      ),),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

                      Text("15 - 20 mins",style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge,
                        color: Theme.of(context).textTheme.bodyLarge.color,
                      ),),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Images.pick_and_destination,scale: 2.5,),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                          Text("2.2 km away",style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),)
                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                      Divider(color: Theme.of(context).textTheme.bodyLarge.color,),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('car_driver'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_SMALL),)),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //driver section
                          Row(
                            children: [
                              Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Image.asset(Images.driver_icon,scale: 2,)),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Alex Maxwell",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                  Row(
                                    children: [
                                      Icon(Icons.star,size: 18.0,color: Theme.of(context).primaryColor,),
                                      Text("4.5"),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Image.asset(Images.rider_chat_icon,scale: 2.2,),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                                  Text('chat'.tr,style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                    decoration: TextDecoration.underline,
                                  ),)
                                ],
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                              Row(
                                children: [
                                  Image.asset(Images.rider_call_icon,scale: 2.2,),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                                  Text('call'.tr,style: robotoRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeSmall,
                                    decoration: TextDecoration.underline,
                                  ),)
                                ],
                              ),


                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //driver section
                          Row(
                            children: [
                              Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],

                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Image.asset(Images.tracking_car_icon,scale: 2,)),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                              Text("RAnge Rover-2020",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                            ],
                          ),
                          Row(
                            children: [
                              Text('car_no'.tr,style: robotoRegular.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeSmall
                              ),),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                              Text('B 45 55 23'.tr,style: robotoMedium.copyWith(
                                  color: Theme.of(context).textTheme.bodyLarge.color,
                                  fontSize: Dimensions.fontSizeSmall
                              ),),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                    ],
                  ),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
              ],
            ),

          ),
        );
      },
    );
  }
}
