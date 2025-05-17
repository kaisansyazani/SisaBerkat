import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_nav_bar.dart'; // Make sure this file exists
import 'addproduct.dart'; // Import the AddProductScreen
import 'app_drawer.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE8D0),
appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  iconTheme: const IconThemeData(color: Colors.black87),
  title: Image.asset(
    'assets/logo.png',
    height: 50,
  ),
  centerTitle: true,
  leading: Builder(
    builder: (context) => IconButton(
      icon: const Icon(Icons.settings, color: Colors.black87),
      onPressed: () {
        Scaffold.of(context).openDrawer(); // Works now
      },
    ),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.add, color: Colors.black87),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProduct()),
        );
      },
    ),
  ],
  bottom: TabBar(
    controller: _tabController,
    labelColor: Colors.black87,
    unselectedLabelColor: Colors.grey,
    indicatorColor: Color(0xFF9BB77D), // Softer green to blend with the theme
    tabs: const [
      Tab(text: 'Buy'),
      Tab(text: 'Sell'),
    ],
  ),
),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBuySection(),
          _buildSellSection(),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      drawer: AppDrawer(), // Replace Drawer with AppDrawer
    );
  }


  // Build the Buy section
  Widget _buildBuySection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Section
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 5),
              ],
            ),
            child: Column(
              children: [
                // Banner Image
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.asset(
    'assets/banner.jpg', // Replace with actual banner image
    height: 120,
    width: double.infinity,
    fit: BoxFit.fill, // Ensure the image stretches to fill the box
  ),
),


              ],
            ),
          ),

          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
_buildCategoryItem('Vegetables', Icons.grass),
_buildCategoryItem('Fruits', Icons.apple),
_buildCategoryItem('Rice', Icons.rice_bowl),
_buildCategoryItem('Leftover Food', Icons.recycling),
_buildCategoryItem('Miscellaneous', Icons.category),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Featured Products Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Featured products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6, // Replace with actual item count
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return _buildFeaturedProduct(index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build the Sell section
  Widget _buildSellSection() {
    return _buildBuySection(); // Reuse Buy section layout
  }

  // Build a category item
  Widget _buildCategoryItem(String name, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueGrey[100],
            child: Icon(icon, size: 30, color: Colors.blueGrey[800]),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
  
  // Build a featured product
Widget _buildFeaturedProduct(int index) {
  // Define the product names, image names, and prices
  List<String> productNames = [
    'Orange', 'Apple', 'Carrot', 'Leftover food', 'Cabbage', 'Miscellaneous'
  ];
  List<String> imageNames = [
    'assets/picture_0.jpg', 'assets/picture_1.jpg', 'assets/picture_2.jpg',
    'assets/picture_3.jpg', 'assets/picture_4.jpg', 'assets/picture_5.jpg'
  ];
  List<String> productPrices = [
    'RM 10.00', 'RM 300.00', 'RM 15.00', 'RM 12.00', 'RM 40.00', 'RM 70.00'
  ];

  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        barrierDismissible: true, // Taps outside will dismiss
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: _buildProductPopup(index),
          );
        },
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imageNames[index],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productPrices[index],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                Text(
                  productNames[index],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                const Text(
                  '1 kg',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildProductPopup(int index) {
  return Center(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/picture_$index.jpg',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow('Address:', 'Sample Street 123'),
          _buildInfoRow('Berat:', '1 kg'),
          _buildInfoRow('Nama:', 'Corn'),
          _buildInfoRow('Phone:', '+123456789'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Add your "Buy" logic here
                },
                icon: const Icon(Icons.send),
                label: const Text('Buy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9BB77D), // for buy button
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
