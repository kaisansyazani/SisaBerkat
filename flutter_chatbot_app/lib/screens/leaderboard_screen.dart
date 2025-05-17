import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_drawer.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard = [
    {'name': 'Alice', 'amount': 1100},
    {'name': 'Bob', 'amount': 1050},
    {'name': 'John Doe', 'amount': 980},
    {'name': 'Daisy', 'amount': 950},
  ];

  LeaderboardScreen({super.key});

  String getMedal(int index) {
    switch (index) {
      case 0:
        return '🥇';
      case 1:
        return '🥈';
      case 2:
        return '🥉';
      default:
        return '#${index + 1}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8E1), // Light gold
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD700), // Gold
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Leaderboard",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final player = leaderboard[index];
                final isUser = player['name'] == 'John Doe';

                return Container(
                  decoration: BoxDecoration(
                    color: isUser ? Color(0xFFFFECB3) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFFFD54F), // Gold tone
                      child: Text(
                        getMedal(index),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      player['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isUser ? Colors.deepOrange : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      "Total Saved (MYR)",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    trailing: Text(
                      "RM ${player['amount']}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
