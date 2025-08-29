import 'package:easyrent/data/models/user_model.dart';
import 'location_model.dart';

class PropertyModel {
  int? rooms;
  int? bathrooms;
  double? area;
  bool? isFloor;
  int? floorNumber;
  bool? hasGarage;
  bool? hasGarden;
  String? propertyType;
  String? heatingType;
  String? flooringType;
  int? id;
  String? title;
  String? description;
  double? price;
  Location? location;
  bool? isForRent;
  String? state;
  String? propertyImage;
  List<String>? propertyImages;
  List<Map<String, String>>? panoramaImages;
  int? voteScore;
  int? viewCount;
  int? priorityScore;
  String? createdAt;
  String? updatedAt;
  bool? isFavorite;
  bool? voteValue;
  String? firstImage;
  int? priorityScoreRate;
  int? acceptCount;
  String? status;

  User? user;
  PriorityScoreEntity? priorityScoreEntity;

  PropertyModel({
    this.rooms,
    this.bathrooms,
    this.area,
    this.isFloor,
    this.floorNumber,
    this.hasGarage,
    this.hasGarden,
    this.propertyType,
    this.heatingType,
    this.flooringType,
    this.id,
    this.title,
    this.description,
    this.price,
    this.location,
    this.isForRent,
    this.state,
    this.propertyImage,
    this.propertyImages,
    this.panoramaImages,
    this.voteScore,
    this.viewCount,
    this.priorityScore,
    this.createdAt,
    this.updatedAt,
    this.isFavorite,
    this.voteValue,
    this.firstImage,
    this.priorityScoreRate,
    this.acceptCount,
    this.status,
    this.user,
    this.priorityScoreEntity,
  });

  PropertyModel.fromJson(Map<String, dynamic> json) {
    rooms = json['rooms'];
    bathrooms = json['bathrooms'];
    area = json['area'] != null
        ? (json['area'] is String
            ? double.tryParse(json['area']) ?? 0.0
            : (json['area'] as num).toDouble())
        : null;
    isFloor = json['isFloor'];
    floorNumber = json['floorNumber'];
    hasGarage = json['hasGarage'];
    hasGarden = json['hasGarden'];
    propertyType = json['propertyType'];
    heatingType = json['heatingType'];
    flooringType = json['flooringType'];
    id = json['id'];
    title = json['title'];
    description = json['description'];

    price = json['price'] != null
        ? (json['price'] is String
            ? double.tryParse(json['price']) ?? 0.0
            : (json['price'] as num).toDouble())
        : 0.0;

    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    isForRent = json['isForRent'];
    state = json['state'];
    propertyImage = json['propertyImage'];
    isFavorite = json['isFavorite'];
    voteValue = json['voteValue'];
    firstImage = json['firstImage'] ?? ''; // fallback if null
    priorityScoreRate = json['priorityScoreRate'];
    acceptCount = json['acceptCount'];
    status = json['status'];

    user = json['user'] != null ? User.fromJson(json['user']) : null;
    priorityScoreEntity = json['priorityScoreEntity'] != null
        ? PriorityScoreEntity.fromJson(json['priorityScoreEntity'])
        : null;

    propertyImages =
        (json['propertyImages'] as List?)?.map((e) => e.toString()).toList();

    panoramaImages = (json['panoramaImages'] as List?)
        ?.map((e) => Map<String, String>.from(e as Map))
        .toList();

    voteScore = json['voteScore'];
    viewCount = json['viewCount'];
    priorityScore = json['priorityScore'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class PriorityScoreEntity {
  int? adminsScoreRate;
  int? suitabilityScoreRate;
  int? voteScoreRate;

  PriorityScoreEntity({
    this.adminsScoreRate,
    this.suitabilityScoreRate,
    this.voteScoreRate,
  });

  factory PriorityScoreEntity.fromJson(Map<String, dynamic> json) {
    return PriorityScoreEntity(
      adminsScoreRate: json['adminsScoreRate'],
      suitabilityScoreRate: json['suitabilityScoreRate'],
      voteScoreRate: json['voteScoreRate'],
    );
  }
}
