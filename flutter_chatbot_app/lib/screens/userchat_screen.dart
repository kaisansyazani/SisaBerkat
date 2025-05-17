import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_drawer.dart';
import 'bottom_nav_bar.dart';
import 'UserChatPage.dart';

class UserChatScreen extends StatefulWidget {
  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _users = [
    {'name': 'Haznor', 'avatar': 'assets/haz.jpeg', 'isOnline': true},
    {'name': 'Fahmy', 'avatar': 'assets/fahmi.jpeg', 'isOnline': false},
    {'name': 'Izal', 'avatar': 'assets/izal.jpeg', 'isOnline': true},
  ];

  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

Widget buildUserItem(String name, String avatar, bool isOnline) {
  return ListTile(
    leading: Stack(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(avatar),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: isOnline ? Colors.green : Colors.grey,
          ),
        ),
      ],
    ),
    title: Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
    trailing: Icon(Icons.chat_bubble_outline, color: Colors.black),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserChatPage(
            userName: name,  // Pass userName
            avatar: avatar,  // Pass avatar
          ),
        ),
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCE8D0),
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_bounceAnimation.value),
                  child: child,
                );
              },
              child: Text("💬", style: TextStyle(fontSize: 26, color: Colors.black)),
            ),
            SizedBox(width: 8),
            Text(
              "Chats",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: _users.map((user) => buildUserItem(user['name']!, user['avatar']!, user['isOnline']!)).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

