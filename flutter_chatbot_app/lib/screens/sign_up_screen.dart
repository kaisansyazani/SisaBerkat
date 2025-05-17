import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String? userType;
  bool isLoading = false;

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("YOUR_GOOGLE_API_KEY"); // Replace with your real key
    locationController.addListener(() {
      if (locationController.text.isNotEmpty) {
        autoCompleteSearch(locationController.text);
      } else {
        setState(() {
          predictions = [];
        });
      }
    });
  }

  Future<void> autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    final placemark = placemarks.first;
    final fullAddress = "${placemark.street}, ${placemark.locality}, ${placemark.country}";

    setState(() {
      locationController.text = fullAddress;
      predictions = [];
    });
  }

  Future<void> _registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final location = locationController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty || location.isEmpty || userType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;

      await FirebaseFirestore.instance.collection('User').doc(uid).set({
        'email': email,
        'name': name,
        'phone': phone,
        'location': location,
        'role': userType,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong.')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF6C8F5B)),
        filled: true,
        fillColor: Color(0xFFF2F7EB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCE8D0), // pastel green
      appBar: AppBar(
        backgroundColor: Color(0xFF6C8F5B),
        title: Text('Sign Up', style: GoogleFonts.poppins(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            _buildTextField(nameController, "Full Name", Icons.person),
            SizedBox(height: 15),
            _buildTextField(phoneController, "Phone Number", Icons.phone, keyboardType: TextInputType.phone),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(locationController, "Location", Icons.location_on),
                ),
                IconButton(
                  icon: Icon(Icons.my_location, color: Color(0xFF6C8F5B)),
                  onPressed: getCurrentLocation,
                ),
              ],
            ),
            if (predictions.isNotEmpty)
              Container(
                height: 150,
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(predictions[index].description ?? ''),
                      onTap: () {
                        locationController.text = predictions[index].description ?? '';
                        setState(() => predictions = []);
                      },
                    );
                  },
                ),
              ),
            SizedBox(height: 15),
            _buildTextField(emailController, "Email", Icons.email, keyboardType: TextInputType.emailAddress),
            SizedBox(height: 15),
            _buildTextField(passwordController, "Password", Icons.lock, isObscure: true),
            SizedBox(height: 20),

            Text("Register as:", style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: ['Receiver', 'Provider'].map((role) {
                final selected = userType == role;
                return ChoiceChip(
                  label: Text(role),
                  selected: selected,
                  selectedColor: Color(0xFF6C8F5B),
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                  onSelected: (_) {
                    setState(() {
                      userType = role;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),

            isLoading
                ? CircularProgressIndicator(color: Color(0xFF6C8F5B))
                : ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C8F5B),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
