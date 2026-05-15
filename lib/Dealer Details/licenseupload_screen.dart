import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LicenseUploadScreen extends StatefulWidget {
  const LicenseUploadScreen({super.key});

  @override
  State<LicenseUploadScreen> createState() => _LicenseUploadScreenState();
}

class _LicenseUploadScreenState extends State<LicenseUploadScreen> {
  int _selectedFilterIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5), // Light cream background
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildFilterRow(),
                    const SizedBox(height: 16),
                    _buildTabsRow(),
                    const SizedBox(height: 24),
                    _buildLicenseCard(
                      headerColor: const Color(0xFFFFD54F), // Yellow
                      icon: Icons.description_outlined,
                      title: 'GST Certificate',
                      tagId: 'd456474',
                      type: 'Tax Registration',
                      refNo: '33AABCU9603R1ZJ',
                      creationDate: '12/12/2023',
                      expirationDate: '12/12/2025',
                      issuer: 'Govt. of India',
                    ),
                    const SizedBox(height: 16),
                    _buildLicenseCard(
                      headerColor: const Color(0xFF90CAF9), // Blue
                      icon: Icons.cases_outlined,
                      title: 'Trade License',
                      tagId: '2gfhty756',
                      type: 'Business License',
                      refNo: '454645-5657-56768',
                      creationDate: '01/12/2023',
                      expirationDate: '01/12/2025',
                      issuer: 'Municipal Corp.',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
            ),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            ),
          ),
          Text(
            'License Uploads',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(width: 40), // Balance the title centering
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD54F),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.vpn_key_outlined, color: Colors.black87, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active licenses', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 15)),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
           decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Icon(Icons.filter_list, color: Colors.black87, size: 20),
        )
      ],
    );
  }

  Widget _buildTabsRow() {
    final tabs = ['All', 'GST', 'Trade', 'FSSAI'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? Colors.black87 : Colors.grey[300]!),
              ),
              child: Text(
                tabs[index],
                style: GoogleFonts.outfit(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLicenseCard({
    required Color headerColor,
    required IconData icon,
    required String title,
    required String tagId,
    required String type,
    required String refNo,
    required String creationDate,
    required String expirationDate,
    required String issuer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F1EA), // Inner card cream
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Row(
              children: [
                 Container(
                   padding: const EdgeInsets.all(10),
                   decoration: BoxDecoration(
                     color: Colors.white.withValues(alpha: 0.4),
                     shape: BoxShape.circle,
                   ),
                   child: Icon(icon, color: Colors.black87),
                 ),
                 const SizedBox(width: 16),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                     const SizedBox(height: 4),
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                       decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4)),
                       child: Text(tagId, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600)),
                     )
                   ],
                 )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildCardRow('Type:', type),
                const SizedBox(height: 12),
                _buildCardRow('Ref #:', refNo),
                const SizedBox(height: 12),
                _buildCardRow('Creation date:', creationDate),
                const SizedBox(height: 12),
                _buildCardRow('Expiration date:', expirationDate),
                const SizedBox(height: 12),
                _buildCardRow('Issuer:', issuer, isBold: true),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Open document', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(width: 8),
                    const Icon(Icons.qr_code_scanner, color: Colors.black87),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardRow(String label, String value, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(
            value, 
            style: GoogleFonts.outfit(
              color: Colors.black87, 
              fontSize: 13, 
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              decoration: isBold ? TextDecoration.underline : TextDecoration.none,
            )
          ),
        )
      ],
    );
  }
}
