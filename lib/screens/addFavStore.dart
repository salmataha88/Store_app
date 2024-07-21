import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/store.dart';
import '../helper/bottom_navbar.dart';
import '../helper/storeProvider.dart';

class AddFavStore extends StatelessWidget {
  const AddFavStore({super.key});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    print("--------User in StoreProvider in add fav : ${storeProvider.currentUser}");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Favorite Stores',
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
                    color: const Color.fromARGB(255, 243, 241, 242), 
                    borderRadius: BorderRadius.circular(15), 
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       ListTile(
                        title: Text(store.name),
                        subtitle: Text('Address: ${store.address}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite) ,
                          onPressed: () {
                            storeProvider.addRemoveFavoriteStores(store.id!);
                          },
                        ),
                      )
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
