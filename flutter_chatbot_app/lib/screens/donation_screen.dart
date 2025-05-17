import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_nav_bar.dart';
import 'app_drawer.dart';

class DonationScreen extends StatelessWidget {
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
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        titleSpacing: 0,
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: const BottomNavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              _buildSectionTitle('Donation Categories'),
              _buildCategoriesRow(),
              const SizedBox(height: 16),
              _buildSectionTitle('Available Donations'),
              // Wrap the GridView in an Expanded widget to handle overflow
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // Adjust the height as necessary
                child: _buildDonationGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
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
    );
  }

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

 Widget _buildDonationGrid() {
  List<String> donationNames = [
    'Tomato', 'Banana', 'Rice Bag', 'Apple', 'Bread', 'Vegetable Mix'
  ];
  List<String> imagePaths = [
    'assets/picture_tomato.jpg', 'assets/picture_banana.jpg', 'assets/picture_ricebag.jpg',
    'assets/picture_apple.jpg', 'assets/picture_bread.jpg', 'assets/picture_vege.jpg'
  ];
  List<String> weights = [
    '0.5 kg', '1.2 kg', '0.8 kg', '2.0 kg', '1.5 kg', '1.0 kg'
  ];
  List<String> locations = [
    'Alor Setar', 'Puchong', 'Subang Jaya', 'Kuala Lumpur', 'Penang', 'Melaka'
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: donationNames.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
    ),
    itemBuilder: (context, index) {
      return _buildDonationItem(
        context,
        index,
        donationNames,
        imagePaths,
        weights,
        locations, // Pass locations list
      );
    },
  );
}


Widget _buildDonationItem(BuildContext context, int index, List<String> names, List<String> images, List<String> weights, List<String> locations) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: _buildPopup(context, index, names[index], images[index], locations[index]),
        ),
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              images[index],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Donation details on the left
Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        names[index],
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      Text(
        weights[index],
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        locations[index],
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  ),
),

                // "Donate" Button on the right
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You are donating ${names[index]}')),
                      );
                    },
                    child: const Text('Donate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9BB77D),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}


Widget _buildPopup(BuildContext context, int index, String name, String imagePath, String location) {
  return Center(
    child: Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
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
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow('Item:', name),
          _buildInfoRow('Location:', location),  // Add location here
          _buildInfoRow('Phone:', '+123456789'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add your donation claim logic here
                },
                icon: const Icon(Icons.check),
                label: const Text('Claim'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9BB77D),
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
          Text('$title ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
