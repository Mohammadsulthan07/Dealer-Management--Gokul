import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  int _selectedTabIndex = 2; // Default to 'Lessons'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildTabs(),
              const SizedBox(height: 30),
              _buildAdvertisementGrid(),
              const SizedBox(height: 40),
              _buildBottomSectionHeader(),
              const SizedBox(height: 16),
              _buildBottomCardsList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
               onTap: () => Navigator.pop(context),
               child: Row(
                 children: [
                   const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black54),
                   Text(
                    'Good morning,',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                 ],
               ),
            ),
            const SizedBox(height: 4),
            Text(
              'Gokul!',
              style: GoogleFonts.outfit(
                fontSize: 28,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Colors.black87),
            )
          ],
        )
      ],
    );
  }

  Widget _buildTabs() {
    final tabs = ['Forum', 'Add. classes'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final title = entry.value;
        final isSelected = _selectedTabIndex == index;

        return GestureDetector(
          onTap: () => setState(() => _selectedTabIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7B61FF) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF7B61FF).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ]
                  : [],
            ),
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdvertisementGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      double width = (constraints.maxWidth - 20) / 2; // 20 is spacing
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _buildSubjectCard('Culture', 'Teacher:', 'Dianne Russell', const Color(0xFF8B5CF6), width, Icons.star, 'https://i.pravatar.cc/150?img=1'),
          _buildSubjectCard('History', 'Teacher:', 'Amy Adams', const Color(0xFFFF6B6B), width, Icons.flag, 'https://i.pravatar.cc/150?img=5'),
          _buildSubjectCard('Math', 'Teacher:', 'Amy Johnson', const Color(0xFFFFB020), width, Icons.school, 'https://i.pravatar.cc/150?img=9'),
          _buildSubjectCard('Literature', 'Teacher:', 'Leona Smith', const Color(0xFF4ADE80), width, Icons.menu_book, 'https://i.pravatar.cc/150?img=12'),
        ],
      );
    });
  }

  Widget _buildSubjectCard(String title, String subtitle1, String subtitle2, Color color, double width, IconData icon, String avatarUrl) {
    return Container(
      width: width,
      height: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(24),
          topRight: const Radius.circular(24),
          bottomLeft: const Radius.circular(24),
          bottomRight: const Radius.circular(48), // Stylized cut on bottom right
        ),
        boxShadow: [
          BoxShadow(
             color: color.withValues(alpha: 0.4),
             blurRadius: 15,
             offset: const Offset(0, 8),
          )
        ]
      ),
      child: Stack(
        children: [
          // Background decoration marks
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bookmark_outline, color: Colors.white, size: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const Spacer(),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(avatarUrl),
                      backgroundColor: Colors.white24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subtitle1,
                            style: GoogleFonts.outfit(fontSize: 10, color: Colors.white70),
                          ),
                          Text(
                            subtitle2,
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
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
            bottom: 10,
            right: 10,
            child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white54),
          )
        ],
      ),
    );
  }

  Widget _buildBottomSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Homework',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          'See all',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF7B61FF),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCardsList() {
    final list = [
      {'title': 'Music', 'date': '19 May', 'icon': Icons.headphones, 'color': const Color(0xFFFF6B6B)},
      {'title': 'Math', 'date': '29 May', 'icon': Icons.square_foot, 'color': const Color(0xFF7B61FF)},
      {'title': 'Geography', 'date': '25 May', 'icon': Icons.public, 'color': const Color(0xFFFFB020)},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: list.map((item) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.check, size: 14, color: Colors.black26),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['date'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }


}
