import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easyrent/core/constants/utils/button.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/core/services/api/api_consumer.dart';
import 'package:easyrent/data/models/location_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/data/repos/user_repo.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/AgentFeatures/submit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class UploadPropertyPage extends StatefulWidget {
  const UploadPropertyPage({super.key});

  @override
  State<UploadPropertyPage> createState() => _UploadPropertyPageState();
}

class _UploadPropertyPageState extends State<UploadPropertyPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _quarterController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  // State variables
  bool _isFloor = false;
  bool _hasGarage = false;
  bool _hasGarden = false;
  bool _isForRent = false;

  String? _propertyType;
  String? _heatingType;
  String? _flooringType;

  File? _mainImage;
  final List<File> _propertyImages = [];
  final picker = ImagePicker();

  LatLng? _pickedLocation;

  Future<void> pickMainImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mainImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickPropertyImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _propertyImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerPage(
          initialLocation:
              _pickedLocation ?? const LatLng(34.8021, 38.9968), // Syria
        ),
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        _pickedLocation = result;
      });
    }
  }

  void submitProperty() async {
    // Validate text fields
    if (!_formKey.currentState!.validate()) {
      showSnackbarWithContext("Please fill all required fields", context,
          isTop: true);
      return;
    }

    // Validate dropdowns
    if (_propertyType == null ||
        _heatingType == null ||
        _flooringType == null) {
      showSnackbarWithContext("Please select all dropdown options", context,
          isTop: true);
      return;
    }

    // Validate location
    if (_pickedLocation == null) {
      showSnackbarWithContext("Please select a location", context, isTop: true);
      return;
    }

    // Validate images
    if (_mainImage == null) {
      showSnackbarWithContext("Please pick a main image", context, isTop: true);
      return;
    }
    if (_propertyImages.isEmpty) {
      showSnackbarWithContext(
          "Please pick at least one property image", context,
          isTop: true);
      return;
    }

    // All validation passed, create property model
    final property = PropertyModel(
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text),
      rooms: int.tryParse(_roomsController.text),
      bathrooms: int.tryParse(_bathroomsController.text),
      area: double.tryParse(_areaController.text),
      isFloor: _isFloor,
      floorNumber: _isFloor ? int.tryParse(_floorNumberController.text) : null,
      hasGarage: _hasGarage,
      hasGarden: _hasGarden,
      propertyType: _propertyType!,
      heatingType: _heatingType!,
      flooringType: _flooringType!,
      isForRent: _isForRent,
      location: Location(
        country: _countryController.text,
        governorate: _governorateController.text,
        city: _cityController.text,
        quarter: _quarterController.text,
        street: _streetController.text,
        lat: _pickedLocation!.latitude,
        lon: _pickedLocation!.longitude,
      ),
      propertyImage: _mainImage!.path,
      propertyImages: _propertyImages.map((e) => e.path).toList(),
      firstImage: _mainImage!.path,
    );

    final result = await userDio.uploadProperty(property);

    result.fold(
      (failure) => showErrorSnackbar(failure),
      (success) => showSuccessSnackbar(success),
    );

    debug.i("Property submitted: ${property.title}");
    showSuccessSnackbar(
      "Property submitted successfully!",
    );
  }

  Widget miniMap() {
    if (_pickedLocation == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _pickedLocation!,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5),
                        ),
                        child: Icon(
                          Icons.circle,
                          size: 28.r,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Selected: ${_pickedLocation!.latitude.toStringAsFixed(6)}, ${_pickedLocation!.longitude.toStringAsFixed(6)}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload new Property"),
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Overview", style: AppTextStyles.h20semi),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                    labelText: 'Title', labelStyle: AppTextStyles.h16regular),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _roomsController,
                      decoration: const InputDecoration(labelText: 'Rooms'),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _bathroomsController,
                      decoration: const InputDecoration(labelText: 'Bathrooms'),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _areaController,
                      decoration: const InputDecoration(labelText: 'Area (m²)'),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text("Facilities", style: AppTextStyles.h20semi),
              const SizedBox(height: 5),
              SwitchListTile(
                title: const Text('Is Floor'),
                value: _isFloor,
                onChanged: (val) => setState(() => _isFloor = val),
              ),
              if (_isFloor)
                TextFormField(
                  controller: _floorNumberController,
                  decoration: const InputDecoration(labelText: 'Floor Number'),
                  keyboardType: TextInputType.number,
                  validator: (val) => _isFloor && (val == null || val.isEmpty)
                      ? 'Required'
                      : null,
                ),
              SwitchListTile(
                title: const Text('Has Garage'),
                value: _hasGarage,
                onChanged: (val) => setState(() => _hasGarage = val),
              ),
              SwitchListTile(
                title: const Text('Has Garden'),
                value: _hasGarden,
                onChanged: (val) => setState(() => _hasGarden = val),
              ),
              SwitchListTile(
                title: const Text('Is For Rent'),
                value: _isForRent,
                onChanged: (val) => setState(() => _isForRent = val),
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _propertyType,
                items: ['Apartment', 'House', 'Villa', 'Studio']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _propertyType = val),
                decoration: const InputDecoration(labelText: 'Property Type'),
                validator: (val) => val == null ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _heatingType,
                items: ['Central', 'Electric', 'Gas', 'None']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _heatingType = val),
                decoration: const InputDecoration(labelText: 'Heating Type'),
                validator: (val) => val == null ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _flooringType,
                items: ['Tile', 'Wood', 'Marble', 'Carpet']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _flooringType = val),
                decoration: const InputDecoration(labelText: 'Flooring Type'),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              Text('Location', style: AppTextStyles.h20semi),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _governorateController,
                decoration: const InputDecoration(labelText: 'Governorate'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _quarterController,
                decoration: const InputDecoration(labelText: 'Quarter'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Street'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              Text('Location On Map', style: AppTextStyles.h20semi),
              CustomButton(
                hint: "Pick Location on Map",
                function: pickLocation,
                width: 270.w,
              ),
              miniMap(),
              const SizedBox(height: 5),
              Text('Gallery', style: AppTextStyles.h20semi),
              CustomButton(
                hint: "Pick Main Image",
                function: pickMainImage,
                width: 270.w,
              ),
              if (_mainImage != null)
                ClipRRect(
                    borderRadius: BorderRadius.circular(5.sp),
                    child: Image.file(_mainImage!,
                        height: 150, fit: BoxFit.cover)),
              CustomButton(
                hint: "Pick Property Images",
                function: pickPropertyImages,
                width: 300.w,
              ),
              if (_propertyImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _propertyImages.length,
                    itemBuilder: (_, i) => Padding(
                      padding: EdgeInsets.all(4.0.r),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.sp),
                        child: Image.file(
                          _propertyImages[i],
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                  child:
                      // ElevatedButton(
                      //   onPressed: submitProperty,
                      //   child: const Text('Submit Property'),
                      // ),

                      CustomButton(
                          hint: "Submit Property",
                          function: () async {
                            submitProperty;
                          })),
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
        title: const Text('Pick Location'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, pickedLocation);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Confirm',
              ),
            ),
          )
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: pickedLocation,
          onTap: (tapPos, point) {
            setState(() {
              pickedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
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
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 28.r,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
///!
