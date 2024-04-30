import 'package:app2/helper/show_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/store.dart';
import '../helper/databaseHelper.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({super.key});

  @override
  _AddStoreScreenState createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final TextEditingController _nameController = TextEditingController();
  LatLng? _selectedLocation;

  void _addStore(BuildContext context) async {
    String name = _nameController.text;
    double? latitude = _selectedLocation?.latitude;
    double? longitude = _selectedLocation?.longitude;

    // Validate input fields
    if (name.isEmpty || latitude == null || longitude == null) {
      showSnackBar(context, 'Please fill in all fields');
      return;
    }

    // Create a Store object
    Store store = Store(
      name: name,
      latitude: latitude,
      longitude: longitude,
    );

    // Insert the store into the database
    try {
      await DatabaseHelper.instance.insertStore(store);
      showSnackBar(context, 'Store added successfully');
      
    } catch (e) {
      // Show error message
      showSnackBar(context, 'Failed to add store');
      print('Failed to add store: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Store'),
      ),
      body: Column(
        children: [
          Container(
            height: 300, // Specify the height of the map container
            child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(26.8206, 30.8025), // Egypt coordinates
                  zoom: 6, // Adjust the zoom level as needed
                ),
                onTap: (LatLng latLng) {
                  setState(() {
                    _selectedLocation = latLng;
                  });
                },
                markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selected-location'),
                        position: _selectedLocation!,
                      ),
                    }
                  : {},
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Store Name'),
            ),
          ),
          ElevatedButton(
            onPressed: () => _addStore(context),
            child: const Text('Add Store'),
          ),
        ],
      ),
    );
  }
}
