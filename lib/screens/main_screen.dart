import 'package:flutter/material.dart';
import 'package:palestine_cities_app/models/city.dart';
import 'package:palestine_cities_app/screens/explore_screen.dart';
import 'package:palestine_cities_app/screens/favorites_screen.dart';
import 'package:palestine_cities_app/screens/map_screen.dart';
import 'package:palestine_cities_app/widgets/app_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<City> cities = CitiesData.cities;
  List<City> favoriteCities = [];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _buildScreens();
  }

  void _buildScreens() {
    _screens.clear();
    _screens.addAll([
      ExploreScreen(
        cities: cities,
        onFavoriteToggle: _toggleFavorite,
      ),
      FavoritesScreen(
        favoriteCities: favoriteCities,
        onFavoriteToggle: _toggleFavorite,
      ),
      const MapScreen(),
    ]);
  }

  void _toggleFavorite(City city, bool isFavorite) {
    setState(() {
      final index = cities.indexWhere((c) => c.id == city.id);
      if (index != -1) {
        cities[index] = cities[index].copyWith(isFavorite: isFavorite);
        
        // Update favorites list
        if (isFavorite) {
          if (!favoriteCities.any((c) => c.id == city.id)) {
            favoriteCities.add(cities[index]);
          }
        } else {
          favoriteCities.removeWhere((c) => c.id == city.id);
        }
      }
      
      // Rebuild screens with updated data
      _buildScreens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}