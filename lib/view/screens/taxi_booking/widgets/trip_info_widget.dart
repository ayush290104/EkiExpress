import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/data/model/body/user_information_body.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/taxi_booking/select_map_location/widgets/dotted_line.dart';
class TripInfoWidget extends StatelessWidget {
  final UserInformationBody filterBody;
  const TripInfoWidget({Key key, @required this.filterBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('trip_info'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
      ///pick up and destination address
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300], blurRadius: 5, spreadRadius: 1,)],
          borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                ),
                              ),
                              Container(
                                height: 4,
                                width: 4,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                              ),
                            ],
                          ),
                          DottedLine(
                            lineLength: 12,
                            direction: Axis.vertical,
                            dashLength: 3,
                            dashGapLength: 1  ,
                            dashColor: Theme.of(context).primaryColor,
                          ),
                          Icon(Icons.location_on_outlined,color: Theme.of(context).primaryColor,),
                        ],
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${filterBody.from.address}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.7)
                              ),),
                            SizedBox(height: 18),
                            Text("${filterBody.to.address}",
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text('see_details'.tr,style: robotoMedium.copyWith(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
