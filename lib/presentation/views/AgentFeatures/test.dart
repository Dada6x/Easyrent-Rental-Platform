import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/button.dart';
import 'package:easyrent/main.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UploadHomesPage extends StatefulWidget {
  const UploadHomesPage({super.key});

  @override
  State<UploadHomesPage> createState() => _UploadHomesPageState();
}

class _UploadHomesPageState extends State<UploadHomesPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();

  // Dropdown selections
  String? _selectedHeatingType;
  String? _selectedFlooringType;
  String? _selectedPropertyType;

  // Map location
  LatLng _pickedLocation = const LatLng(0, 0);

  // Boolean values
  bool _isForRent = true;
  bool _hasGarage = false;
  bool _hasGarden = false;
  bool _isFloor = false;

  final Dio _dio = Dio();

  // Dropdown options
  final List<String> heatingTypes = ['Central', 'Gas', 'Electric', 'None'];
  final List<String> flooringTypes = ['Wood', 'Tile', 'Carpet', 'Concrete'];
  final List<String> propertyTypes = ['Apartment', 'Villa', 'House', 'Studio'];

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerPage(initialLocation: _pickedLocation),
      ),
    );
    if (result != null) {
      setState(() {
        _pickedLocation = result;
      });
    }
  }

  Future<void> _submitProperty() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> data = {
      "title": _titleController.text,
      "description": _descriptionController.text,
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
      "heatingType": _selectedHeatingType ?? '',
      "flooringType": _selectedFlooringType ?? '',
      "propertyType": _selectedPropertyType ?? '',
      "isFloor": _isFloor,
      "agencyId": 2,
    };

    debug.i(data);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? 'YOUR_FALLBACK_TOKEN_HERE';

    try {
      final response = await _dio.post(
        'https://83b08d2bbc5a.ngrok-free.app/properties-on/',
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
        _formKey.currentState!.reset();
        setState(() {
          _pickedLocation = LatLng(0, 0);
          _selectedHeatingType = null;
          _selectedFlooringType = null;
          _selectedPropertyType = null;
          _isForRent = true;
          _hasGarage = false;
          _hasGarden = false;
          _isFloor = false;
        });
      } else {
        debug.i(response.data);
      }
    } catch (e, s) {
      debug.i(e);
      debug.i(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Property")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (val) => val!.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (val) => val!.isEmpty ? "Enter description" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price \$"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter price" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _roomsController,
                      decoration: const InputDecoration(labelText: "Rooms"),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? "Enter rooms" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _bathroomsController,
                      decoration: const InputDecoration(labelText: "Bathrooms"),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val!.isEmpty ? "Enter bathrooms" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _areaController,
                      decoration: const InputDecoration(labelText: "Area (m²)"),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? "Enter area" : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _floorNumberController,
                decoration: const InputDecoration(labelText: "Floor Number"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter floor number" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedHeatingType,
                hint: const Text("Select Heating Type"),
                items: heatingTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedHeatingType = val),
                validator: (val) => val == null ? "Select heating type" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedFlooringType,
                hint: const Text("Select Flooring Type"),
                items: flooringTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedFlooringType = val),
                validator: (val) => val == null ? "Select flooring type" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedPropertyType,
                hint: const Text("Select Property Type"),
                items: propertyTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedPropertyType = val),
                validator: (val) => val == null ? "Select property type" : null,
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(_pickedLocation == LatLng(0, 0)
                        ? "Select Location"
                        : "Location: ${_pickedLocation.latitude.toStringAsFixed(5)}, ${_pickedLocation.longitude.toStringAsFixed(5)}"),
                    trailing: Iconify(Ph.map_pin_line_bold),
                    onTap: _pickLocation,
                  ),
                  const SizedBox(height: 8),
                  if (_pickedLocation != LatLng(0, 0))
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 150,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: _pickedLocation,
                            initialZoom: 15,
                            // interactiveFlags: InteractiveFlag.none, // non-interactive
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: const ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    child: Icon(Icons.circle,
                                        size: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SwitchListTile(
                title: const Text("For Rent"),
                value: _isForRent,
                onChanged: (val) => setState(() => _isForRent = val),
              ),
              SwitchListTile(
                title: const Text("Has Garage"),
                value: _hasGarage,
                onChanged: (val) => setState(() => _hasGarage = val),
              ),
              SwitchListTile(
                title: const Text("Has Garden"),
                value: _hasGarden,
                onChanged: (val) => setState(() => _hasGarden = val),
              ),
              SwitchListTile(
                title: const Text("Is Floor"),
                value: _isFloor,
                onChanged: (val) => setState(() => _isFloor = val),
              ),
              const SizedBox(height: 20),
              CustomButton(hint: "Submit Property", function: _submitProperty)
            ],
          ),
        ),
      ),
    );
  }
}

// MapPickerPage
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
        title: const Text('Pick Location'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, pickedLocation),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Confirm', style: TextStyle(color: blue)),
            ),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(33.5138, 36.2765),
          initialZoom: 15.0,
          onTap: (tapPosition, point) {
            setState(() => pickedLocation = point);
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
                width: 40,
                height: 40,
                child: Icon(
                  Icons.location_on,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
