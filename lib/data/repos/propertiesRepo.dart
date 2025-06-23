import 'package:easyrent/core/services/api/dio_consumer.dart';
import 'package:easyrent/core/services/api/errors/exceptions.dart';
import 'package:easyrent/data/models/favourite_model.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/main.dart';

class PropertiesRepo {
  final DioConsumer api;
  PropertiesRepo(this.api);

  //!------------------------ get all properties(homePage)----------------------------->
  Future<List<OuterPropertyModel>> getProperties() async {
    try {
      final response = await api.get("87a1b2e4-d08c-4f37-802b-2c4cbc5fdb0e");
      if (response.statusCode == 200) {
        debug.i("Fetch Properties status code  ${response.statusCode} ");
        var responseData = response.data;
        List tempList = [];
        for (var v in responseData) {
          debug.e(v);
          tempList.add(v);
        }
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
        debug.t(
            "Fetch Favorite Properties status code  ${response.statusCode} ");
        var responseData = response.data;
        List tempList = [];
        for (var v in responseData) {
          debug.e(v);
          tempList.add(v);
        }
        return FavoritePropertyModel.favoritePropertiesFromSnapshot(
            response.data);
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
        debug.i(
            "Fetched property with id $id, status code ${response.statusCode}");
        debug.i(response.data);
        return PropertyModel.fromJson(response.data);
      }
      return PropertyModel.fromJson({});
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return PropertyModel.fromJson({});
    }
  }

  //!------------------------ Change Favorite State ------------------------------->
  Future<void> changeFavoriteState(int id) async {
    try {
      final response = await api.post("http://localhost:3000/favorite/$id");
      if (response.statusCode == 200) {
        debug.i("Changed favorite state for property id $id");
        return;
      }
      return;
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return;
    }
  }
}

// //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// //$$$$$$$$$$$$$$$$$$//TODOD REMOVE THIS NONSCENSE :D $$$$$$$$$$$$$$$$$$$$$$$$$
// //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// ///! mock alternative coz mocky.io not working
//   // 👇 Temporary helper to load mock data from JSON in assets

// import 'dart:convert';
// import 'package:flutter/services.dart';


// class PropertiesRepo {
//   final DioConsumer api;
//   PropertiesRepo(this.api);

//   Future<dynamic> _loadJson(String fileName) async {
//     final data = await rootBundle.loadString('assets/json/$fileName');
//     return json.decode(data);
//   }

//   //!------------------------ get all properties(homePage)----------------------------->
//   Future<List<OuterPropertyModel>> getProperties() async {
//     try {
//       final responseData = await _loadJson('getAllProperties.json');
//       return OuterPropertyModel.propertiesFromSnapshot(responseData);
//     } catch (e) {
//       debug.e("Mock error: $e");
//       return [];
//     }
//   }

//   //!------------------------ get Favorite properties------------------------------->
//   Future<List<FavoritePropertyModel>> getFavoriteProperties() async {
//     try {
//       final responseData = await _loadJson('favourite.json');
//       return FavoritePropertyModel.favoritePropertiesFromSnapshot(responseData);
//     } catch (e) {
//       debug.e("Mock error: $e");
//       return [];
//     }
//   }

//   //!------------------------ get Properties Details ------------------------------->
//   Future<PropertyModel> propertyDetailsById(int id) async {
//     try {
//       final json = await _loadJson('propertyDetails.json');
//       return PropertyModel.fromJson(json);
//     } catch (e) {
//       debug.e("Mock error: $e");
//       return PropertyModel.fromJson({});
//     }
//   }


// }
