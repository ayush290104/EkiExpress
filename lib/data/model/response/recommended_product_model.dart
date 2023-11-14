
import 'package:sixam_mart/data/model/response/item_model.dart';

class RecommendedItemModel {
  int totalSize;
  String limit;
  String offset;
  List<Item> items;

  RecommendedItemModel({this.totalSize, this.limit, this.offset, this.items});

  RecommendedItemModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['items'] != null) {
      items = <Item>[];
      json['items'].forEach((v) {
        items.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.items != null) {
      data['products'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
