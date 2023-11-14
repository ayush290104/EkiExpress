import 'dart:async';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/rider_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/vehicle_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/rider_type.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/screens/location/widget/location_search_dialog.dart';
import 'widgets/address_input_widget.dart';
import 'widgets/available_service_info.dart';
import 'widgets/car_will_arrived_info.dart';

class SelectMapLocation extends StatefulWidget {
  final String riderType;
  final AddressModel address;
  final Vehicles vehicle;
  const SelectMapLocation({Key key,@required this.riderType, @required this.address, this.vehicle}) : super(key: key);

  @override
  State<SelectMapLocation> createState() => _SelectMapLocationState();
}

class _SelectMapLocationState extends State<SelectMapLocation> {
  @override
  void initState() {
    super.initState();

    print('-------rider type : ${widget.riderType}/ ${widget.address}');

    Get.find<RiderController>().initializeData(widget.riderType, widget.address);
    Get.find<RiderController>().getInitialLocation(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:ResponsiveHelper.isDesktop(context) ? null : CustomAppBar(title: 'location'.tr),
      body: GetBuilder<RiderController>(
        builder: (riderController){
          Completer<GoogleMapController> _mapCompleter = Completer<GoogleMapController>();
          if(riderController.mapController != null){
            _mapCompleter.complete(riderController.mapController);
          }
          return ExpandableBottomSheet(
              background: Stack(
                children: [
                  Animarker(
                    curve: Curves.easeIn,
                    rippleRadius: 0.2,
                    useRotation: true,
                    duration: Duration(milliseconds: 2300),
                    mapId: _mapCompleter.future.then<int>((value) => value.mapId),
                    markers: riderController.markers.values.toSet(),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: riderController.initialPosition,zoom: 15),
                      onMapCreated: (controller) {
                        riderController.setMapController(controller);
                        riderController.getInitialLocation(widget.address);
                      },
                      polylines: Set<Polyline>.of(riderController.polyLines.values ?? []),
                    ),
                  ),


                  (riderController.rideStatus == RiderType.initial) ?
                  Positioned(
                    right: 10, bottom: 120,
                    child: Column(
                      children: [
                        Container(
                          height: 30, width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Theme.of(context).cardColor,
                          ),
                          child: InkWell(
                            onTap: () => riderController.mapController.animateCamera(CameraUpdate.zoomIn()),
                            child: Icon(Icons.add, size: 20,color: Theme.of(context).primaryColor,),
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                        Container(
                          height: 30, width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Theme.of(context).cardColor,
                          ),
                          child: InkWell(
                            onTap: () => riderController.mapController.animateCamera(CameraUpdate.zoomOut()),
                            child: Icon(Icons.remove, size: 20,color:Theme.of(context).primaryColor),
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        InkWell(
                          onTap: () => riderController.getInitialLocation(null),
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withOpacity(0.5), blurRadius: 10, offset: Offset(0, 5))],
                            ),
                            child: Icon(Icons.my_location, size: 28, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  SizedBox(),

                  Positioned(
                    top: Dimensions.PADDING_SIZE_SMALL,
                    left: Dimensions.PADDING_SIZE_LARGE,
                    right: Dimensions.PADDING_SIZE_LARGE,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      riderController.rideStatus == RiderType.initial ?
                      Column(mainAxisSize: MainAxisSize.min, children: [

                        AddressInputWidget(
                          logo: Images.live_marker, title: 'from'.tr, address: riderController.fromAddress.address,
                          onTap: () async {
                            await Get.dialog(LocationSearchDialog(mapController: null, isPickedUp: null, isRider: true, isFrom: true));
                          },
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        AddressInputWidget(
                          title: 'to'.tr, address: riderController.toAddress != null ? riderController.toAddress.address : '',
                          onTap: () async {
                            if(Get.find<AuthController>().isLoggedIn()){
                              await Get.dialog(LocationSearchDialog(mapController: null, isPickedUp: null, isRider: true, isFrom: false));
                            }else{
                              showCustomSnackBar('please_login_first'.tr);
                            }
                          },
                        ),
                      ]) :
                      SizedBox(),

                    ]),
                  ),
                ],
              ),
            persistentContentHeight: 310,
            expandableContent: expandableContent(riderController.rideStatus, riderController, widget.vehicle),
          );
        },
      ),
    );
  }


  Widget expandableContent(RiderType riderType, RiderController riderController, Vehicles vehicle){
    print("===----- rider type name : ${riderType.name}");
    switch (riderType) {
      case RiderType.availableCar:
        return AvailableServiceInfo(vehicle: vehicle);
        break;
      case RiderType.willArrived:
        return CarWillArrivedInfo();
        break;

      default:
        return Container(
          height: 85,
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onPressed: riderController.toAddress == null ? null : (){
                riderController.setRideStatus(RiderType.availableCar);
              },
              buttonText: 'confirm'.tr,
            ),
          ),
        );

    }
  }
}
