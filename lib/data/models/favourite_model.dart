import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';

class FavoritePropertyModel {
  int? favoriteId;
  OuterPropertyModel? property;

  FavoritePropertyModel({this.favoriteId, this.property});

  FavoritePropertyModel.fromJson(Map<String, dynamic> json) {
    favoriteId = json['id'];
    property = json['property'] != null
        ? OuterPropertyModel.fromJson(json['property'])
        : null;
  }

  static List<FavoritePropertyModel> favoritePropertiesFromSnapshot(
      List snapshot) {
    return snapshot.map((e) => FavoritePropertyModel.fromJson(e)).toList();
  }
}
