import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easyrent/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _heatingTypeController = TextEditingController();
  final TextEditingController _flooringTypeController = TextEditingController();
  final TextEditingController _propertyTypeController = TextEditingController();

  // Boolean values
  bool _isForRent = true;
  bool _hasGarage = false;
  bool _hasGarden = false;
  bool _isFloor = false;

  final Dio _dio = Dio();

  Future<void> _submitProperty() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> data = {
      "title": _titleController.text.toString(),
      "description": _descriptionController.text.toString(),
      "isForRent": _isForRent,
      "price": int.tryParse(_priceController.text)?? 0,
      "pointsDto": {
        "lat": double.tryParse(_latController.text) ?? 0.0,
        "lon": double.tryParse(_lonController.text) ?? 0.0,
      },
      "rooms": int.tryParse(_roomsController.text) ?? 0,
      "bathrooms": int.tryParse(_bathroomsController.text) ?? 0,
      "area": int.tryParse(_areaController.text) ?? 0,
      "floorNumber": int.tryParse(_floorNumberController.text) ?? 0,
      "hasGarage": _hasGarage,
      "hasGarden": _hasGarden,
      "heatingType": _heatingTypeController.text.toString(),
      "flooringType": _flooringTypeController.text.toString(),
      "propertyType": _propertyTypeController.text.toString(),
      "isFloor": _isFloor,
      "agencyId": 2, // keep fixed for now
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
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter price" : null,
              ),
              TextFormField(
                controller: _latController,
                decoration: const InputDecoration(labelText: "Latitude"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter latitude" : null,
              ),
              TextFormField(
                controller: _lonController,
                decoration: const InputDecoration(labelText: "Longitude"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter longitude" : null,
              ),
              TextFormField(
                controller: _roomsController,
                decoration: const InputDecoration(labelText: "Rooms"),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? "Enter number of rooms" : null,
              ),
              TextFormField(
                controller: _bathroomsController,
                decoration: const InputDecoration(labelText: "Bathrooms"),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? "Enter number of bathrooms" : null,
              ),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: "Area"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter area" : null,
              ),
              TextFormField(
                controller: _floorNumberController,
                decoration: const InputDecoration(labelText: "Floor Number"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter floor number" : null,
              ),
              TextFormField(
                controller: _heatingTypeController,
                decoration: const InputDecoration(labelText: "Heating Type"),
                validator: (val) => val!.isEmpty ? "Enter heating type" : null,
              ),
              TextFormField(
                controller: _flooringTypeController,
                decoration: const InputDecoration(labelText: "Flooring Type"),
                validator: (val) => val!.isEmpty ? "Enter flooring type" : null,
              ),
              TextFormField(
                controller: _propertyTypeController,
                decoration: const InputDecoration(labelText: "Property Type"),
                validator: (val) => val!.isEmpty ? "Enter property type" : null,
              ),
              const SizedBox(height: 10),
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
              ElevatedButton(
                onPressed: _submitProperty,
                child: const Text("Upload Property"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
