import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class Gamification extends StatelessWidget {
  const Gamification({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFd8f3dc), // pastel green background
        appBar: AppBar(
          backgroundColor: Colors.white, // changed to white
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset(
              'assets/logo.png', // Your logo asset path
              height: 40,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Virtual Farm'),
              Tab(text: 'Leaderboard'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VirtualFarmView(),
            LeaderboardView(),
          ],
        ),        bottomNavigationBar: const BottomNavBar(), // 👈 Add your bottom nav bar here

      ),
    );
  }
}

class VirtualFarmView extends StatelessWidget {
  const VirtualFarmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/farm.png', // Replace with your farm image asset
          height: 200,
        ),
        const SizedBox(height: 10),
        const Text(
          '🪙 0',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Plant your own farm!',
            style: TextStyle(color: Colors.white), // Text color changed to white
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Upcoming Goals', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Goal: Upload at least 3 photos of surplus or ugly food in a week\nReward: +50 coins'),
                SizedBox(height: 10),
                Text('Goal: Transform rescued produce into a product (e.g., jam, dried chips) and list it on the marketplace\nReward: +150 coins'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  final topUsers = const [
    {'name': 'Howie', 'score': 2430, 'image': 'assets/cina.jpeg'},
    {'name': 'Izal', 'score': 1847, 'image': 'assets/izal.jpeg'},
    {'name': 'Masrie', 'score': 1674, 'image': 'assets/mas.jpeg'},
  ];

  final List<Map<String, dynamic>> otherUsers = const [
    {'name': 'Izal', 'score': 1847, 'image': 'assets/izal.jpeg'},
    {'name': 'Masrie', 'score': 1674, 'image': 'assets/mas.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTopUser('Howie', 'assets/cina.jpeg', 1847),
            _buildTopUser('Hanim', 'assets/hanim.jpeg', 2430, isWinner: true),
            _buildTopUser('Sabrina', 'assets/sab.jpeg', 1674),
          ],
        ),
        const SizedBox(height: 20),
        ...otherUsers.map((user) => ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(user['image']),
              ),
              title: Text(user['name']!),
              subtitle: const Text('@username'),
              trailing: Text(
                user['score'].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
      ],
    );
  }

  Widget _buildTopUser(String name, String imagePath, int score, {bool isWinner = false}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: isWinner ? 40 : 30,
        ),
        if (isWinner)
          const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(score.toString()),
      ],
    );
  }
}
