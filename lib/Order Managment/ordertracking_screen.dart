import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

enum TrackingView { viewList, addNew, filterList }

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  TrackingView _currentView = TrackingView.viewList;
  
  final Color primaryColor = const Color(0xFF26A69A);
  final Color darkBlue = const Color(0xFF1E234E);

  // Controllers
  final TextEditingController _dealerController = TextEditingController();
  final TextEditingController _dateRangeController = TextEditingController(text: '20-04-2026');

  List<Map<String, dynamic>> _trackingRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrackingData();
  }

  Future<void> _fetchTrackingData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
        body: {
          'type': '2083',
          'cid': '85788578',
          'lt': '123',
          'ln': '123',
          'device_id': '123',
          'form': 'sm_main_form_70501',
          'select': '*',
          'where': "qc_status like '%Pend%'",
        },
      );
      if (response.statusCode == 200) {
        debugPrint("track: ${response.body}");
        final data = json.decode(response.body);
        if (data['error'] == false && data['data'] != null) {
          setState(() {
            _trackingRecords = List<Map<String, dynamic>>.from(data['data']);
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('API Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _dealerController.dispose();
    _dateRangeController.dispose();
    super.dispose();
  }

  void _saveTracking() {
    // Save logic if needed
    setState(() {
      _currentView = TrackingView.viewList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String title = 'Order Tracking';
    if (_currentView == TrackingView.addNew) title = 'New Track';
    if (_currentView == TrackingView.filterList) title = 'Filter';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E234E)),
            onPressed: () {
              if (_currentView == TrackingView.viewList) {
                Navigator.pop(context);
              } else {
                setState(() => _currentView = TrackingView.viewList);
              }
            },
          ),
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue),
          ),
          _currentView == TrackingView.viewList 
              ? Row(
                  children: [
                    IconButton(icon: Icon(Icons.tune_rounded, color: primaryColor), onPressed: () => setState(() => _currentView = TrackingView.filterList)),
                    IconButton(icon: Icon(Icons.add_circle_outline_rounded, color: primaryColor), onPressed: () => setState(() => _currentView = TrackingView.addNew)),
                  ],
                )
              : const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_currentView) {
      case TrackingView.viewList:
        return _buildTrackingList();
      case TrackingView.addNew:
        return _buildAddForm();
      case TrackingView.filterList:
        return _buildFilterForm();
    }
  }

  Widget _buildTrackingList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
    
    if (_trackingRecords.isEmpty) {
      return Center(child: Text('No tracking records found', style: GoogleFonts.outfit(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _trackingRecords.length,
      itemBuilder: (context, index) {
        final record = _trackingRecords[index];
        return _buildCardItem(record);
      },
    );
  }

  Widget _buildCardItem(Map<String, dynamic> record) {
    final String idText = record['id']?.toString() ?? '-';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ID: $idText', 
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('Action', style: GoogleFonts.outfit(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.calendar_month_rounded, 'Date Range', record['date_range']?.toString() ?? '-'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.business_rounded, 'Dealer Name', record['dealer_name']?.toString() ?? '-'),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey[400]),
        const SizedBox(width: 8),
        Text('$label: ', style: GoogleFonts.outfit(color: Colors.blueGrey[400], fontSize: 13)),
        Expanded(child: Text(value, style: GoogleFonts.outfit(color: darkBlue, fontWeight: FontWeight.w600, fontSize: 13))),
      ],
    );
  }

  Widget _buildAddForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader('New  Tracking Record'),
          const SizedBox(height: 24),
          _buildMedlioField('Date Range', _dateRangeController, Icons.calendar_today_rounded),
          _buildMedlioField('Dealer Name', _dealerController, Icons.business_rounded),
          const SizedBox(height: 40),
          _buildFormButtons('SAVE', _saveTracking),
        ],
      ),
    );
  }

  Widget _buildFilterForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader('Filter Tracking'),
          const SizedBox(height: 24),
          _buildMedlioField('Date Range', _dateRangeController, Icons.calendar_today_rounded),
          _buildMedlioField('Dealer Name', _dealerController, Icons.business_rounded),
          const Spacer(),
          _buildFormButtons('APPLY FILTER', () => setState(() => _currentView = TrackingView.viewList)),
        ],
      ),
    );
  }

  Widget _buildFormHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: darkBlue)),
        Text('Manage your delivery updates smoothly', style: GoogleFonts.outfit(fontSize: 14, color: Colors.blueGrey[300])),
      ],
    );
  }

  Widget _buildMedlioField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: darkBlue)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.blueGrey[200], size: 20),
              hintText: 'Enter $label',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFECEFF1))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFECEFF1))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor, width: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormButtons(String primaryLabel, VoidCallback onPrimary) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => setState(() => _currentView = TrackingView.viewList),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.blueGrey[100]!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.blueGrey[400], fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: onPrimary,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(primaryLabel, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
