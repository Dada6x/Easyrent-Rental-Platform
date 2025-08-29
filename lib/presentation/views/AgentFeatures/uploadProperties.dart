import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easyrent/core/constants/utils/button.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      setState(() => _mainImage = File(pickedFile.path));
    }
  }

  Future<void> pickPropertyImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(
          () => _propertyImages.addAll(pickedFiles.map((e) => File(e.path))));
    }
  }

  Future<void> pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerPage(
          initialLocation: _pickedLocation ?? const LatLng(34.8021, 38.9968),
        ),
      ),
    );
    if (result != null && result is LatLng) {
      setState(() => _pickedLocation = result);
    }
  }

  Future<void> submitProperty() async {
    if (!_formKey.currentState!.validate()) {
      showSnackbarWithContext("Please fill all required fields", context,
          isTop: true);
      return;
    }
    if (_propertyType == null ||
        _heatingType == null ||
        _flooringType == null) {
      showSnackbarWithContext("Please select all dropdown options", context,
          isTop: true);
      return;
    }
    if (_pickedLocation == null) {
      showSnackbarWithContext("Please select a location", context, isTop: true);
      return;
    }
    if (_mainImage == null) {
      showSnackbarWithContext("Please pick a main image", context, isTop: true);
      return;
    }

    try {
      Dio dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // 1️⃣ Create property
      final propertyData = {
        "title": _titleController.text,
        "description": _descriptionController.text,
        "isForRent": _isForRent,
        "price": double.parse(_priceController.text),
        "pointsDto": {
          "lat": _pickedLocation!.latitude,
          "lon": _pickedLocation!.longitude,
        },
        "rooms": int.parse(_roomsController.text),
        "bathrooms": int.parse(_bathroomsController.text),
        "area": double.parse(_areaController.text),
        "floorNumber": _isFloor ? int.parse(_floorNumberController.text) : 0,
        "hasGarage": _hasGarage,
        "hasGarden": _hasGarden,
        "heatingType": _heatingType,
        "flooringType": _flooringType,
        "propertyType": _propertyType,
        "isFloor": _isFloor,
        "agencyId": AppSession().user!.id,
      };

      final response = await dio.post(
        "https://83b08d2bbc5a.ngrok-free.app/properties-on/",
        data: propertyData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      final propertyId = response.data.toString();
      debug.i("✅ Property created with ID: $propertyId");

      // 2️⃣ Upload main image
      final mainFormData = FormData.fromMap({
        "property-image": await MultipartFile.fromFile(
          _mainImage!.path,
          filename: _mainImage!.path.split("/").last,
        )
      });

      // await dio.post(
      //   "https://83b08d2bbc5a.ngrok-free.app/properties-http-media/upload-img/$propertyId",
      //   data: mainFormData,
      //   options: Options(
      //     headers: {
      //       "Authorization": "Bearer $token",
      //       "Content-Type": "multipart/form-data",
      //     },
      //   ),
      // );

      // 3️⃣ Upload multiple images
      if (_propertyImages.isNotEmpty) {
        final List<MultipartFile> files = [];
        for (var img in _propertyImages) {
          files.add(await MultipartFile.fromFile(img.path,
              filename: img.path.split("/").last));
        }

        final multipleFormData = FormData.fromMap({"property-images": files});

        // await dio.post(
        //   "https://83b08d2bbc5a.ngrok-free.app/properties-http-media/upload-multiple-img/$propertyId",
        //   data: multipleFormData,
        //   options: Options(
        //     headers: {
        //       "Authorization": "Bearer $token",
        //       "Content-Type": "multipart/form-data",
        //     },
        //   ),
        // );
      }

      showSuccessSnackbar("Property uploaded successfully!");
    } catch (e, s) {
      debugPrint("❌ Error uploading property: $e");
      debug.i(s);
      showSnackbarWithContext("Upload failed, please try again", context,
          isTop: true);
    }
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
              options:
                  MapOptions(initialCenter: _pickedLocation!, initialZoom: 15),
              children: [
                TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c']),
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
                        child: Icon(Icons.circle,
                            size: 28.r,
                            color: Theme.of(context).colorScheme.primary),
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
      appBar: AppBar(title: const Text('Upload New Property')),
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
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          controller: _roomsController,
                          decoration: const InputDecoration(labelText: 'Rooms'),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                          controller: _bathroomsController,
                          decoration:
                              const InputDecoration(labelText: 'Bathrooms'),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                          controller: _areaController,
                          decoration:
                              const InputDecoration(labelText: 'Area (m²)'),
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 30),
              Text("Facilities", style: AppTextStyles.h20semi),
              SwitchListTile(
                  title: const Text('Is Floor'),
                  value: _isFloor,
                  onChanged: (val) => setState(() => _isFloor = val)),
              if (_isFloor)
                TextFormField(
                    controller: _floorNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Floor Number'),
                    keyboardType: TextInputType.number,
                    validator: (val) => _isFloor && (val == null || val.isEmpty)
                        ? 'Required'
                        : null),
              SwitchListTile(
                  title: const Text('Has Garage'),
                  value: _hasGarage,
                  onChanged: (val) => setState(() => _hasGarage = val)),
              SwitchListTile(
                  title: const Text('Has Garden'),
                  value: _hasGarden,
                  onChanged: (val) => setState(() => _hasGarden = val)),
              SwitchListTile(
                  title: const Text('Is For Rent'),
                  value: _isForRent,
                  onChanged: (val) => setState(() => _isForRent = val)),
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
              CustomButton(
                  hint: "Pick Location on Map",
                  function: pickLocation,
                  width: 270.w),
              miniMap(),
              const SizedBox(height: 5),
              Text('Gallery', style: AppTextStyles.h20semi),
              CustomButton(
                  hint: "Pick Main Image",
                  function: pickMainImage,
                  width: 270.w),
              if (_mainImage != null)
                ClipRRect(
                    borderRadius: BorderRadius.circular(5.sp),
                    child: Image.file(_mainImage!,
                        height: 150, fit: BoxFit.cover)),
              CustomButton(
                  hint: "Pick Property Images",
                  function: pickPropertyImages,
                  width: 300.w),
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
                                child: Image.file(_propertyImages[i],
                                    width: 100, fit: BoxFit.cover))))),
              const SizedBox(height: 20),
              Center(
                  child: ElevatedButton(
                      onPressed: submitProperty,
                      child: const Text('Submit Property'))),
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
                    size: 28.r, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
