import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          _buildMenuItems(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        image: const DecorationImage(
          image: AssetImage('assets/images/palestine_banner.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black38,
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: FlutterLogo(size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            'Palestine Cities',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Explore the beauty and history',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Explore All Cities'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () {
              Navigator.pop(context);
              _showComingSoonSnackBar(context, 'History');
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              _showComingSoonSnackBar(context, 'Gallery');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Palestine'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showComingSoonSnackBar(context, 'Settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Feedback'),
            onTap: () {
              Navigator.pop(context);
              _showComingSoonSnackBar(context, 'Help & Feedback');
            },
          ),
        ],
      ),
    );
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Palestine'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Palestine: Land and Heritage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Palestine is a region in the Middle East, known for its rich history, '
                'cultural heritage, and significant religious sites. Palestine '
                'has a diverse landscape that includes the Mediterranean coastline, '
                'mountains, and the Dead Sea, the lowest point on Earth.',
              ),
              SizedBox(height: 12),
              Text(
                'This app showcases various Palestinian cities, their landmarks, '
                'history, and cultural significance. Our goal is to highlight '
                'the beauty, resilience, and heritage of these cities.',
              ),
              SizedBox(height: 16),
              Text(
                'App Version 1.0.0',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
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