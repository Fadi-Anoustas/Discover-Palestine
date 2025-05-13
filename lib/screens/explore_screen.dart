// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palestine_cities_app/models/city.dart';

import 'package:palestine_cities_app/widgets/city_card.dart';
import 'package:palestine_cities_app/screens/city_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  final List<City> cities;
  final Function(City, bool) onFavoriteToggle;

  const ExploreScreen({
    super.key,
    required this.cities,
    required this.onFavoriteToggle,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late List<City> _filteredCities;
  bool _isGridView = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredCities = widget.cities;
  }

  @override
  void didUpdateWidget(ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update filtered cities when the parent widget updates
    _filterCities();
  }

  void _filterCities() {
    if (_searchQuery.isEmpty) {
      _filteredCities = widget.cities;
    } else {
      _filteredCities = widget.cities.where((city) {
        return city.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            city.arabicName.contains(_searchQuery) ||
            city.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Palestine'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
      body: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildListView() {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    
    return _filteredCities.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: EdgeInsets.all(screenWidth < 600 ? 16 : 24),
            itemCount: _filteredCities.length,
            itemBuilder: (context, index) {
              final city = _filteredCities[index];
              return CityCard(
                city: city,
                onTap: () => _navigateToCityDetails(city),
                onFavoriteToggle: (isFavorite) {
                  widget.onFavoriteToggle(city, isFavorite);
                },
                // Pass the screen width to the CityCard
                screenWidth: screenWidth,
              );
            },
          );
  }

  Widget _buildGridView() {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Define responsive grid parameters
    final crossAxisCount = screenWidth < 600 ? 2 : 
                          (screenWidth < 1200 ? 3 : 4);
    
    // Adjust aspect ratio based on screen size
    // This will make the cards taller on larger screens
    final childAspectRatio = screenWidth < 600 ? 0.65 : 
                            (screenWidth < 1200 ? 0.75 : 0.8);
    
    return _filteredCities.isEmpty
        ? _buildEmptyState()
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: _filteredCities.length,
            itemBuilder: (context, index) {
              final city = _filteredCities[index];
              return _buildGridCard(city);
            },
          );
  }

  Widget _buildGridCard(City city) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate image height based on screen size
    final imageHeight = screenWidth < 600 ? 200.0 : 
                       (screenWidth < 1200 ? 220.0 : 240.0);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToCityDetails(city),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // City image - responsive height
                Hero(
                  tag: 'city_image_${city.id}_0',
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Image.asset(
                      city.images[0],
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          child: const Center(
                            child: Icon(Icons.image,
                                size: 30, color: Colors.white70),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Black bar with city name
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      city.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          widget.onFavoriteToggle(city, !city.isFavorite),
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Icon(
                          city.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: city.isFavorite ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.arabicName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    city.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No cities found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filteredCities = widget.cities;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Search'),
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

  void _navigateToCityDetails(City city) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CityDetailsScreen(city: city),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Cities'),
        content: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _filterCities();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Enter city name or keyword',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _filterCities();
            },
            child: const Text('SEARCH'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Palestine Cities'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Palestine Cities App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'This application provides information about cities in Palestine, '
              'their history, landmarks, and cultural significance. '
              'Explore the rich heritage and beauty of Palestinian cities through this app.',
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
