import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';

class RiderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  RiderRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.getData('${AppConstants.PLACE_DETAILS_URI}?placeid=$placeID');
  }

  Future<Response> getRouteBetweenCoordinates(LatLng origin, LatLng destination) async {
    return await apiClient.getData('${AppConstants.DIRECTION_URI}'
        '?origin_lat=${origin.latitude}&origin_lng=${origin.longitude}'
        '&destination_lat=${destination.latitude}&destination_lng=${destination.longitude}');
  }

  Future<Response> getTopRatedVehiclesList(int offset) async {
    return await apiClient.getData('${AppConstants.TOP_RATED_VEHICLES_LIST}?offset=$offset&limit=10');
  }

  Future<Response> placeTrip(Map<String, String> data) async {
    return await apiClient.postData(AppConstants.TRIP_PLACE_URI, data);
  }

  Future<Response> getRunningTripList(int offset) async {
    return await apiClient.getData('${AppConstants.RUNNING_TRIP_URI}?offset=$offset&limit=10');
  }

}