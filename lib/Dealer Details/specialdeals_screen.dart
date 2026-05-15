import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class SpecialDealsScreen extends StatefulWidget {
  const SpecialDealsScreen({super.key});

  @override
  State<SpecialDealsScreen> createState() => _SpecialDealsScreenState();
}

class _SpecialDealsScreenState extends State<SpecialDealsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<dynamic> _deals = [];
  final String _cid = "80011";

  final Color primaryColor = const Color(0xFF26A69A);
  final Color darkColor = const Color(0xFF1E234E);
  final Color bgColor = const Color(0xFFF1F5F9);
  final Color accentColor = const Color(0xFF3F51B5);
  final Color dangerColor = const Color(0xFFF44336);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchDeals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchDeals() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
        body: {
          'type': '2083',
          'cid': _cid,
          'lt': '123',
          'ln': '123',
          'device_id': '123',
          'form': 'sm_main_form_72601',
          'select': '*',
          'where': "deal_name like '%%'",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          setState(() {
            _deals = data['data'] ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching deals: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Special Deals - $_cid',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(isTablet),
                _buildPlaceholderView("Add New Deal Form Content"),
                _buildPlaceholderView("Filter List Options"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: primaryColor,
        indicatorWeight: 3,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'View List', icon: Icon(Icons.list_alt_rounded, size: 20)),
          Tab(text: 'Add New', icon: Icon(Icons.add_circle_outline, size: 20)),
          Tab(text: 'Filter List', icon: Icon(Icons.filter_list_rounded, size: 20)),
        ],
      ),
    );
  }

  Widget _buildListView(bool isTablet) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    final displayList = _deals.isEmpty ? [_getMockDeal()] : _deals;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        return _buildDealCard(displayList[index]);
      },
    );
  }

  Map<String, dynamic> _getMockDeal() {
    return {
      'id': '1',
      'deal_name': 'Diwali Special Deal',
      'banner': 'https://erpsmart.in/total/uploads/project_photo/17719988',
      'start_date': '2026-02-25',
      'end_date': '2027-02-25',
      'start_time': '11:25:05',
      'end_time': '22:20:00',
      'status': 'Active',
      'discount': '4%',
    };
  }

  Widget _buildDealCard(dynamic deal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: darkColor.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TOP PART: IMAGE & BADGES
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: deal['status'] == 'Active'
                    ? Image.asset(
                        'assets/specialdeal.png',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: deal['banner'] ?? 'https://erpsmart.in/total/uploads/project_photo/17719988',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                        ),
                      ),
              ),
              // Status Badge
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: deal['status'] == 'Active' ? Colors.green : Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        deal['status'] ?? 'PENDING',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: Text(
                    '${deal['discount'] ?? '0%'} OFF',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. MIDDLE PART: TITLE & INFO
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        deal['deal_name'] ?? 'Diwali Mega Sale',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                    ),
                    Text(
                      '#${deal['id']}',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Details Grid
                Row(
                  children: [
                    _buildInfoItem(Icons.calendar_today_rounded, 'START', deal['start_date']),
                    Container(width: 1, height: 30, color: Colors.grey[200], margin: const EdgeInsets.symmetric(horizontal: 15)),
                    _buildInfoItem(Icons.event_available_rounded, 'END', deal['end_date']),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(Icons.access_time_filled_rounded, 'TIME', '${deal['start_time']} - ${deal['end_time']}'),
                  ],
                ),
              ],
            ),
          ),

          // 3. BOTTOM PART: ACTIONS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_document, size: 18),
                    label: const Text('Edit Deal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                    onPressed: () {},
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String? value) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  value ?? '-',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: darkColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderView(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: primaryColor.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}