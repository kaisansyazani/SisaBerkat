import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String? currentRoute;

  @override
  Widget build(BuildContext context) {
    currentRoute = ModalRoute.of(context)?.settings.name;

    final routes = [
      '/multiAI',
      '/datavisual',
      '/mainmenu', // Marketplace
      '/donation',
      '/userchat'
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFDCE8D0), // Main theme background
      selectedItemColor: const Color(0xFFA4C49D), // Soft green for selected icons
      unselectedItemColor: Colors.black54,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      showUnselectedLabels: true,
      currentIndex: _getCurrentIndex(currentRoute), // This needs to be handled properly in your code
      onTap: (index) {
        if (index >= 0 && index < routes.length && currentRoute != routes[index]) {
          // Update the current route and navigate to the selected route
          setState(() {
            currentRoute = routes[index]; // Update current route
          });
          Navigator.pushNamed(
            context,
            routes[index], // Navigate to the correct route
          );
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy),
          label: 'AI',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Data',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFA4C49D), // Soft green circle
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.store, color: Colors.white),
          ),
          label: 'Market',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism),
          label: 'Donate',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
      ],
    );
  }

  int _getCurrentIndex(String? route) {
    switch (route) {
      case '/multiAI':
        return 0;
      case '/datavisual':
        return 1;
      case '/mainmenu':
        return 2;
      case '/donation':
        return 3;
      case '/userchat':
        return 4;
      default:
        return 0;
    }
  }
}
