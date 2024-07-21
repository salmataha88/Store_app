import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../database/store.dart';
import '../helper/bottom_navbar.dart';
import '../helper/storeProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, });

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Stores',
          style: TextStyle(color: Color.fromARGB(255, 247, 242, 242) ,
          fontWeight:FontWeight.bold ,
          fontSize:25 
          ), 
        ),
        backgroundColor: Colors.blueGrey[700],
      ),
      backgroundColor: Colors.blueGrey[700],
      body: FutureBuilder<List<Store>>(
        future: storeProvider.getAllStores(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                    color: const Color.fromARGB(255, 212, 209, 211), 
                    borderRadius: BorderRadius.circular(15), 
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
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
      bottomNavigationBar:  const BottomNavBar(),
    );
  }
}
