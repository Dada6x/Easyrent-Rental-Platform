import 'package:easyrent/data/models/agent_model.dart';
import 'package:easyrent/data/models/location_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';

final PropertyModel demoProperty = PropertyModel(
  id: 101,
  title: "Modern Luxury Villa",
  description:
      "A stunning modern villa featuring spacious rooms, premium finishes, and an amazing panoramic view. Perfect for families and professionals seeking comfort and style.",
  rooms: 4,
  bathrooms: 3,
  area: 260.5,
  isFloor: false,
  floorNumber: null,
  hasGarage: true,
  hasGarden: true,
  propertyType: "Villa",
  heatingType: "Central Heating",
  flooringType: "Marble",
  price: 350000,
  isForRent: false,
  state: "Available",
  isFavorite: false,
  voteValue: false,
  viewCount: 98,
  priorityScore: 4,
  priorityScoreRate: 5,
  acceptCount: 12,
  status: "Active",
  createdAt: "2024-01-01",
  updatedAt: "2024-02-01",

  // ------------------------------------------------------
  // LOCATION
  // ------------------------------------------------------
  location: Location(
    governorate: "Syria",
    country: "Syria",
    city: "Damascus",
    quarter: "Mazzeh",
    street: "Al-Motlaq Street",
    lat: 33.5074,
    lon: 36.2988,
  ),

  // ------------------------------------------------------
  // IMAGE GALLERY
  // ------------------------------------------------------
  propertyImages: [
    "https://images.unsplash.com/photo-1568605114967-8130f3a36994",
    "https://images.unsplash.com/photo-1572120360610-d971b9d7767c",
    "https://images.unsplash.com/photo-1507089947368-19c1da9775ae",
  ],

  // ------------------------------------------------------
  // PANORAMA IMAGES
  // ------------------------------------------------------
  panoramaImages: {
    "Living Room":
        "https://storage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg",
    "Master Bedroom":
        "https://storage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg",
  },

  // ------------------------------------------------------
  // AGENT
  // ------------------------------------------------------
  agent: Agent(
    properties: [],
    rating: 5,
    id: 1,
    name: "John Doe",
    phone: "+963 987 654 321",
    photo:
        "https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=400&q=80",
  ),

  // ------------------------------------------------------
  // PRIORITY SCORE ENTITY
  // ------------------------------------------------------
  priorityScoreEntity: PriorityScoreEntity(
    adminsScoreRate: 4,
    suitabilityScoreRate: 5,
    voteScoreRate: 3,
  ),
);
