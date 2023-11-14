class TripModel {
  int totalSize;
  String limit;
  String offset;
  Orders orders;

  TripModel({this.totalSize, this.limit, this.offset, this.orders});

  TripModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    orders = json['orders'] != null ? new Orders.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.orders != null) {
      data['orders'] = this.orders.toJson();
    }
    return data;
  }
}

class Orders {
  int currentPage;
  List<Data> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Links> links;
  String nextPageUrl;
  String path;
  String perPage;
  String prevPageUrl;
  int to;
  int total;

  Orders(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Orders.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int id;
  int userId;
  double orderAmount;
  double couponDiscountAmount;
  String couponDiscountTitle;
  String paymentStatus;
  String orderStatus;
  double totalTaxAmount;
  String paymentMethod;
  String transactionReference;
  int deliveryAddressId;
  int deliveryManId;
  String couponCode;
  String orderNote;
  String orderType;
  int checked;
  int storeId;
  String createdAt;
  String updatedAt;
  int deliveryCharge;
  String scheduleAt;
  String callback;
  String otp;
  String pending;
  String accepted;
  String confirmed;
  String processing;
  String handover;
  String pickedUp;
  String delivered;
  String canceled;
  String refundRequested;
  String refunded;
  String deliveryAddress;
  int scheduled;
  int storeDiscountAmount;
  int originalDeliveryCharge;
  String failed;
  String adjusment;
  int edited;
  String deliveryTime;
  String zoneId;
  int moduleId;
  String orderAttachment;
  double distance;
  int parcelCategoryId;
  String receiverDetails;
  String chargePayer;
  int dmTips;
  String freeDeliveryBy;
  String refundRequestCanceled;
  bool prescriptionOrder;
  String taxStatus;
  int tripOrder;
  int operationAreaId;
  int providerId;
  String moduleType;
  Provider provider;
  Null deliveryMan;
  Trip trip;
  Customer customer;
  Module module;

  Data(
      {this.id,
        this.userId,
        this.orderAmount,
        this.couponDiscountAmount,
        this.couponDiscountTitle,
        this.paymentStatus,
        this.orderStatus,
        this.totalTaxAmount,
        this.paymentMethod,
        this.transactionReference,
        this.deliveryAddressId,
        this.deliveryManId,
        this.couponCode,
        this.orderNote,
        this.orderType,
        this.checked,
        this.storeId,
        this.createdAt,
        this.updatedAt,
        this.deliveryCharge,
        this.scheduleAt,
        this.callback,
        this.otp,
        this.pending,
        this.accepted,
        this.confirmed,
        this.processing,
        this.handover,
        this.pickedUp,
        this.delivered,
        this.canceled,
        this.refundRequested,
        this.refunded,
        this.deliveryAddress,
        this.scheduled,
        this.storeDiscountAmount,
        this.originalDeliveryCharge,
        this.failed,
        this.adjusment,
        this.edited,
        this.deliveryTime,
        this.zoneId,
        this.moduleId,
        this.orderAttachment,
        this.distance,
        this.parcelCategoryId,
        this.receiverDetails,
        this.chargePayer,
        this.dmTips,
        this.freeDeliveryBy,
        this.refundRequestCanceled,
        this.prescriptionOrder,
        this.taxStatus,
        this.tripOrder,
        this.operationAreaId,
        this.providerId,
        this.moduleType,
        this.provider,
        this.deliveryMan,
        this.trip,
        this.customer,
        this.module});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderAmount = json['order_amount'].toDouble();
    couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount'].toDouble();
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    deliveryAddressId = json['delivery_address_id'];
    deliveryManId = json['delivery_man_id'];
    couponCode = json['coupon_code'];
    orderNote = json['order_note'];
    orderType = json['order_type'];
    checked = json['checked'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge'];
    scheduleAt = json['schedule_at'];
    callback = json['callback'];
    otp = json['otp'];
    pending = json['pending'];
    accepted = json['accepted'];
    confirmed = json['confirmed'];
    processing = json['processing'];
    handover = json['handover'];
    pickedUp = json['picked_up'];
    delivered = json['delivered'];
    canceled = json['canceled'];
    refundRequested = json['refund_requested'];
    refunded = json['refunded'];
    deliveryAddress = json['delivery_address'];
    scheduled = json['scheduled'];
    storeDiscountAmount = json['store_discount_amount'];
    originalDeliveryCharge = json['original_delivery_charge'];
    failed = json['failed'];
    adjusment = json['adjusment'];
    edited = json['edited'];
    deliveryTime = json['delivery_time'];
    zoneId = json['zone_id'];
    moduleId = json['module_id'];
    orderAttachment = json['order_attachment'];
    distance = json['distance'].toDouble();
    parcelCategoryId = json['parcel_category_id'];
    receiverDetails = json['receiver_details'];
    chargePayer = json['charge_payer'];
    dmTips = json['dm_tips'];
    freeDeliveryBy = json['free_delivery_by'];
    refundRequestCanceled = json['refund_request_canceled'];
    prescriptionOrder = json['prescription_order'];
    taxStatus = json['tax_status'];
    tripOrder = json['trip_order'];
    operationAreaId = json['operation_area_id'];
    providerId = json['provider_id'];
    moduleType = json['module_type'];
    provider = json['provider'] != null
        ? new Provider.fromJson(json['provider'])
        : null;
    deliveryMan = json['delivery_man'];
    trip = json['trip'] != null ? new Trip.fromJson(json['trip']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    module =
    json['module'] != null ? new Module.fromJson(json['module']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_amount'] = this.orderAmount;
    data['coupon_discount_amount'] = this.couponDiscountAmount;
    data['coupon_discount_title'] = this.couponDiscountTitle;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['payment_method'] = this.paymentMethod;
    data['transaction_reference'] = this.transactionReference;
    data['delivery_address_id'] = this.deliveryAddressId;
    data['delivery_man_id'] = this.deliveryManId;
    data['coupon_code'] = this.couponCode;
    data['order_note'] = this.orderNote;
    data['order_type'] = this.orderType;
    data['checked'] = this.checked;
    data['store_id'] = this.storeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_charge'] = this.deliveryCharge;
    data['schedule_at'] = this.scheduleAt;
    data['callback'] = this.callback;
    data['otp'] = this.otp;
    data['pending'] = this.pending;
    data['accepted'] = this.accepted;
    data['confirmed'] = this.confirmed;
    data['processing'] = this.processing;
    data['handover'] = this.handover;
    data['picked_up'] = this.pickedUp;
    data['delivered'] = this.delivered;
    data['canceled'] = this.canceled;
    data['refund_requested'] = this.refundRequested;
    data['refunded'] = this.refunded;
    data['delivery_address'] = this.deliveryAddress;
    data['scheduled'] = this.scheduled;
    data['store_discount_amount'] = this.storeDiscountAmount;
    data['original_delivery_charge'] = this.originalDeliveryCharge;
    data['failed'] = this.failed;
    data['adjusment'] = this.adjusment;
    data['edited'] = this.edited;
    data['delivery_time'] = this.deliveryTime;
    data['zone_id'] = this.zoneId;
    data['module_id'] = this.moduleId;
    data['order_attachment'] = this.orderAttachment;
    data['distance'] = this.distance;
    data['parcel_category_id'] = this.parcelCategoryId;
    data['receiver_details'] = this.receiverDetails;
    data['charge_payer'] = this.chargePayer;
    data['dm_tips'] = this.dmTips;
    data['free_delivery_by'] = this.freeDeliveryBy;
    data['refund_request_canceled'] = this.refundRequestCanceled;
    data['prescription_order'] = this.prescriptionOrder;
    data['tax_status'] = this.taxStatus;
    data['trip_order'] = this.tripOrder;
    data['operation_area_id'] = this.operationAreaId;
    data['provider_id'] = this.providerId;
    data['module_type'] = this.moduleType;
    if (this.provider != null) {
      data['provider'] = this.provider.toJson();
    }
    data['delivery_man'] = this.deliveryMan;
    if (this.trip != null) {
      data['trip'] = this.trip.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.module != null) {
      data['module'] = this.module.toJson();
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

class Trip {
  int id;
  int orderId;
  int userId;
  int vehicleId;
  int driverId;
  int providerId;
  int moduleId;
  int operationAreaId;
  String vehicleCategory;
  double tripAmount;
  double couponDiscountAmount;
  String couponDiscountTitle;
  String paymentStatus;
  String tripStatus;
  double totalTaxAmount;
  String paymentMethod;
  String transactionReference;
  String couponCode;
  String additionalNote;
  bool checked;
  int additionalCharge;
  int cancelationFare;
  double estimatedFare;
  double estimatedTime;
  double estimatedDistance;
  double actualFare;
  double actualTime;
  double actualDistance;
  String scheduleAt;
  bool scheduled;
  Null callback;
  String otp;
  String pending;
  String accepted;
  String confirmed;
  String outForPickup;
  String arrived;
  String onTheWay;
  String dropped;
  String canceled;
  String rejected;
  String failed;
  double providerDiscountAmount;
  String createdAt;
  String updatedAt;

  Trip(
      {this.id,
        this.orderId,
        this.userId,
        this.vehicleId,
        this.driverId,
        this.providerId,
        this.moduleId,
        this.operationAreaId,
        this.vehicleCategory,
        this.tripAmount,
        this.couponDiscountAmount,
        this.couponDiscountTitle,
        this.paymentStatus,
        this.tripStatus,
        this.totalTaxAmount,
        this.paymentMethod,
        this.transactionReference,
        this.couponCode,
        this.additionalNote,
        this.checked,
        this.additionalCharge,
        this.cancelationFare,
        this.estimatedFare,
        this.estimatedTime,
        this.estimatedDistance,
        this.actualFare,
        this.actualTime,
        this.actualDistance,
        this.scheduleAt,
        this.scheduled,
        this.callback,
        this.otp,
        this.pending,
        this.accepted,
        this.confirmed,
        this.outForPickup,
        this.arrived,
        this.onTheWay,
        this.dropped,
        this.canceled,
        this.rejected,
        this.failed,
        this.providerDiscountAmount,
        this.createdAt,
        this.updatedAt});

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    vehicleId = json['vehicle_id'];
    driverId = json['driver_id'];
    providerId = json['provider_id'];
    moduleId = json['module_id'];
    operationAreaId = json['operation_area_id'];
    vehicleCategory = json['vehicle_category'];
    tripAmount = double.parse(json['trip_amount'].toString());
    couponDiscountAmount = json['coupon_discount_amount'] != null ? json['coupon_discount_amount'].toDouble() : null;
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    tripStatus = json['trip_status'];
    totalTaxAmount = json['total_tax_amount'] != null ? json['total_tax_amount'].toDouble() : null;
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    couponCode = json['coupon_code'];
    additionalNote = json['additional_note'];
    checked = json['checked'];
    additionalCharge = json['additional_charge'];
    cancelationFare = json['cancelation_fare'];
    estimatedFare = json['estimated_fare'] != null ? json['estimated_fare'].toDouble() : null;
    estimatedTime = json['estimated_time'] != null ? json['estimated_time'].toDouble() : null;
    estimatedDistance = json['estimated_distance'] != null ? json['estimated_distance'].toDouble() : null;
    actualFare = json['actual_fare'] != null ? json['actual_fare'].toDouble() : null;
    actualTime = json['actual_time'] != null ? json['actual_time'].toDouble() : null;
    actualDistance = json['actual_distance'] != null ? json['actual_distance'].toDouble() : null;
    scheduleAt = json['schedule_at'];
    scheduled = json['scheduled'];
    callback = json['callback'];
    otp = json['otp'];
    pending = json['pending'];
    accepted = json['accepted'];
    confirmed = json['confirmed'];
    outForPickup = json['out_for_pickup'];
    arrived = json['arrived'];
    onTheWay = json['on_the_way'];
    dropped = json['dropped'];
    canceled = json['canceled'];
    rejected = json['rejected'];
    failed = json['failed'];
    providerDiscountAmount = json['provider_discount_amount'] != null ? json['provider_discount_amount'].toDouble() : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['vehicle_id'] = this.vehicleId;
    data['driver_id'] = this.driverId;
    data['provider_id'] = this.providerId;
    data['module_id'] = this.moduleId;
    data['operation_area_id'] = this.operationAreaId;
    data['vehicle_category'] = this.vehicleCategory;
    data['trip_amount'] = this.tripAmount;
    data['coupon_discount_amount'] = this.couponDiscountAmount;
    data['coupon_discount_title'] = this.couponDiscountTitle;
    data['payment_status'] = this.paymentStatus;
    data['trip_status'] = this.tripStatus;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['payment_method'] = this.paymentMethod;
    data['transaction_reference'] = this.transactionReference;
    data['coupon_code'] = this.couponCode;
    data['additional_note'] = this.additionalNote;
    data['checked'] = this.checked;
    data['additional_charge'] = this.additionalCharge;
    data['cancelation_fare'] = this.cancelationFare;
    data['estimated_fare'] = this.estimatedFare;
    data['estimated_time'] = this.estimatedTime;
    data['estimated_distance'] = this.estimatedDistance;
    data['actual_fare'] = this.actualFare;
    data['actual_time'] = this.actualTime;
    data['actual_distance'] = this.actualDistance;
    data['schedule_at'] = this.scheduleAt;
    data['scheduled'] = this.scheduled;
    data['callback'] = this.callback;
    data['otp'] = this.otp;
    data['pending'] = this.pending;
    data['accepted'] = this.accepted;
    data['confirmed'] = this.confirmed;
    data['out_for_pickup'] = this.outForPickup;
    data['arrived'] = this.arrived;
    data['on_the_way'] = this.onTheWay;
    data['dropped'] = this.dropped;
    data['canceled'] = this.canceled;
    data['rejected'] = this.rejected;
    data['failed'] = this.failed;
    data['provider_discount_amount'] = this.providerDiscountAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Customer {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String image;
  int isPhoneVerified;
  Null emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String cmFirebaseToken;
  int status;
  int orderCount;
  Null loginMedium;
  Null socialId;
  int zoneId;
  double walletBalance;
  int loyaltyPoint;
  String refCode;
  String currentLanguageKey;

  Customer(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.cmFirebaseToken,
        this.status,
        this.orderCount,
        this.loginMedium,
        this.socialId,
        this.zoneId,
        this.walletBalance,
        this.loyaltyPoint,
        this.refCode,
        this.currentLanguageKey});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cmFirebaseToken = json['cm_firebase_token'];
    status = json['status'];
    orderCount = json['order_count'];
    loginMedium = json['login_medium'];
    socialId = json['social_id'];
    zoneId = json['zone_id'];
    walletBalance = json['wallet_balance'];
    loyaltyPoint = json['loyalty_point'];
    refCode = json['ref_code'];
    currentLanguageKey = json['current_language_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    data['status'] = this.status;
    data['order_count'] = this.orderCount;
    data['login_medium'] = this.loginMedium;
    data['social_id'] = this.socialId;
    data['zone_id'] = this.zoneId;
    data['wallet_balance'] = this.walletBalance;
    data['loyalty_point'] = this.loyaltyPoint;
    data['ref_code'] = this.refCode;
    data['current_language_key'] = this.currentLanguageKey;
    return data;
  }
}

class Module {
  int id;
  String moduleName;
  String moduleType;
  String thumbnail;
  String status;
  int storesCount;
  String createdAt;
  String updatedAt;
  String icon;
  int themeId;
  String description;
  int allZoneService;

  Module(
      {this.id,
        this.moduleName,
        this.moduleType,
        this.thumbnail,
        this.status,
        this.storesCount,
        this.createdAt,
        this.updatedAt,
        this.icon,
        this.themeId,
        this.description,
        this.allZoneService});

  Module.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['module_name'];
    moduleType = json['module_type'];
    thumbnail = json['thumbnail'];
    status = json['status'];
    storesCount = json['stores_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    icon = json['icon'];
    themeId = json['theme_id'];
    description = json['description'];
    allZoneService = json['all_zone_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['module_name'] = this.moduleName;
    data['module_type'] = this.moduleType;
    data['thumbnail'] = this.thumbnail;
    data['status'] = this.status;
    data['stores_count'] = this.storesCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['icon'] = this.icon;
    data['theme_id'] = this.themeId;
    data['description'] = this.description;
    data['all_zone_service'] = this.allZoneService;
    return data;
  }
}

class Links {
  String url;
  String label;
  bool active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}