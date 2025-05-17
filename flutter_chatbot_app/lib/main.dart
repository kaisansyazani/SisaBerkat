import 'package:flutter/material.dart';
import 'package:flutter_chatbot_app/screens/addproduct.dart';
import 'package:flutter_chatbot_app/screens/forum_screen.dart';
import 'package:flutter_chatbot_app/screens/multiAI.dart';
import 'package:flutter_chatbot_app/screens/profile_screen.dart';
import 'package:flutter_chatbot_app/screens/userchat_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/data.dart';
import 'screens/main_menu_screen.dart';
import 'screens/gamification.dart';
import 'screens/donation_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/sign_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final String emulatorHost = '10.0.2.2'; // ← Change based on your device

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: false,
    host: '$emulatorHost:8080',
    sslEnabled: false,
  );

  await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFFFFF8E1),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFD700),
          foregroundColor: Colors.black,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFFFF3C0),
          selectedItemColor: Color(0xFFFFD700),
          unselectedItemColor: Colors.black54,
        ),
      ),
      initialRoute: '/',
      routes: {

        
        '/signup': (context) => SignUpScreen(),
        '/': (context) => LoginScreen(),
        '/mainmenu': (context) => MainMenuScreen(), 
        '/leaderboard': (context) => LeaderboardScreen(),
        '/settings': (context) => SettingsScreen(),
         '/multiAI': (context) => MultiAIScreen(),
          '/userchat': (context) => UserChatScreen(),
          '/profile': (context) => ProfileScreen(),
        '/forum': (context) => ForumScreen(),
        '/addproduct': (context) =>AddProduct(),
        '/gamification': (context) =>Gamification(),
        '/donation': (context) => DonationScreen(),
        '/datavisual': (context) => DataVisual(),


       
      },
    );
  }
}
