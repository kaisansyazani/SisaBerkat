import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Replace these with your own implementations:
import 'app_drawer.dart';      // contains MyLogoDrawer()
import 'bottom_nav_bar.dart';    // contains MyBottomNavBar()

void main() {
  runApp(const DataVisual());
}

class DataVisual extends StatelessWidget {
  const DataVisual({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const _impactCards = [
    _ImpactData(
      title: 'Total Food Rescued',
      value: '125 KG',
      icon: Icons.food_bank,
      bgColor: Color(0xFFFEECE4),
      iconColor: Color(0xFFF08A5D),
    ),
    _ImpactData(
      title: 'CO₂ Emissions Prevented',
      value: '125 KG',
      icon: Icons.eco,
      bgColor: Color(0xFFE9F6EC),
      iconColor: Color(0xFF66BB6A),
    ),
    _ImpactData(
      title: 'Households Supported',
      value: '150+',
      icon: Icons.home,
      bgColor: Color(0xFFE4F1FE),
      iconColor: Color(0xFF42A5F5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),           // your custom logo drawer
      bottomNavigationBar: const BottomNavBar(), // your custom bottom nav
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'SisaBerkat',
          style: TextStyle(
            color: Color(0xFF2D6A4F),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 32, // extra space to avoid overflow
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Food Waste Impact ---
              const Text(
                'Food Waste Impact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Wrap the Row inside a SingleChildScrollView to prevent overflow
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,  // Scrolls horizontally if needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,  // Align to the left
                  children: _impactCards
                      .map((data) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: _ImpactCard(data: data),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),

              // --- Weekly Overview ---
              const Text(
                'Weekly Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: LineChartWidget(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Chip(
                          label: Text('+8.8%'),
                          backgroundColor: Color(0xFFE9F6EC),
                          labelStyle: TextStyle(color: Color(0xFF66BB6A)),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Better than last week!',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '88.72% rescued',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- Economic ---
              const Text(
                'Economic',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: 'Income Earned',
                      value: 'RM 1,500',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      title: 'Products Sold',
                      value: '14 Items',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Learning & Engagement --

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactData {
  final String title, value;
  final IconData icon;
  final Color bgColor, iconColor;
  const _ImpactData({
    required this.title,
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}

class _ImpactCard extends StatelessWidget {
  final _ImpactData data;
  const _ImpactCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: data.bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.iconColor, size: 28),
          const Spacer(),
          Text(
            data.value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: data.iconColor,
            ),
          ),
          Text(
            data.title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  const _StatCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 2),
              FlSpot(2, 1.3),
              FlSpot(3, 2.2),
              FlSpot(4, 1.8),
              FlSpot(5, 2.4),
              FlSpot(6, 2),
            ],
            isCurved: true,
            color: const Color.fromARGB(255, 74, 77, 75),
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: const [
              FlSpot(0, 1.5),
              FlSpot(1, 1),
              FlSpot(2, 1.6),
              FlSpot(3, 1.2),
              FlSpot(4, 2.1),
              FlSpot(5, 1.9),
              FlSpot(6, 2.3),
            ],
            isCurved: true,
            color: const Color(0xFF95D5B2),
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
