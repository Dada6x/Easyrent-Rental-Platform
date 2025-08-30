import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/button.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/AgentFeatures/singleImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UploadHomesPage extends StatefulWidget {
  const UploadHomesPage({super.key});

  @override
  State<UploadHomesPage> createState() => _UploadHomesPageState();
}

class _UploadHomesPageState extends State<UploadHomesPage> {
  final ImagePicker _picker = ImagePicker();

// Lists to hold selected images
  List<XFile> _galleryImages = [];
  List<XFile> _panoramaImages = [];

// Pick normal images
  Future<void> _pickGalleryImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _galleryImages = images;
      });
    }
  }

// Pick panorama images
  Future<void> _pickPanoramaImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _panoramaImages = images;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _roomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _areaController = TextEditingController();
  final _floorNumberController = TextEditingController();

  String? _selectedHeatingType;
  String? _selectedFlooringType;
  String? _selectedPropertyType;
  LatLng _pickedLocation = const LatLng(0, 0);

  bool _isForRent = true;
  bool _hasGarage = false;
  bool _hasGarden = false;
  bool _isFloor = false;

  final Dio _dio = Dio();

  final List<String> heatingTypes = ['Central', 'Gas', 'Electric', 'None'];
  final List<String> flooringTypes = ['Wood', 'Tile', 'Carpet', 'Concrete'];
  final List<String> propertyTypes = ['Apartment', 'Villa', 'House', 'Studio'];

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const MapPickerPage(initialLocation: LatLng(33.5138, 36.2765)),
      ),
    );
    if (result != null) setState(() => _pickedLocation = result);
  }

  Future<void> _submitProperty() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> data = {
      "title": _titleController.text.toString(),
      "description": _descriptionController.text.toString(),
      "isForRent": _isForRent,
      "price": int.tryParse(_priceController.text) ?? 0,
      "pointsDto": {
        "lat": _pickedLocation.latitude,
        "lon": _pickedLocation.longitude,
      },
      "rooms": int.tryParse(_roomsController.text) ?? 0,
      "bathrooms": int.tryParse(_bathroomsController.text) ?? 0,
      "area": int.tryParse(_areaController.text) ?? 0,
      "floorNumber": int.tryParse(_floorNumberController.text) ?? 0,
      "hasGarage": _hasGarage,
      "hasGarden": _hasGarden,
      "heatingType": _selectedHeatingType.toString() ?? '',
      "flooringType": _selectedFlooringType.toString() ?? '',
      "propertyType": _selectedPropertyType.toString() ?? '',
      "isFloor": _isFloor,
      "agencyId": 2,
    };

    debug.i(data);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await _dio.post(
        'https://18fbfdf5e6a5.ngrok-free.app/properties-on/',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debug.i(response.data);
        final propertyId = response.data;
        _formKey.currentState!.reset();
        setState(() {
          _pickedLocation = const LatLng(0, 0);
          _selectedHeatingType = null;
          _selectedFlooringType = null;
          _selectedPropertyType = null;
          _isForRent = true;
          _hasGarage = false;
          _hasGarden = false;
          _isFloor = false;
        });
        Get.to(() => SingleImage(propertyId: propertyId.toString()));
      } else {
        debug.i(response.data);
      }
    } catch (e, s) {
      debug.i(e);
      debug.i(s);
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      );

  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(label),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Select $label' : null,
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildMapPreview() {
    return Stack(
      children: [
        GestureDetector(
          onTap: _pickLocation, // tap anywhere on map to pick
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 180,
              child: _pickedLocation == const LatLng(0, 0)
                  ? Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.map, color: grey),
                            SizedBox(width: 5),
                            Text("Select Location"),
                          ],
                        ),
                      ),
                    )
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: _pickedLocation,
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                        MarkerLayer(markers: [
                          Marker(
                            point: _pickedLocation,
                            width: 25,
                            height: 25,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              child: Icon(Icons.circle,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          )
                        ]),
                      ],
                    ),
            ),
          ),
        ),
        // Icon button on top-right corner
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Iconify(Mdi.location_remove_outline,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: _pickLocation, // opens map picker
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Upload Property", style: AppTextStyles.h24medium)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Basic Info
              const Text("Basic Info",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration("Title"),
                  validator: (val) => val!.isEmpty ? "Enter title" : null),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _descriptionController,
                  decoration: _inputDecoration("Description"),
                  validator: (val) =>
                      val!.isEmpty ? "Enter description" : null),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _priceController,
                  decoration: _inputDecoration("Price \$"),
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? "Enter price" : null),
              const SizedBox(height: 15),

              // Section: Features
              const Text("Property Features",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          controller: _roomsController,
                          decoration: _inputDecoration("Rooms"),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val!.isEmpty ? "Enter rooms" : null)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                          controller: _bathroomsController,
                          decoration: _inputDecoration("Bathrooms"),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val!.isEmpty ? "Enter bathrooms" : null)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                          controller: _areaController,
                          decoration: _inputDecoration("Area (m²)"),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val!.isEmpty ? "Enter area" : null)),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _floorNumberController,
                  decoration: _inputDecoration("Floor Number"),
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val!.isEmpty ? "Enter floor number" : null),
              const SizedBox(height: 10),

              _buildDropdown("Heating Type", _selectedHeatingType, heatingTypes,
                  (val) => setState(() => _selectedHeatingType = val)),
              const SizedBox(height: 10),
              _buildDropdown(
                  "Flooring Type",
                  _selectedFlooringType,
                  flooringTypes,
                  (val) => setState(() => _selectedFlooringType = val)),
              const SizedBox(height: 10),
              _buildDropdown(
                  "Property Type",
                  _selectedPropertyType,
                  propertyTypes,
                  (val) => setState(() => _selectedPropertyType = val)),
              const SizedBox(height: 15),

              // Section: Location
              const Text("Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildMapPreview(),
              const SizedBox(height: 5),
              Text(
                _pickedLocation == const LatLng(0, 0)
                    ? "No location selected"
                    : "Latitude: ${_pickedLocation.latitude.toStringAsFixed(6)}, "
                        "Longitude: ${_pickedLocation.longitude.toStringAsFixed(6)}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 15),

              // Section: Options
              const Text("Options",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildSwitch("For Rent", _isForRent,
                  (val) => setState(() => _isForRent = val)),
              _buildSwitch("Has Garage", _hasGarage,
                  (val) => setState(() => _hasGarage = val)),
              _buildSwitch("Has Garden", _hasGarden,
                  (val) => setState(() => _hasGarden = val)),
              _buildSwitch("Is Floor", _isFloor,
                  (val) => setState(() => _isFloor = val)),
              const SizedBox(height: 5),
              //!
              const Text("Gallery ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              //! image selectors
              const SizedBox(height: 15),

              _buildImageButton("Upload Images", Icons.photo_library,
                  _pickGalleryImages, context),

// Show selected normal images
              if (_galleryImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _galleryImages.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(img.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 15),

// Upload panorama images
              _buildImageButton("Select Panorama Images", Icons.panorama,
                  _pickPanoramaImages, context),

// Show selected panorama images
              if (_panoramaImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _panoramaImages.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(img.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),

              CustomButton(hint: "Submit Property", function: _submitProperty),
            ],
          ),
        ),
      ),
    );
  }
}

class MapPickerPage extends StatefulWidget {
  final LatLng initialLocation;
  const MapPickerPage({super.key, required this.initialLocation});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late LatLng pickedLocation;

  @override
  void initState() {
    super.initState();
    pickedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        title: Text('Pick Location', style: AppTextStyles.h16medium),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, pickedLocation),
              child: const Padding(
                  padding: EdgeInsets.all(8.0), child: Text('Confirm'))),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: pickedLocation,
          onTap: (tapPos, point) => setState(() => pickedLocation = point),
        ),
        children: [
          TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c']),
          MarkerLayer(markers: [
            Marker(
              point: pickedLocation,
              width: 36,
              height: 36,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 1.5),
                ),
                child: Icon(Icons.circle,
                    size: 28, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

Widget _buildImageButton(
    String hint, IconData icon, VoidCallback function, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: ElevatedButton.icon(
      onPressed: function,
      icon: Icon(icon, size: 22),
      label: Text(hint, style: const TextStyle(fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        backgroundColor: white,
        foregroundColor: blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    ),
  );
}
