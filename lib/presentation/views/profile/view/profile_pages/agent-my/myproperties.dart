import 'dart:convert';
import 'package:easyrent/core/constants/utils/pages/nodata_page.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/agent-my/widgets/mypropertyCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProperties extends StatefulWidget {
  const MyProperties({super.key});

  @override
  State<MyProperties> createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  late Future<List<PropertyModel>> propertiesFuture;

  @override
  void initState() {
    super.initState();
    propertiesFuture = fetchProperties();
  }

  Future<List<PropertyModel>> fetchProperties() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      //TODO
      Uri.parse('https://9f7fa8d46ede.ngrok-free.app/properties-on/my'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => PropertyModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load properties (${response.statusCode})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PropertyModel>>(
        future: propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: noDataPage()
                // Text('Error: ${snapshot.error}')
                );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No properties found'));
          }

          final properties = snapshot.data!;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return MyPropertyCard(property: property);
            },
          );
        },
      ),
    );
  }
}
