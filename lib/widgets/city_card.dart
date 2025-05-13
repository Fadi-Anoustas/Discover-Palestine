// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palestine_cities_app/models/city.dart';

class CityCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final Function(bool)? onFavoriteToggle;
  final double? screenWidth; // Add this parameter

  const CityCard({
    super.key,
    required this.city,
    required this.onTap,
    this.onFavoriteToggle,
    this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided screenWidth or get from MediaQuery
    final width = screenWidth ?? MediaQuery.of(context).size.width;
    
    // Calculate responsive image height
    final imageHeight = width < 600 ? 200.0 : 
                       (width < 1200 ? 250.0 : 300.0);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Hero image with responsive height
                Hero(
                  tag: 'city_image_${city.id}',
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          city.images[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              child: const Center(
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.white70),
                              ),
                            );
                          },
                        ),
                        // Add a subtle gradient overlay to ensure text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Overlay for text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                  height: imageHeight,
                  width: double.infinity,
                ),

                // City name and Arabic name
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        city.arabicName,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ],
                  ),
                ),

                // Favorite button
                if (onFavoriteToggle != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onFavoriteToggle!(!city.isFavorite),
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black26,
                          ),
                          child: Icon(
                            city.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: city.isFavorite ? Colors.red : Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Brief description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.description.length > 120
                        ? '${city.description.substring(0, 120)}...'
                        : city.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),

                  // Landmarks preview
                  Row(
                    children: [
                      const Icon(Icons.place, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Key landmarks: ${city.landmarks.take(2).join(", ")}${city.landmarks.length > 2 ? "..." : ""}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),

                  // Explore button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.explore),
                      label: const Text('EXPLORE'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
