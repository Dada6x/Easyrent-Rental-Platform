// import 'package:dio/dio.dart';
import 'package:easyrent/core/services/api/dio_consumer.dart';
import 'package:easyrent/core/services/api/errors/exceptions.dart';
import 'package:easyrent/data/models/favourite_model.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/main.dart';
class PropertiesRepo {
  final DioConsumer api;
  PropertiesRepo(this.api);

  //!------------------------ get all properties:(homePage)----------------------------->
  Future<List<OuterPropertyModel>> getProperties() async {
    try {
      final response = await api.get("87a1b2e4-d08c-4f37-802b-2c4cbc5fdb0e");
      if (response.statusCode == 200) {
        debug.i("Fetch Properties status code  ${response.statusCode} ");
        return OuterPropertyModel.propertiesFromSnapshot(response.data);
      }
      return [];
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return [];
    }
  }

  //!------------------------ get Favorite properties------------------------------->
  Future<List<FavoritePropertyModel>> getFavoriteProperties() async {
    try {
      final response = await api.get("1ae42e8e-c236-4b6f-bd9b-07f8460fd350");
      if (response.statusCode == 200) {
        debug.t("Fetch Favorite Properties status code  ${response.statusCode} ");
        return FavoritePropertyModel.favoritePropertiesFromSnapshot(response.data);
      }
      return [];
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return [];
    }
  }

  //!------------------------ get Properties Details ------------------------------->
  Future<PropertyModel> propertyDetailsById(int id) async {
    try {
      final response = await api.get("d1f40a97-b320-4f37-b971-16134922a910");
      if (response.statusCode == 200) {
        debug.i("Fetched property with id $id, status code ${response.statusCode}");
        return PropertyModel.fromJson(response.data);
      }
      return PropertyModel.fromJson({});
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return PropertyModel.fromJson({});
    }
  }

  //!------------------------ Change Favourite State ------------------------------->
  Future<PropertyModel> changeFavouriteState(int id) async {
    try {
      final response = await api.post("http://localhost:3000/favorite/$id");
      if (response.statusCode == 200) {
        debug.i("Changed favorite state for property id $id");
        return PropertyModel.fromJson(response.data);
      }
      return PropertyModel.fromJson({});
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return PropertyModel.fromJson({});
    }
  }
}
