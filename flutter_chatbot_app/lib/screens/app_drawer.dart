import 'package:flutter/material.dart';
import 'package:flutter_chatbot_app/screens/gamification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'main_menu_screen.dart';
import 'image.dart';
class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = 'Welcome!';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final name = snapshot.data()?['name'];
      if (name != null) {
        setState(() {
          userName = name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: const Color(0xFFDCE8D0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFDCE8D0),
                  child: Icon(Icons.person, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hello, $userName',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _buildTile(
            context,
            icon: Icons.home,
            label: 'Home',
            route: '/mainmenu',
            builder: () => MainMenuScreen(),
          ),
          _buildTile(
            context,
            icon: Icons.emoji_events,
            label: 'Forum',
            route: '/forum',
          ),
          _buildTile(
            context,
            icon: Icons.settings,
            label: 'Settings',
            route: '/settings',
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black87),
            title: Text('Profile', style: GoogleFonts.poppins(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gamepad, color: Colors.black87),
            title: Text('Gamification', style: GoogleFonts.poppins(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Gamification()),
              );
            },
          ),
           ListTile(
  leading: const Icon(Icons.image, color: Colors.black87),
  title: Text('Image Analysis', style: GoogleFonts.poppins(fontSize: 16)),
  onTap: () {
    Navigator.pop(context);  // Close the drawer or current screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageAnalysisScreen()),  // Navigate to the Image Analysis Screen
    );
  },
),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black87),
            title: Text('Logout', style: GoogleFonts.poppins(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
          
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon,
      required String label,
      required String route,
      Widget Function()? builder}) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(label, style: GoogleFonts.poppins(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        if (currentRoute != route && builder != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => builder()),
          );
        } else if (currentRoute != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
