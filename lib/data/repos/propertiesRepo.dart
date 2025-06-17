import 'package:dio/dio.dart';
import 'package:easyrent/core/services/api/dio_consumer.dart';
import 'package:easyrent/core/services/api/errors/exceptions.dart';
import 'package:easyrent/data/models/favourite_model.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/main.dart';

class PropertiesRepo {
  //!------------------------ get all properties:(homePage)----------------------------->
  static Future<List<OuterPropertyModel>> getProperties() async {
    final api = DioConsumer(Dio()); //TODO not like this call the dio
    try {
      final response = await api
          .get("87a1b2e4-d08c-4f37-802b-2c4cbc5fdb0e");
      //todo add the endpoint of the API
      if (response.statusCode == 200) {
        debug.i("Fetch Properties status code  ${response.statusCode} ");
        var responseData = response.data;
        List tempList = [];
        for (var v in responseData) {
          debug.e(v);
          tempList.add(v);
        }
        return OuterPropertyModel.propertiesFromSnapshot(tempList);
      }
      return [];
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return [];
    }
  }

//!------------------------ get Favorite properties------------------------------->
  static Future<List<FavoritePropertyModel>> getFavoriteProperties() async {
    final api = DioConsumer(Dio());
    try {
      final response = await api
          .get("1ae42e8e-c236-4b6f-bd9b-07f8460fd350");
      //todo add the endpoint of the API
      if (response.statusCode == 200) {
        debug.t(
            "Fetch Favorite Properties status code  ${response.statusCode} ");
        var responseData = response.data;
        List tempList = [];
        for (var v in responseData) {
          debug.w(v);
          tempList.add(v);
        }
        return FavoritePropertyModel.favoritePropertiesFromSnapshot(tempList);
      }
      return [];
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return [];
    }
  }

//!------------------------ get Properties Details ------------------------------->
  static Future<PropertyModel> propertyDetailsById(int id) async {
    final api = DioConsumer(Dio());
    try {
      final response = await api.get(
          // EndPoints.favourite,
          //https://run.mocky.io/v3/68b6b726-0e71-429e-b67b-d011c2b99f4c  //! with no garden or
          "d1f40a97-b320-4f37-b971-16134922a910");
      //todo add the endpoint of the API
      if (response.statusCode == 200) {
        debug.i("Fetch Details of property with id $id , status code ${response.statusCode} ");
        var responseData = response.data;

        debug.i(responseData);
        return PropertyModel.fromJson(responseData);
      }
      return PropertyModel.fromJson({});
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return PropertyModel.fromJson({});
    }
  }

  const PropertiesRepo();
}


// https://images.unsplash.com/photo-1519678767534-29483894b34d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3Dhttps://images.unsplash.com/photo-1519678767534-29483894b34d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D