import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/car_selection_controller.dart';
import 'package:sixam_mart/data/model/body/user_information_body.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/paginated_list_view.dart';
import 'package:sixam_mart/view/screens/taxi_booking/widgets/trip_info_widget.dart';
import 'widgets/car_filter_widget.dart';
import 'widgets/rider_car_list.dart';

class SelectCarScreen extends StatefulWidget {
  final UserInformationBody filterBody;
  const SelectCarScreen({Key key, @required this.filterBody}) : super(key: key);

  @override
  State<SelectCarScreen> createState() => _SelectCarScreenState();
}

class _SelectCarScreenState extends State<SelectCarScreen> {
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    Get.find<CarSelectionController>().getBrandList();
    Get.find<CarSelectionController>().getVehiclesList(widget.filterBody, 1);

  }

  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:ResponsiveHelper.isDesktop(context) ? null : CustomAppBar(
        title: 'select_car'.tr,
      ),
      body: GetBuilder<CarSelectionController>(
        builder: (carSelectionController){
          print("isCarFilterActive");
          print(carSelectionController.isCarFilterActive);
          return ExpandableBottomSheet(
            background: GestureDetector(
              onTap: (){
                if(carSelectionController.isCarFilterActive){
                  carSelectionController.carFilter();
                }
              },
              child: Column(children: [
                Container(
                  color: Theme.of(context).canvasColor,
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      TripInfoWidget(filterBody: widget.filterBody),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('car_list'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
                          GestureDetector(
                            onTap: () => carSelectionController.carFilter(),
                            child: Container(
                              width: 27, height: 21,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Image.asset(Images.car_filter,scale: 2.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,)
                    ],
                  ),
                ),

                Expanded(
                  child: carSelectionController.vehicleModel != null ? carSelectionController.vehicleModel.vehicles.isNotEmpty ? RefreshIndicator(
                    onRefresh: () async => await carSelectionController.getVehiclesList(widget.filterBody, 1, isUpdate: true),
                    child: Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      decoration: BoxDecoration(color: Theme.of(context).cardColor),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: PaginatedListView(
                          offset: carSelectionController.vehicleModel != null ? carSelectionController.vehicleModel.offset : null,
                          onPaginate: (int offset) async => await carSelectionController.getVehiclesList(widget.filterBody, offset),
                          scrollController: scrollController,
                          totalSize: carSelectionController.vehicleModel != null ? carSelectionController.vehicleModel.totalSize : null,
                          itemView: RiderCarList(vehicleModel: carSelectionController.vehicleModel, filterBody: widget.filterBody),
                        ),
                      ),
                    ),
                  ) : Center(child: Text('no_vehicle_available'.tr)) : Center(child: CircularProgressIndicator()),
                )

              ]),
            ),
            persistentContentHeight: 500,
            expandableContent:CarFilterWidget(),
            persistentFooter: carSelectionController.isCarFilterActive? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: kElevationToShadow[4],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CustomButton(
                    buttonText: 'apply_filter'.tr,
                    onPressed: () {
                      print("tapped");
                      UserInformationBody filterBody = UserInformationBody(
                        from: widget.filterBody.from, to: widget.filterBody.to, fareCategory: widget.filterBody.fareCategory, distance: widget.filterBody.distance,
                        minPrice: carSelectionController.startingPrice, maxPrice: carSelectionController.endingPrice,
                        brandModelId: carSelectionController.brandModels[carSelectionController.selectedBrand].id,
                        filterType: carSelectionController.sortByIndex==0 ? 'top_rated' : 'km/h',
                      );
                      carSelectionController.carFilter();
                      Get.find<CarSelectionController>().getVehiclesList(filterBody, 1);
                    },
                  ),
                ),
              ),
            ):SizedBox(),

          );
        },
      ),
    );
  }
}