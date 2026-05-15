import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  int _selectedCategoryIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBF5), // Light purple-grey background matching the image
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFeaturedCard(),
              const SizedBox(height: 32),
              _buildCategoryScroller(),
              const SizedBox(height: 32),
              Text(
                'Your Wishlist',
                style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              _buildGridCards(context),
              const SizedBox(height: 80), // spacing for bottom nav if present
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        Column(
          children: [
            Text('Hello Sandeep', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Today 15 Aug.', style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: const Icon(Icons.search, color: Colors.black87),
        )
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFAA99FF), // Light purple
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(
                 child: Text(
                  'Featured\nFavorites',
                  style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
                 ),
               ),
               const Icon(Icons.auto_awesome, color: Colors.white, size: 48),
            ],
          ),
          const SizedBox(height: 16),
          Text('Stock up before the season ends!', style: GoogleFonts.outfit(color: Colors.black87, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMiniAvatar(Colors.red),
              _buildMiniAvatar(Colors.blue, -10),
              _buildMiniAvatar(Colors.green, -20),
              Container(
                transform: Matrix4.translationValues(-30, 0, 0),
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                child: Center(child: Text('+4', style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniAvatar(Color color, [double translateX = 0]) {
    return Container(
      transform: Matrix4.translationValues(translateX, 0, 0),
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.6), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
      child: const Icon(Icons.person, color: Colors.white, size: 16),
    );
  }

  Widget _buildCategoryScroller() {
    final categories = ['All', 'Product', 'Cloths', 'Dresses', 'Top'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black87 : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: isSelected ? Colors.black : Colors.grey[400]!),
              ),
              child: Column(
                children: [
                  if (isSelected) const Icon(Icons.circle, color: Colors.white, size: 6),
                  if (isSelected) const SizedBox(height: 4),
                  Text(
                    categories[index],
                    style: GoogleFonts.outfit(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGridCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildVerticalCard(
                color: const Color(0xFFFFB74D), // Soft orange
                tag: 'High Priority',
                title: 'Power Drills',
                date: '15 Aug.',
                time: 'Added: 15:00',
                location: 'A6 Category',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  _buildVerticalCard(
                    color: const Color(0xFF90CAF9), // Soft blue
                    tag: 'Light',
                    title: 'Brake Pads',
                    date: '13 Aug.',
                    time: 'Added: 11:00',
                    location: 'A2 Category',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 74,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF80AB), // Soft pink
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialIcon(Icons.camera_alt_outlined),
                        _buildSocialIcon(Icons.play_circle_outline),
                        _buildSocialIcon(Icons.close),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildVerticalCard({
    required Color color,
    required String tag,
    required String title,
    required String date,
    required String time,
    required String location,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(tag, style: GoogleFonts.outfit(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 32),
          Text(title, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(date, style: GoogleFonts.outfit(fontSize: 13, color: Colors.black87)),
          Text(time, style: GoogleFonts.outfit(fontSize: 13, color: Colors.black87)),
          Text(location, style: GoogleFonts.outfit(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
