import 'package:sixam_mart/data/model/response/address_model.dart';

class UserInformationBody{
  AddressModel from;
  AddressModel to;
  String fareCategory;
  double distance;
  double duration;
  String filterType;
  double minPrice;
  double maxPrice;
  int brandModelId;
  String rentTime;

  UserInformationBody({this.from, this.to, this.fareCategory, this.distance, this.duration, this.filterType, this.minPrice, this.maxPrice, this.brandModelId, this.rentTime});

  UserInformationBody.fromJson(Map<String, dynamic> json) {
    from = json['from'] != null ? new AddressModel.fromJson(json['from']) : null;
    to = json['to'] != null ? new AddressModel.fromJson(json['to']) : null;
    fareCategory = json['fare_category'];
    distance = json['distance'].toDouble();
    duration = json['duration'].toDouble();
    filterType = json['filter_type'];
    minPrice = json['filter_min_price'];
    maxPrice = json['filter_max_price'];
    brandModelId = json['filter_brand'];
    rentTime = json['rent_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.from != null) {
      data['from'] = this.from.toJson();
    }
    if (this.to != null) {
      data['to'] = this.to.toJson();
    }
    data['fare_category'] = this.fareCategory;
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    data['filter_type'] = this.filterType;
    data['filter_min_price'] = this.minPrice;
    data['filter_max_price'] = this.maxPrice;
    data['filter_brand'] = this.brandModelId;
    data['rent_time'] = this.rentTime;
    return data;
  }
}