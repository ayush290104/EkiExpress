import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/my_text_field.dart';

class TripCompletedConfirmationScreen extends StatelessWidget {
  const TripCompletedConfirmationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'trip_completed'.tr,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              Text('trip_completed'.tr,style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge,
                color: Theme.of(context).primaryColor,
              ),),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              Image.asset(Images.trip_completed_car,scale: 3,),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
              Text('your_trip_has_been_complete'.tr,textAlign: TextAlign.center,style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5),
                  fontSize: Dimensions.fontSizeDefault,
              ),),

              SizedBox(height: 40,),
              Text('how_was_your_service'.tr,style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColor),),
              SizedBox(height: 4),
              Text('give_us_your_valuable_review'.tr,style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5),
                  fontSize: Dimensions.fontSizeSmall),),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),

              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return InkWell(
                      child: Icon(
                        i != 0  ? Icons.star_border : Icons.star,
                        size: 30,
                        color:Theme.of(context).primaryColor,
                      ),
                      onTap: () {

                      },
                    );
                  },
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.1)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: MyTextField(
                  maxLines: 3,
                  capitalization: TextCapitalization.sentences,
                  isEnabled: true,
                  hintText: 'write_your_review_here'.tr,
                  fillColor: Theme.of(context).disabledColor.withOpacity(0.05),
                ),
              ),
              SizedBox(height: 50),

              CustomButton(
                  onPressed: (){
                    Get.toNamed(RouteHelper.getTripHistoryScreen());
                  },
                  buttonText: 'submit'.tr),
              TextButton(
                  onPressed: (){},
                  child: Text('not_now'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),))

            ],
          ),
        ),
      ),
    );
  }
}
