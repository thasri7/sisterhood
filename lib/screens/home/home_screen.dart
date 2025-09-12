import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DiscoverScreen(),
    const GroupsScreen(),
    const EventsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFE91E63),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore,
              size: 80,
              color: Color(0xFFE91E63),
            ),
            SizedBox(height: 20),
            Text(
              'Discover Amazing Women',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Find women with similar interests\nand connect with your community',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement create group
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group,
              size: 80,
              color: Color(0xFFE91E63),
            ),
            SizedBox(height: 20),
            Text(
              'Join Groups',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Connect with women who share\nyour passions and interests',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement create event
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event,
              size: 80,
              color: Color(0xFFE91E63),
            ),
            SizedBox(height: 20),
            Text(
              'Local Events',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Discover and attend events\nin your local community',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFE91E63),
                  child: user.profileImageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            user.profileImageUrl!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                ),
                const SizedBox(height: 20),
                
                // Name
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.location,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Bio
                if (user.bio != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.bio!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Interests
                const Text(
                  'Interests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                  ),
                ),
                const SizedBox(height: 10),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.interests.map((interest) {
                    return Chip(
                      label: Text(interest),
                      backgroundColor: const Color(0xFFE91E63).withOpacity(0.1),
                      labelStyle: const TextStyle(
                        color: Color(0xFFE91E63),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                
                // Sign Out Button
                ElevatedButton(
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false).signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
