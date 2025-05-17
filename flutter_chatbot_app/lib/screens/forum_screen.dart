import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'bottom_nav_bar.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _newsItems = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final url =
        'https://newsapi.org/v2/everything?q=food+waste+Malaysia+OR+Southeast+Asia&language=en&sortBy=publishedAt&apiKey=ca21f628afe84f05a6e488abf10b11c8';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isLoading = false;
          _newsItems = (data['articles'] as List)
              .map((article) => {
                    'title': article['title'],
                    'image': article['urlToImage'] ?? '',
                    'synopsis': article['description'] ?? 'No description available',
                    'url': article['url'],
                    'publishedAt': article['publishedAt'] ?? ''
                  })
              .toList();
        });
      } else {
        setState(() => _isLoading = false);
        print('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error fetching news: $e');
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat.yMMMd().add_jm().format(date.toLocal());
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE8D0), // Pastel green background
     appBar: AppBar(
  backgroundColor: Colors.white, // White AppBar
        elevation: 0,
        title: Text(
          "Food Waste News",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _newsItems.isEmpty
              ? Center(
                  child: Text(
                    "No news found.",
                    style: GoogleFonts.poppins(color: Colors.black87),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _newsItems.length,
                  itemBuilder: (context, index) {
                    return _buildNewsCard(_newsItems[index]);
                  },
                ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> newsItem) {
    return GestureDetector(
      onTap: () => _launchURL(newsItem['url']),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 3,
        color: const Color(0xFFF2F7EB), // Light card color for contrast
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (newsItem['image'] != '')
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    newsItem['image'],
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(width: 100, height: 80, color: Colors.grey[300]),
                  ),
                )
              else
                Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      newsItem['synopsis'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(newsItem['publishedAt']),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
