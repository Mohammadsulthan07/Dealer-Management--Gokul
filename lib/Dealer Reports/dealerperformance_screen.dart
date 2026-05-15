import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DealerPerformanceScreen extends StatefulWidget {
  const DealerPerformanceScreen({super.key});

  @override
  State<DealerPerformanceScreen> createState() => _DealerPerformanceScreenState();
}

class _DealerPerformanceScreenState extends State<DealerPerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8), // Light background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Performance',
          style: GoogleFonts.outfit(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDealerProfileCard(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildMetricCard('12', 'Targets\nHit', Colors.white, Colors.black87)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMetricCard('94%', 'Overall\nScore', Colors.blueAccent, Colors.white)),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Key Metrics', 'Details >'),
              const SizedBox(height: 16),
              _buildLargeMetricBlock('Sales Volume', '64%', Colors.deepOrangeAccent, Icons.trending_up, true),
              const SizedBox(height: 16),
              _buildLargeMetricBlock('On-Time Payment', '91%', const Color(0xFF26A69A), Icons.verified, false),
              const SizedBox(height: 16),
              _buildLargeMetricBlock('Order Accuracy', '82%', Colors.white, Icons.check_circle_outline, false, isLight: true),
              const SizedBox(height: 32),
              _buildLeaderboardPreview(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealerProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo, // Like the dark blue profile reference
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.indigo.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/Profile.png'), // Using standard avatar
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sandeep Ent.', style: GoogleFonts.outfit(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.inventory, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text('12k Vol', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13)),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text('4.8', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13)),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(Icons.insights, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildMetricCard(String value, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (bgColor == Colors.white)
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: GoogleFonts.outfit(fontSize: 14, color: textColor.withValues(alpha: 0.7), fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        Text(action, style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildLargeMetricBlock(String title, String percentage, Color color, IconData icon, bool hasOverlayGraph, {bool isLight = false}) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isLight ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))] : [],
      ),
      child: Stack(
        children: [
          if (hasOverlayGraph)
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: isLight ? Colors.black87 : Colors.white)),
                    Icon(icon, color: isLight ? Colors.grey[400] : Colors.white70, size: 28),
                  ],
                ),
                Text(percentage, style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.bold, color: isLight ? Colors.black87 : Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text('Top performers', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
             Text('Full list >', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
           ],
        ),
        const SizedBox(height: 4),
        Text('Compare your rating', style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[500])),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: Stack(
            children: [
              _buildAvatarOverlay(0, Colors.red),
              _buildAvatarOverlay(35, Colors.blue),
              _buildAvatarOverlay(70, Colors.green),
              _buildAvatarOverlay(105, Colors.orange),
              Positioned(
                left: 150,
                top: 5,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  alignment: Alignment.center,
                  child: Text('+12', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 12)),
                )
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAvatarOverlay(double leftPos, Color color) {
    return Positioned(
      left: leftPos,
      top: 0,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Icon(Icons.person, color: color),
      ),
    );
  }
}
