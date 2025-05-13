// ignore_for_file: deprecated_member_use, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenImageGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageGallery({
    Key? key,
    required this.images,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<FullScreenImageGallery> createState() => _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<FullScreenImageGallery> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Restore UI when leaving the gallery
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Main image viewer with zoom capability
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: Image.asset(
                      widget.images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 100,
                              color: Colors.white60,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Show UI controls conditionally
            if (_showControls)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      // App bar with close button
                      AppBar(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: Text(
                          'Image ${_currentIndex + 1} of ${widget.images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        actions: [
                          // Optional: Add download or share buttons if needed
                        ],
                      ),

                      // Spacer to push the controls to the bottom
                      const Spacer(),

                      // Bottom controls with page indicators
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.black.withOpacity(0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Previous image button
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                              onPressed: _currentIndex > 0
                                  ? () {
                                      _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  : null,
                            ),

                            // Page indicators
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  widget.images.length,
                                  (index) => Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentIndex == index
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Next image button
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                              onPressed: _currentIndex <
                                      widget.images.length - 1
                                  ? () {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
