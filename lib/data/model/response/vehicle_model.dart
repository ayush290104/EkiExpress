class VehicleModel {
  int totalSize;
  int limit;
  int offset;
  List<Vehicles> vehicles;

  VehicleModel({this.totalSize, this.limit, this.offset, this.vehicles});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = int.parse(json['limit'].toString());
    offset = int.parse(json['offset'].toString());
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles.add(new Vehicles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.vehicles != null) {
      data['vehicles'] = this.vehicles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicles {
  int id;
  int vehicleBrandId;
  int vehicleCategoryId;
  int vehicleModelId;
  String name;
  String engineCapacity;
  String airCondition;
  String transmissionType;
  String fuelType;
  int vinNumber;
  int licensePlateNumber;
  String mileageType;
  int hatchbagCapacity;
  int seatingCapacity;
  String licenseExpDate;
  List<String> carImages;
  List<String> documents;
  int moduleId;
  int providerId;
  bool status;
  int avgRating;
  int ratingCount;
  String createdAt;
  String updatedAt;
  String minFare;
  String brandName;
  String modelName;
  String categoryName;
  double insidePerHourCharge;
  double insidePerKmCharge;
  double outsidePerHourCharge;
  double outsidePerKmCharge;
  Provider provider;

  Vehicles(
      {this.id,
        this.vehicleBrandId,
        this.vehicleCategoryId,
        this.vehicleModelId,
        this.name,
        this.engineCapacity,
        this.airCondition,
        this.transmissionType,
        this.fuelType,
        this.vinNumber,
        this.licensePlateNumber,
        this.mileageType,
        this.hatchbagCapacity,
        this.seatingCapacity,
        this.licenseExpDate,
        this.carImages,
        this.documents,
        this.moduleId,
        this.providerId,
        this.status,
        this.avgRating,
        this.ratingCount,
        this.createdAt,
        this.updatedAt,
        this.minFare,
        this.brandName,
        this.modelName,
        this.categoryName,
        this.insidePerHourCharge,
        this.insidePerKmCharge,
        this.outsidePerHourCharge,
        this.outsidePerKmCharge,
        this.provider});

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleBrandId = json['vehicle_brand_id'];
    vehicleCategoryId = json['vehicle_category_id'];
    vehicleModelId = json['vehicle_model_id'];
    name = json['name'];
    engineCapacity = json['engine_capacity'];
    airCondition = json['air_condition'];
    transmissionType = json['transmission_type'];
    fuelType = json['fuel_type'];
    vinNumber = json['vin_number'];
    licensePlateNumber = json['license_plate_number'];
    mileageType = json['mileage_type'];
    hatchbagCapacity = json['hatchbag_capacity'];
    seatingCapacity = json['seating_capacity'];
    licenseExpDate = json['license_exp_date'];
    carImages = json['car_images'].cast<String>();
    documents = json['documents'].cast<String>();
    moduleId = json['module_id'];
    providerId = json['provider_id'];
    status = json['status'];
    avgRating = json['avg_rating'];
    ratingCount = json['rating_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    minFare = json['min_fare'];
    brandName = json['brand_name'];
    modelName = json['model_name'];
    categoryName = json['category_name'];
    insidePerHourCharge = json['inside_per_hr_charge'];
    insidePerKmCharge = json['inside_per_km_charge'];
    outsidePerHourCharge = json['outside_per_hr_charge'];
    outsidePerKmCharge = json['outside_per_km_charge'];
    provider = json['provider'] != null
        ? new Provider.fromJson(json['provider'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_brand_id'] = this.vehicleBrandId;
    data['vehicle_category_id'] = this.vehicleCategoryId;
    data['vehicle_model_id'] = this.vehicleModelId;
    data['name'] = this.name;
    data['engine_capacity'] = this.engineCapacity;
    data['air_condition'] = this.airCondition;
    data['transmission_type'] = this.transmissionType;
    data['fuel_type'] = this.fuelType;
    data['vin_number'] = this.vinNumber;
    data['license_plate_number'] = this.licensePlateNumber;
    data['mileage_type'] = this.mileageType;
    data['hatchbag_capacity'] = this.hatchbagCapacity;
    data['seating_capacity'] = this.seatingCapacity;
    data['license_exp_date'] = this.licenseExpDate;
    data['car_images'] = this.carImages;
    data['documents'] = this.documents;
    data['module_id'] = this.moduleId;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['avg_rating'] = this.avgRating;
    data['rating_count'] = this.ratingCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['min_fare'] = this.minFare;
    data['brand_name'] = this.brandName;
    data['model_name'] = this.modelName;
    data['category_name'] = this.categoryName;
    data['inside_per_hr_charge'] = this.insidePerHourCharge;
    data['inside_per_km_charge'] = this.insidePerKmCharge;
    data['outside_per_hr_charge'] = this.outsidePerHourCharge;
    data['outside_per_km_charge'] = this.outsidePerKmCharge;
    if (this.provider != null) {
      data['provider'] = this.provider.toJson();
    }
    return data;
  }
}

class Provider {
  int id;
  String name;
  String phone;
  String email;
  String logo;
  String coverPhoto;
  String latitude;
  String longitude;
  String address;
  String footerText;
  int tax;
  int comission;
  String currency;
  bool status;
  int totalVehicle;
  int totalDriver;
  int totalTrip;
  int completedTrip;
  int ongoingTrip;
  int canceledTrip;
  int vendorId;
  int moduleId;
  int operationAreaId;
  String createdAt;
  String updatedAt;

  Provider(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.logo,
        this.coverPhoto,
        this.latitude,
        this.longitude,
        this.address,
        this.footerText,
        this.tax,
        this.comission,
        this.currency,
        this.status,
        this.totalVehicle,
        this.totalDriver,
        this.totalTrip,
        this.completedTrip,
        this.ongoingTrip,
        this.canceledTrip,
        this.vendorId,
        this.moduleId,
        this.operationAreaId,
        this.createdAt,
        this.updatedAt});

  Provider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'];
    coverPhoto = json['cover_photo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    footerText = json['footer_text'];
    tax = json['tax'];
    comission = json['comission'];
    currency = json['currency'];
    status = json['status'];
    totalVehicle = json['total_vehicle'];
    totalDriver = json['total_driver'];
    totalTrip = json['total_trip'];
    completedTrip = json['completed_trip'];
    ongoingTrip = json['ongoing_trip'];
    canceledTrip = json['canceled_trip'];
    vendorId = json['vendor_id'];
    moduleId = json['module_id'];
    operationAreaId = json['operation_area_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['cover_photo'] = this.coverPhoto;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['footer_text'] = this.footerText;
    data['tax'] = this.tax;
    data['comission'] = this.comission;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['total_vehicle'] = this.totalVehicle;
    data['total_driver'] = this.totalDriver;
    data['total_trip'] = this.totalTrip;
    data['completed_trip'] = this.completedTrip;
    data['ongoing_trip'] = this.ongoingTrip;
    data['canceled_trip'] = this.canceledTrip;
    data['vendor_id'] = this.vendorId;
    data['module_id'] = this.moduleId;
    data['operation_area_id'] = this.operationAreaId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}