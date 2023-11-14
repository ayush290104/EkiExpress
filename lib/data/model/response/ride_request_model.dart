class PaginatedRideModel {
  int totalSize;
  String limit;
  int offset;
  List<RideRequestModel> rides;

  PaginatedRideModel({this.totalSize, this.limit, this.offset, this.rides});

  PaginatedRideModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['data'] != null) {
      rides = [];
      json['data'].forEach((v) {
        rides.add(new RideRequestModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.rides != null) {
      data['data'] = this.rides.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class RideRequestModel {
  int id;
  String rideCategory;
  String zone;
  String rideStatus;
  PickupPoint pickupPoint;
  String pickupAddress;
  String pickupTime;
  PickupPoint dropoffPoint;
  String dropoffAddress;
  String dropoffTime;
  double estimatedTime;
  double estimatedFare;
  double estimatedDistance;
  double actualTime;
  double actualFare;
  double actualDistance;
  double totalFare;
  double tax;
  String customerName;
  String customerImage;
  String otp;
  Rider rider;
  String createdAt;
  String updatedAt;

  RideRequestModel(
      {this.id,
        this.rideCategory,
        this.zone,
        this.rideStatus,
        this.pickupPoint,
        this.pickupAddress,
        this.pickupTime,
        this.dropoffPoint,
        this.dropoffAddress,
        this.dropoffTime,
        this.estimatedTime,
        this.estimatedFare,
        this.estimatedDistance,
        this.actualTime,
        this.actualFare,
        this.actualDistance,
        this.totalFare,
        this.tax,
        this.customerName,
        this.customerImage,
        this.otp,
        this.rider,
        this.createdAt,
        this.updatedAt,
      });

  RideRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rideCategory = json['ride_category'];
    zone = json['zone'];
    rideStatus = json['ride_status'];
    pickupPoint = json['pickup_point'] != null ? new PickupPoint.fromJson(json['pickup_point']) : null;
    pickupAddress = json['pickup_address'];
    pickupTime = json['pickup_time'];
    dropoffPoint = json['dropoff_point'] != null ? new PickupPoint.fromJson(json['dropoff_point']) : null;
    dropoffAddress = json['dropoff_address'];
    dropoffTime = json['dropoff_time'];
    estimatedTime = json['estimated_time'].toDouble();
    estimatedFare = json['estimated_fare'].toDouble();
    estimatedDistance = json['estimated_distance'].toDouble();
    actualTime = json['actual_time'] != null ? json['actual_time'].toDouble() : null;
    actualFare = json['actual_fare'] != null ? json['actual_fare'].toDouble() : null;
    actualDistance = json['actual_distance'] != null ? json['actual_distance'].toDouble() : null;
    totalFare = json['total_fare'] != null ? json['total_fare'].toDouble() : null;
    tax = json['tax'].toDouble();
    customerName = json['customer_name'];
    customerImage = json['customer_image'];
    otp = json['otp'].toString();
    rider = json['rider'] != null ? new Rider.fromJson(json['rider']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ride_category'] = this.rideCategory;
    data['zone'] = this.zone;
    data['ride_status'] = this.rideStatus;
    if (this.pickupPoint != null) {
      data['pickup_point'] = this.pickupPoint.toJson();
    }
    data['pickup_address'] = this.pickupAddress;
    data['pickup_time'] = this.pickupTime;
    if (this.dropoffPoint != null) {
      data['dropoff_point'] = this.dropoffPoint.toJson();
    }
    data['dropoff_address'] = this.dropoffAddress;
    data['dropoff_time'] = this.dropoffTime;
    data['estimated_time'] = this.estimatedTime;
    data['estimated_fare'] = this.estimatedFare;
    data['estimated_distance'] = this.estimatedDistance;
    data['actual_time'] = this.actualTime;
    data['actual_fare'] = this.actualFare;
    data['actual_distance'] = this.actualDistance;
    data['total_fare'] = this.totalFare;
    data['tax'] = this.tax;
    data['customer_name'] = this.customerName;
    data['customer_image'] = this.customerImage;
    data['otp'] = this.otp;
    if (this.rider != null) {
      data['rider'] = this.rider.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PickupPoint {
  String type;
  List<double> coordinates;

  PickupPoint({this.type, this.coordinates});

  PickupPoint.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Rider {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String identityNumber;
  String identityType;
  String identityImage;
  String image;
  String fcmToken;
  int zoneId;
  String createdAt;
  String updatedAt;
  bool status;
  int active;
  int earning;
  int currentOrders;
  String type;
  int storeId;
  String applicationStatus;
  int orderCount;
  int assignedOrderCount;
  int delivery;
  int rideSharing;
  String vehicleRegNo;
  String vehicleRc;
  String vehicleOwnerNoc;
  int rideZoneId;
  int rideCategoryId;
  double avgRating;
  int ratingCount;
  String lat;
  String lng;
  String location;

  Rider(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.identityNumber,
        this.identityType,
        this.identityImage,
        this.image,
        this.fcmToken,
        this.zoneId,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.active,
        this.earning,
        this.currentOrders,
        this.type,
        this.storeId,
        this.applicationStatus,
        this.orderCount,
        this.assignedOrderCount,
        this.delivery,
        this.rideSharing,
        this.vehicleRegNo,
        this.vehicleRc,
        this.vehicleOwnerNoc,
        this.rideZoneId,
        this.rideCategoryId,
        this.avgRating,
        this.ratingCount,
        this.lat,
        this.lng,
        this.location});

  Rider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    identityNumber = json['identity_number'];
    identityType = json['identity_type'];
    identityImage = json['identity_image'];
    image = json['image'];
    fcmToken = json['fcm_token'];
    zoneId = json['zone_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    active = json['active'];
    earning = json['earning'];
    currentOrders = json['current_orders'];
    type = json['type'];
    storeId = json['store_id'];
    applicationStatus = json['application_status'];
    orderCount = json['order_count'];
    assignedOrderCount = json['assigned_order_count'];
    delivery = json['delivery'];
    rideSharing = json['ride_sharing'];
    vehicleRegNo = json['vehicle_reg_no'];
    vehicleRc = json['vehicle_rc'];
    vehicleOwnerNoc = json['vehicle_owner_noc'];
    rideZoneId = json['ride_zone_id'];
    rideCategoryId = json['ride_category_id'];
    avgRating = json['avg_rating'] != null ? json['avg_rating'].toDouble() : null;
    ratingCount = json['rating_count'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['identity_number'] = this.identityNumber;
    data['identity_type'] = this.identityType;
    data['identity_image'] = this.identityImage;
    data['image'] = this.image;
    data['fcm_token'] = this.fcmToken;
    data['zone_id'] = this.zoneId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['active'] = this.active;
    data['earning'] = this.earning;
    data['current_orders'] = this.currentOrders;
    data['type'] = this.type;
    data['store_id'] = this.storeId;
    data['application_status'] = this.applicationStatus;
    data['order_count'] = this.orderCount;
    data['assigned_order_count'] = this.assignedOrderCount;
    data['delivery'] = this.delivery;
    data['ride_sharing'] = this.rideSharing;
    data['vehicle_reg_no'] = this.vehicleRegNo;
    data['vehicle_rc'] = this.vehicleRc;
    data['vehicle_owner_noc'] = this.vehicleOwnerNoc;
    data['ride_zone_id'] = this.rideZoneId;
    data['ride_category_id'] = this.rideCategoryId;
    data['avg_rating'] = this.avgRating;
    data['rating_count'] = this.ratingCount;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['location'] = this.location;
    return data;
  }
}