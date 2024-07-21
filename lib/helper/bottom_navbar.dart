import 'package:app2/screens/addFavStore.dart';
import 'package:app2/screens/favStoreByDistance.dart';
import 'package:app2/screens/favStores.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Fav',
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddFavStore()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteStoresScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavSortesByDistanceScreen()),
            );
            break;
          
        }
      },
    );
  }
}
