// ignore_for_file: avoid_print, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:palestine_cities_app/models/city.dart';

class CityDetailsScreen extends StatefulWidget {
  final City city;

  const CityDetailsScreen({
    super.key,
    required this.city,
  });

  @override
  State<CityDetailsScreen> createState() => _CityDetailsScreenState();
}

class _CityDetailsScreenState extends State<CityDetailsScreen> {
  late PageController _imagePageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate adaptive sizes based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image slider
                  _buildImageSlider(),

                  // City details with responsive padding
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // City name and info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.city.arabicName,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 22,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.city.description,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Additional city details...
                        // (keep your existing detail sections)
                        Text(
                          'About',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.city.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),

                        // Landmarks section
                        Text(
                          'Landmarks',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.city.landmarks.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.place,
                                      color: Colors.redAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.city.landmarks[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Quick facts section
                        Text(
                          'Quick Facts',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildFactRow(context, 'Location',
                                    '${widget.city.latitude.toStringAsFixed(4)}, ${widget.city.longitude.toStringAsFixed(4)}'),
                                const Divider(),
                                _buildFactRow(context, 'Landmarks',
                                    '${widget.city.landmarks.length} famous sites'),
                                const Divider(),
                                _buildFactRow(context, 'Images',
                                    '${widget.city.images.length} photos available'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.arrow_back), // Use consistent green color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildFactRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate image height based on device size and orientation
    final isLandscape = screenWidth > screenHeight;

    // Make images larger on desktop and in portrait mode
    final imageHeight = screenWidth < 600
        ? (isLandscape ? screenHeight * 0.6 : screenHeight * 0.45)
        : (isLandscape ? screenHeight * 0.7 : screenHeight * 0.55);

    return Container(
      height: imageHeight,
      width: double.infinity,
      color: Colors.black.withOpacity(0.05), // Background color for non-filled areas
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main PageView for swiping images
          PageView.builder(
            controller: _imagePageController,
            itemCount: widget.city.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Hero(
                tag: 'city_image_${widget.city.id}_$index',
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Image.asset(
                    widget.city.images[index],
                    fit: BoxFit.contain, // Changed from cover to contain
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
            },
          ),

          // Rest of your existing slider code
          // Left/right navigation arrows
          if (widget.city.images.length > 1)
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left arrow
                  if (_currentImageIndex > 0)
                    GestureDetector(
                      onTap: () {
                        _imagePageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                  // Right arrow
                  if (_currentImageIndex < widget.city.images.length - 1)
                    GestureDetector(
                      onTap: () {
                        _imagePageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Bottom page indicators
          if (widget.city.images.length > 1)
            Positioned(
              bottom: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.city.images.length,
                  (index) => Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      border: Border.all(color: Colors.white54),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
