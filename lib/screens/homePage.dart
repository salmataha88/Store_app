import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/store.dart';
import '../helper/storeProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Stores'),
      ),
      body: FutureBuilder<List<Store>>(
        future: storeProvider.getAllStores(), // Fetch all stores from the database
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final stores = snapshot.data ?? [];
            return ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 227, 218, 218), // Gray background color
                    borderRadius: BorderRadius.circular(15), // Adjust the radius to change the curvature
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Address: ${store.address}'),
                      Text('Latitude: ${store.latitude}'),
                      Text('Longitude: ${store.longitude}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
