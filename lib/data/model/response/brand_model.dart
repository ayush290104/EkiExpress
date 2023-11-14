class BrandModel {
  int id;
  int moduleId;
  String name;
  String logo;
  String description;
  bool status;
  String createdAt;
  String updatedAt;

  BrandModel(
      {this.id,
        this.moduleId,
        this.name,
        this.logo,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt});

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleId = json['module_id'];
    name = json['name'];
    logo = json['logo'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['module_id'] = this.moduleId;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}