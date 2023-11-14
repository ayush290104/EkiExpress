import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/banner_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/rider_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/screens/home/web/module_widget.dart';
import 'package:sixam_mart/view/screens/taxi_booking/home/widgets/rider_app_bar.dart';
import 'package:sixam_mart/view/screens/taxi_booking/home/widgets/taxi_banner_view.dart';
import 'widgets/add_address_widget.dart';
import 'widgets/top_rated_cars_widget.dart';
import 'widgets/use_coupon_section.dart';

class RiderHomeScreen extends StatefulWidget {
  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {

  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }
    Get.find<RiderController>().getTopRatedVehiclesList(1);
    Get.find<BannerController>().getTaxiBannerList(false);
    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RiderAppBar(),
      body: GetBuilder<LocationController>(builder: (locationController) {
        return Stack(clipBehavior: Clip.none, children: [

          RefreshIndicator(
            onRefresh: ()async {
              await Get.find<BannerController>().getTaxiBannerList(false);
              await Get.find<RiderController>().getTopRatedVehiclesList(1, isUpdate: true);
            },
            child: SingleChildScrollView(
              padding: ResponsiveHelper.isDesktop(context) ? null : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: FooterView(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                TaxiBannerView(),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Container(
                  height: 50, width: Dimensions.WEB_MAX_WIDTH,
                  color: Theme.of(context).colorScheme.background,
                  child: InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getSelectRideMapLocationRoute("initial", null, null)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.5)),
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      ),
                      child: Row(children: [
                        Image.asset(Images.rider_search,scale: 3,),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Expanded(child: Text(
                          'where_to_go'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                          ),
                        )),
                      ]),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                _isLoggedIn ? AddAddressWidget(isLogin: _isLoggedIn) : SizedBox(),

                _isLoggedIn ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('saved_address'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  locationController.addressList != null && locationController.addressList.length > 0 ? GridView.builder(
                    controller: ScrollController(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                      childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/0.25) : (1/0.205),
                      crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    itemCount: locationController.addressList.length > 3 ? 3 : locationController.addressList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Get.toNamed(RouteHelper.getSelectRideMapLocationRoute("initial", locationController.addressList[index], null));
                        },
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          ),
                          child: Row(children: [

                            Container(
                              height: 33, width: 32, alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
                                  color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.rectangle),
                              child: Image.asset(
                                locationController.addressList[index].addressType == 'others' ? Images.address_journey :
                                locationController.addressList[index].addressType == 'home' ? Images.address_home:
                                Images.address_office,
                                height: 13,
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(locationController.addressList[index].addressType, style: robotoMedium),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(
                                locationController.addressList[index].address, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5),
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                            ])),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                            Icon(
                              Icons.arrow_forward,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),

                          ]),
                        ),
                      );
                    },
                  ) : SizedBox(),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('trip_history'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      InkWell(
                        onTap: (){},
                        child: Text('view_all'.tr, style: robotoBold.copyWith(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  ///Trip history..
                  GridView.builder(
                    controller: ScrollController(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                      childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/0.25) : (1/0.205),
                      crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    itemCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          ),
                          child: Row(children: [

                            Container(
                              height: 55, width: 55, alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
                                  color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.rectangle),
                              child: CustomImage(
                                image:  '',
                                height: 30, width: 30,
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('Dhanmondi to Mirpur DOHS ', style: robotoMedium),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(
                                '\$144', maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(.5),
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                            ])),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                            Text('16th \n August',style: robotoRegular,),

                          ]),
                        ),
                      );
                    },
                  ),

                ]) : SizedBox(),


                TopRatedCars(),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                UseCouponSection(),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

              ]))),
            ),
          ),

          ResponsiveHelper.isDesktop(context) ? Positioned(top: 150, right: 0, child: ModuleWidget()) : SizedBox(),

        ]);
      }),
    );
  }
}

class ParcelShimmer extends StatelessWidget {
  final bool isEnabled;
  ParcelShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
        childAspectRatio: (1/(ResponsiveHelper.isMobile(context) ? 0.20 : 0.20)),
        crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
      ),
      itemCount: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: isEnabled,
            child: Row(children: [

              Container(
                height: 50, width: 50, alignment: Alignment.center,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(height: 15, width: 200, color: Colors.grey[300]),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Container(height: 15, width: 100, color: Colors.grey[300]),
              ])),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Icon(Icons.keyboard_arrow_right),

            ]),
          ),
        );
      },
    );
  }
}

