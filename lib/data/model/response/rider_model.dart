class RiderModel {
  RiderLatLng latLng;
  String phone;
  int id;
  double ratings;
  String updatedTime;
  bool isAvailable;
  double heading;
  String name;
  String image;

  RiderModel(
      {this.latLng,
        this.phone,
        this.id,
        this.ratings,
        this.updatedTime,
        this.isAvailable,
        this.heading,
        this.name,
        this.image,
      });

  RiderModel.fromJson(Map<Object, Object> json) {
    Map<String, dynamic> _json = Map.from(json);
    latLng = _json['latLng'] != null ? new RiderLatLng.fromJson(_json['latLng']) : null;
    phone = _json['phone'];
    id = _json['id'];
    ratings = _json['ratings'].toDouble();
    updatedTime = _json['updated_time'];
    isAvailable = _json['isAvailable'];
    heading = _json['heading'].toDouble();
    name = _json['name'];
    image = _json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.latLng != null) {
      data['latLng'] = this.latLng.toJson();
    }
    data['phone'] = this.phone;
    data['id'] = this.id;
    data['ratings'] = this.ratings;
    data['updated_time'] = this.updatedTime;
    data['isAvailable'] = this.isAvailable;
    data['heading'] = this.heading;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class RiderLatLng {
  double lat;
  double lng;

  RiderLatLng({this.lat, this.lng});

  RiderLatLng.fromJson(List<Object> json) {
    lat = json[0] as double;
    lng = json[1] as double;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.lat;
    data['1'] = this.lng;
    return data;
  }
}
