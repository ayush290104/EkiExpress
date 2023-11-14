import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/place_details_model.dart';
import 'package:sixam_mart/data/model/response/rider_model.dart';
import 'package:sixam_mart/data/model/response/trip_model.dart';
import 'package:sixam_mart/data/model/response/vehicle_model.dart';
import 'package:sixam_mart/data/model/response/zone_response_model.dart';
import 'package:sixam_mart/data/repository/rider_repo.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/rider_type.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';

class RiderController extends GetxController implements GetxService {
  final RiderRepo riderRepo;
  RiderController({@required this.riderRepo});

  LatLng _initialPosition = LatLng(
    double.parse(Get.find<SplashController>().configModel.defaultLocation.lat ?? '0'),
    double.parse(Get.find<SplashController>().configModel.defaultLocation.lng ?? '0'),
  );

  GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> _polyLines = {};
  RiderType _rideStatus;
  AddressModel _fromAddress;
  AddressModel _toAddress;
  bool _isLoading = false;
  double _carDistance;
  RiderModel _assignedRider;
  double _carTime;
  int _riderRating = 0;
  bool _isReturnSameLocation = false;
  String _tripDate;
  String _tripTime;
  int _carType = 0;
  double _distance = -1;
  double _duration = -1;

  List<String> banners = [Images.banner1, Images.banner2];
  int _activeBanner = 0;
  VehicleModel _topRatedVehicleModel;
  TripModel _runningTrip;

  MarkerId _myMarkerId = MarkerId('my_marker');
  MarkerId _fromMarkerId = MarkerId('from_marker');
  MarkerId _toMarkerId = MarkerId('to_marker');


  LatLng get initialPosition => _initialPosition;
  GoogleMapController get mapController => _mapController;
  Map<MarkerId, Marker> get markers => _markers;
  Map<PolylineId, Polyline> get polyLines => _polyLines;
  RiderType get rideStatus => _rideStatus;
  AddressModel get fromAddress => _fromAddress;
  AddressModel get toAddress => _toAddress;
  bool get isLoading => _isLoading;
  double get carDistance => _carDistance;
  RiderModel get assignedRider => _assignedRider;
  double get carTime => _carTime;
  int get riderRating => _riderRating;
  bool get isReturnSameLocation => _isReturnSameLocation;
  int get activeBanner => _activeBanner;
  String get tripDate => _tripDate;
  String get tripTime => _tripTime;
  int get carType => _carType;
  double get distance => _distance;
  double get duration => _duration;
  VehicleModel get topRatedVehicleModel => _topRatedVehicleModel;
  TripModel get runningTrip => _runningTrip;

  void initSetup(){
    _tripDate = null;
    _tripTime = null;
  }

  void setCarType(int index) {
    _carType = index;
    update();
  }

  Future<void> setDate() async {
    DateTime pickedDate = await showDatePicker(
        context: Get.context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101)
    );

