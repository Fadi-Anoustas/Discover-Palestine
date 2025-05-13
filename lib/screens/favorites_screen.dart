import 'package:flutter/material.dart';
import 'package:palestine_cities_app/models/city.dart';
import 'package:palestine_cities_app/screens/city_details_screen.dart';
// Make sure the file 'city_details_screen.dart' exists and contains the CityDetailsScreen class.
import 'package:palestine_cities_app/widgets/city_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<City> favoriteCities;
  final Function(City, bool) onFavoriteToggle;

  const FavoritesScreen({
    super.key,
    required this.favoriteCities,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
      ),
      body: favoriteCities.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                final city = favoriteCities[index];
                return CityCard(
                  city: city,
                  onTap: () => _navigateToCityDetails(context, city),
                  onFavoriteToggle: (isFavorite) {
                    onFavoriteToggle(city, isFavorite);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorite cities yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add cities to your favorites by tapping the heart icon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.explore),
            label: const Text('Explore Cities'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCityDetails(BuildContext context, City city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetailsScreen(city: city),
      ),
    );
  }
}