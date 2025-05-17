import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'UserData.dart'; // <-- ensure this contains selectedIncome
import 'app_drawer.dart';
import 'privacy_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedIncome = UserData.selectedIncome;

  void _showIncomeRangeDialog() {
    final List<String> incomeRanges = [
      for (int i = 1000; i <= 10000; i += 1000)
        'RM ${i.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}+',
      'RM 10,001 - 12,000',
      'RM 13,000 - 15,000',
      'RM 15,000+',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Color(0xFFFFF8E1),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Select Your Income Range",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: incomeRanges.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              incomeRanges[index],
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            onTap: () async {
                              final selected = incomeRanges[index];
                              setState(() {
                                selectedIncome = selected;
                                UserData.selectedIncome = selectedIncome;
                              });

                              try {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  await FirebaseFirestore.instance
                                      .collection('userdata')
                                      .doc(user.uid)
                                      .update({'range': selected});
                                }
                              } catch (e) {
                                print("Error updating income range: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to update income range.')),
                                );
                              }

                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                context,
                                '/mainmenu',
                                arguments: selectedIncome,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8E1),
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Color(0xFFFFD700),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Color(0xFFFFD700)),
                  title: Text("Account", style: GoogleFonts.poppins(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.lock, color: Color(0xFFFFD700)),
                  title: Text("Privacy", style: GoogleFonts.poppins(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacySettingsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: Color(0xFFFFD700)),
                  title: Text("Notifications", style: GoogleFonts.poppins(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.help, color: Color(0xFFFFD700)),
                  title: Text("Help & Support", style: GoogleFonts.poppins(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Color(0xFFFFD700)),
                  title: Text("Income Range", style: GoogleFonts.poppins(fontSize: 16)),
                  subtitle: Text(
                    selectedIncome,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: Icon(Icons.edit, size: 16),
                  onTap: _showIncomeRangeDialog,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
