import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/store.dart';
import '../helper/bottom_navbar.dart';
import '../helper/storeProvider.dart';

class AddFavStores extends StatelessWidget {
  String userEmail;
  AddFavStores({super.key, required this.userEmail});
  

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Favorite Stores'),
      ),
      body: FutureBuilder<List<Store>>(
        future: storeProvider.getAllStores(), // Fetch all stores from the database
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
                return ListTile(
                  title: Text(store.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: ${store.address}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      _addToFavorites(context, store);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _addToFavorites(BuildContext context, Store store) {
    // Implement functionality to add the store to favorites
    // For example:
    // favoriteStoreProvider.addFavoriteStore(store);
    
    // Show a snackbar indicating that the store has been added to favorites
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to favorites: ${store.name}')),
    );
  }
}
