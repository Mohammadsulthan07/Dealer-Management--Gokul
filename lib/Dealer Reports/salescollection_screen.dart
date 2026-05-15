import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalesCollectionScreen extends StatefulWidget {
  const SalesCollectionScreen({super.key});

  @override
  State<SalesCollectionScreen> createState() => _SalesCollectionScreenState();
}

class _SalesCollectionScreenState extends State<SalesCollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildSectionHeader('Sales Overview', 'See more'),
                    const SizedBox(height: 16),
                    _buildOverviewCards(),
                    const SizedBox(height: 32),
                    Text(
                      'Performance Targets',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTargetCard(
                      title: 'Collection Efficiency',
                      subtitle: 'Increase 12% from previous month',
                      percentage: 80,
                      color: const Color(0xFF26A69A),
                    ),
                    const SizedBox(height: 16),
                    _buildTargetCard(
                      title: 'Sales Target Achieved',
                      subtitle: 'Increase 7% from previous month',
                      percentage: 78,
                      color: const Color(0xFF26A69A),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.home_outlined), onPressed: () {}),
              IconButton(icon: const Icon(Icons.mail_outline), onPressed: () {}),
              const SizedBox(width: 48), // Space for FAB
              IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
              IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF26A69A),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  ),
                  const Icon(Icons.more_horiz, color: Colors.white),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/Profile.png'),
                    backgroundColor: Colors.white24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sandeep Enterprises',
                          style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'Mumbai, India • Gold Dealer',
                          style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: Container(
            transform: Matrix4.translationValues(0, 20, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text('70% to Diamond', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        Text(action, style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF26A69A), fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildOverviewCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(constraints.maxWidth / 2 - 8, 'Total Revenue', '₹ 12.4L', const Color(0xFF26A69A)),
            _buildStatCard(constraints.maxWidth / 2 - 8, 'Sales This Month', '₹ 2.1L', Colors.orange),
            _buildStatCard(constraints.maxWidth / 2 - 8, 'Avg. Invoice Value', '₹ 45K', Colors.orange),
            _buildStatCard(constraints.maxWidth / 2 - 8, 'Pending Collections', '4 (₹ 80K)', Colors.orange),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(double width, String title, String value, Color bulletColor) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: bulletColor, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: bulletColor)),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTargetCard({required String title, required String subtitle, required int percentage, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 6,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.1),
                ),
                Center(
                  child: Text(
                    '$percentage%',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
