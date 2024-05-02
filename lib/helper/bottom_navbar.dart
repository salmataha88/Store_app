import 'package:app2/screens/addFavStores.dart';
import 'package:app2/screens/addStore.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
 String userEmail;
  BottomNavBar({required this.userEmail});


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Store',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorite Stores',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          label: 'Distance',
        ),
      ],
      onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to the add store screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AddFavStores(userEmail : this.userEmail) ),
              );
              break;
            case 1:
              // Navigate to the favorite stores screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStoreScreen()),
              );
              break;
            case 2:
              // Navigate to the distance screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStoreScreen()),
              );
              break;
          }
        },
      );
  }
}
