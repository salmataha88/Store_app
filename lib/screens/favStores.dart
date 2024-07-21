import 'package:app2/helper/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/store.dart';
import '../helper/storeProvider.dart';

class FavoriteStoresScreen extends StatelessWidget {
  const FavoriteStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fav Stores',
          style: TextStyle(
            color: Color.fromARGB(255, 247, 242, 242),
            fontWeight: FontWeight.bold,
            fontSize: 25,
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
            final favoriteStores = storeProvider.favoriteStores;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: favoriteStores.length,
                      itemBuilder: (context, index) {
                        final store = favoriteStores[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 241, 242),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(store.name),
                            subtitle: Text('Address: ${store.address}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
