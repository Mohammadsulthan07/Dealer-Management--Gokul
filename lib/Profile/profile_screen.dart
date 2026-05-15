import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1540569014015-19a7be504e3a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Nav Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                          const SizedBox(width: 16),
                          Stack(
                            children: [
                               const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
                               Positioned(
                                 right: 0, 
                                 top: 0, 
                                 child: Container(
                                   width: 8, 
                                   height: 8, 
                                   decoration: const BoxDecoration(
                                     color: Colors.redAccent, 
                                     shape: BoxShape.circle
                                    )
                                  )
                                )
                            ]
                          )
                        ],
                      )
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 3),
                            image: const DecorationImage(
                              image: NetworkImage('https://i.pravatar.cc/300?img=47'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Miranda West',
                          style: GoogleFonts.outfit(
                            fontSize: 26, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Work hard in silence. Let your\nsuccess be the noise.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 14, 
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _buildCard([
                                _buildTile('My Address', Icons.location_on_outlined),
                                _buildTile('Account', Icons.person_outline, isLast: true),
                              ]),
                              const SizedBox(height: 20),
                              _buildCard([
                                _buildTile('Notifications', Icons.notifications_none),
                                _buildTile('Devices', Icons.phone_iphone),
                                _buildTile('Passwords', Icons.vpn_key_outlined),
                                _buildTile('Language', Icons.chat_bubble_outline, isLast: true),
                              ]),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withValues(alpha: 0.04),
             blurRadius: 15,
             offset: const Offset(0, 5),
          )
        ]
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile(String title, IconData icon, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          leading: Icon(icon, color: Colors.grey[400], size: 24),
          title: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16, 
              fontWeight: FontWeight.w600, 
              color: Colors.black87
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          onTap: () {},
        ),
        if (!isLast)
          Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey[200]),
      ],
    );
  }
}