    if(pickedDate != null ){
      print(pickedDate);
      _tripDate = DateConverter.dateToDate(pickedDate);
    }else{
      print("Date is not selected");
    }
    update();
  }

  Future<void> setTime(BuildContext context) async {
    TimeOfDay _time = await showTimePicker(
      context: context, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: Get.find<SplashController>().configModel.timeformat == '24',
          ),
          child: child,
        );
      },
    );
    if(_time != null) {
      _tripTime = DateConverter.convertTimeToTimeDate(DateTime(DateTime.now().year, 1, 1, _time.hour, _time.minute));
    }
    update();
  }

  void changeBanner(int index){
    _activeBanner = index;
    update();
  }

  void initializeData(String riderType, AddressModel address) {
    print("riderType_initializeData:$riderType");
    _fromAddress = address ?? Get.find<LocationController>().getUserAddress();
    _toAddress = null;
    _markers = {};
    _polyLines = {};
    _rideStatus = RiderType.values.where((element) => element.name == riderType).first;
    _assignedRider = null;
    _carDistance = -1;
    _carTime = -1;
    _isLoading = false;
    _riderRating = 0;
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  Future<void> getRunningTripList(int offset, {bool isUpdate = false}) async{
    if(offset == 1) {
      _runningTrip = null;
      if(isUpdate) {
        update();
      }
    }
    Response response = await riderRepo.getRunningTripList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _runningTrip = TripModel.fromJson(response.body);
      }else {
        _runningTrip = TripModel.fromJson(response.body);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getTopRatedVehiclesList(int offset, {bool isUpdate = false}) async{
    if(offset == 1) {
      _topRatedVehicleModel = null;
      if(isUpdate) {
        update();
      }
    }
    Response response = await riderRepo.getTopRatedVehiclesList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _topRatedVehicleModel = VehicleModel.fromJson(response.body);
      }else {
        _topRatedVehicleModel = VehicleModel.fromJson(response.body);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<Position> getInitialLocation(AddressModel address) async {
    Position _position;
    try {
      if(address == null){
        await Geolocator.requestPermission();
        _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        _initialPosition = LatLng(_position.latitude, _position.longitude);
      }else{
        _initialPosition = LatLng(double.parse(address.latitude), double.parse(address.longitude));
      }
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, 16));
      // _markers[_fromMarkerId] = Marker(markerId: _fromMarkerId, visible: false, position: _initialPosition);
      final Uint8List _liveMarkerIcon = await Get.find<RiderController>().getBytesFromAsset(Images.live_marker, 70);
      Marker _marker = Marker(
        markerId: _myMarkerId,
        position: _initialPosition,
        icon: BitmapDescriptor.fromBytes(_liveMarkerIcon),
      );
      _markers[_myMarkerId] = _marker;
      update();
    }catch(e){}
    return _position;
  }

  void clearRideData() {
    _markers.clear();
    _polyLines.clear();
  }

  void setRideStatus(RiderType rideStatus,{bool shouldUpdate = true}) {
    _rideStatus = rideStatus;
    if(shouldUpdate){
      update();
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void toggleIsReturnSameLocation(bool value){
    _isReturnSameLocation = value;
    update();
  }

  void setLocationFromPlace(String placeID, String address, bool isFrom) async {
    Response response = await riderRepo.getPlaceDetails(placeID);
    if(response.statusCode == 200) {
      PlaceDetailsModel _placeDetails = PlaceDetailsModel.fromJson(response.body);
      if(_placeDetails.status == 'OK') {
        AddressModel _address = AddressModel(
          address: address, addressType: 'others', latitude: _placeDetails.result.geometry.location.lat.toString(),
          longitude: _placeDetails.result.geometry.location.lng.toString(),
          contactPersonName: Get.find<LocationController>().getUserAddress().contactPersonName,
          contactPersonNumber: Get.find<LocationController>().getUserAddress().contactPersonNumber,
        );
        ZoneResponseModel _response = await Get.find<LocationController>().getZone(_address.latitude, _address.longitude, false);
        if (_response.isSuccess) {
          if(Get.find<LocationController>().getUserAddress().zoneIds.contains(_response.zoneIds[0])) {
            _address.zoneId =  _response.zoneIds[0];
            _address.zoneIds = [];
            _address.zoneIds.addAll(_response.zoneIds);
            _address.zoneData = [];
            _address.zoneData.addAll(_response.zoneData);
            if(isFrom) {
              setFromAddress(_address);
            }else {
              setToAddress(_address);
            }
          }else {
            showCustomSnackBar('your_selected_location_is_from_different_zone_store'.tr);
          }
        } else {
          showCustomSnackBar(_response.message);
        }
      }
    }
    update();
  }

  Future<void> setFromAddress(AddressModel addressModel) async {
    _fromAddress = addressModel;
    LatLng _from = LatLng(double.parse(_fromAddress.latitude), double.parse(_fromAddress.longitude));
    _markers[_myMarkerId] = Marker(markerId: _myMarkerId, visible: false, position: _from);

    final Uint8List _fromMarkerIcon = await getBytesFromAsset(Images.live_marker, 70);
    Marker _fromMarker = Marker(
      markerId: _fromMarkerId, position: _from, visible: true,
      icon: BitmapDescriptor.fromBytes(_fromMarkerIcon),
    );
    _markers[_fromMarkerId] = _fromMarker;
    update();
  }

  Future<void> setToAddress(AddressModel addressModel) async {
    _toAddress = addressModel;
    setFromToMarker(
      from: LatLng(double.parse(_fromAddress.latitude), double.parse(_fromAddress.longitude)),
      to: LatLng(double.parse(_toAddress.latitude), double.parse(_toAddress.longitude)),
    );
    update();
  }

  void setFromToMarker({@required LatLng from, @required LatLng to}) async {
    _markers[_myMarkerId] = Marker(markerId: _myMarkerId, visible: false, position: from);
    final Uint8List _fromMarkerIcon = await getBytesFromAsset(Images.live_marker, 70);
    final Uint8List _toMarkerIcon = await getBytesFromAsset(Images.to_marker, 70);

    Marker _fromMarker = Marker(
      markerId: _fromMarkerId, position: from, visible: true,
      icon: BitmapDescriptor.fromBytes(_fromMarkerIcon),
    );
    _markers[_fromMarkerId] = _fromMarker;
    Marker _toMarker = Marker(
      markerId: _toMarkerId, position: to,
      icon: BitmapDescriptor.fromBytes(_toMarkerIcon),
    );
    _markers[_toMarkerId] = _toMarker;
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(boundsFromLatLngList([from, to]), 100));

    generatePolyLines(from: from, to: to);
    _distance = await Get.find<OrderController>().getDistanceInKM(from, to);
    _duration = await Get.find<OrderController>().getDistanceInKM(from, to, isDuration: true);
    print('--------------distance------ : $_distance');
    print('--------------duration------ : $_duration');
    update();
  }

  Future<List<LatLng>> generatePolyLines({@required LatLng from, @required LatLng to}) async {
    List<LatLng> _polylineCoordinates = [];
    List<LatLng> _results = await getRouteBetweenCoordinates(from, to);
    if (_results.isNotEmpty) {
      _polylineCoordinates.addAll(_results);
    } else {
      showCustomSnackBar('route_not_found'.tr);
    }
    PolylineId _polyId = PolylineId('my_polyline');
    Polyline _polyline = Polyline(
      polylineId: _polyId,
      points: _polylineCoordinates,
      width: 5,
      color: Theme.of(Get.context).primaryColor,
    );
    _polyLines[_polyId] = _polyline;
    update();
    return _polylineCoordinates;
  }

  Future<List<LatLng>> getRouteBetweenCoordinates(LatLng origin, LatLng destination) async {
    List<LatLng> _coordinates = [];
    Response response = await riderRepo.getRouteBetweenCoordinates(origin, destination);
    if (response.body["status"]?.toLowerCase() == 'ok' && response.body["routes"] != null && response.body["routes"].isNotEmpty) {
      _coordinates.addAll(decodeEncodedPolyline(response.body["routes"][0]["overview_polyline"]["points"]));
    }
    return _coordinates;
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = new LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > (x1 ?? 0)) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > (y1 ?? 0)) y1 = latLng.longitude;
        if (latLng.longitude < (y0 ?? 0)) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }
}