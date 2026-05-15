import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum InvoiceView { viewList, addNew }

class DealerSalesInvoiceScreen extends StatefulWidget {
  const DealerSalesInvoiceScreen({super.key});

  @override
  State<DealerSalesInvoiceScreen> createState() => _DealerSalesInvoiceScreenState();
}

class _DealerSalesInvoiceScreenState extends State<DealerSalesInvoiceScreen> {
  int? _editingIndex;
  InvoiceView _currentView = InvoiceView.viewList;
  final Color primaryColor = const Color(0xFF26A69A);

  final List<Map<String, dynamic>> _invoices = [];

  final TextEditingController _dateController = TextEditingController(text: '08-04-2026');
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('invoices');

    if (data != null && data.isNotEmpty) {
      final List decoded = jsonDecode(data);

      _invoices.clear();
      _invoices.addAll(decoded.map((e) => Map<String, dynamic>.from(e)));

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _saveInvoicesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_invoices);
    await prefs.setString('invoices', data);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _idController.dispose();
    super.dispose();
  }

  // FIX: Made async, await storage BEFORE setState, removed setState wrapper around list mutation
  void _saveInvoice() async {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an Invoice ID', style: GoogleFonts.outfit())),
      );
      return;
    }

    if (_editingIndex != null) {
      _invoices[_editingIndex!] = {
        'id': _idController.text,
        'date': _dateController.text,
        'status': 'Pending',
      };
      _editingIndex = null;
    } else {
      _invoices.insert(0, {
        'id': _idController.text,
        'date': _dateController.text,
        'status': 'Pending',
      });
    }

    // FIX: Await storage write BEFORE switching view
    await _saveInvoicesToStorage();

    setState(() {
      _currentView = InvoiceView.viewList;
      _idController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 380;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isSmallScreen),
            Expanded(
              child: _currentView == InvoiceView.viewList
                  ? _buildInvoiceList(isSmallScreen)
                  : _buildAddInvoiceForm(primaryColor),
            ),
          ],
        ),
      ),
      floatingActionButton: (_currentView == InvoiceView.viewList && _invoices.isNotEmpty)
          ? FloatingActionButton(
        onPressed: () => setState(() => _currentView = InvoiceView.addNew),
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      )
          : null,
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E234E)),
            onPressed: () {
              // FIX: Removed _loadInvoices() call here — no longer needed,
              // avoids race condition overwriting in-memory list
              if (_currentView == InvoiceView.addNew) {
                setState(() => _currentView = InvoiceView.viewList);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Text(
            _currentView == InvoiceView.addNew ? 'Add New Invoice' : 'Dealer Sales Invoice',
            style: GoogleFonts.outfit(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E234E),
            ),
          ),
          Icon(Icons.more_horiz_rounded, color: Colors.blueGrey[300]),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(bool isSmallScreen) {
    if (_invoices.isEmpty) {
      return _buildEmptyState();
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'April Sales',
                  style: GoogleFonts.outfit(
                      fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1E234E)),
                ),
                Text(
                  'Tracking ${_invoices.length} active invoice${_invoices.length == 1 ? '' : 's'}',
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.blueGrey[300]),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Icon(Icons.calendar_month_rounded, color: primaryColor, size: 24),
            ),
          ],
        ),
        const SizedBox(height: 24),

        _buildProgressCard(),
        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Invoice Overview',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E234E),
              ),
            ),
            Text(
              'View All',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ..._invoices.asMap().entries.map(
              (entry) => _buildInvoiceCard(entry.value, entry.key, isSmallScreen),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.blueGrey[100],
          ),
          const SizedBox(height: 16),
          Text(
            'No Invoices',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E234E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t created any invoices yet',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.blueGrey[300],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() => _currentView = InvoiceView.addNew);
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'Create Invoice',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26A69A).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Revenue',
                  style: GoogleFonts.outfit(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your current collection status for April',
                  style: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Text(
                '75%',
                style: GoogleFonts.outfit(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> inv, int index, bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.description_outlined, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inv['id'],
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E234E),
                  ),
                ),
                Text(
                  inv['date'],
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.blueGrey[300]),
                ),
              ],
            ),
          ),
          _buildActionButton(Icons.edit_outlined, Colors.blue[600]!, () {
            setState(() {
              _editingIndex = index;
              _idController.text = inv['id'];
              _dateController.text = inv['date'];
              _currentView = InvoiceView.addNew;
            });
          }),
          const SizedBox(width: 8),
          _buildActionButton(Icons.delete_outline_rounded, Colors.red[400]!, () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete Invoice',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                content: Text('Are you sure you want to delete this invoice?',
                    style: GoogleFonts.outfit()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: GoogleFonts.outfit()),
                  ),
                  TextButton(
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      setState(() {
                        _invoices.removeAt(index);
                        if (_editingIndex == index) _editingIndex = null;
                      });

                      // FIX: Await storage after delete
                      await _saveInvoicesToStorage();

                      nav.pop();
                    },
                    child: Text('Delete', style: GoogleFonts.outfit(color: Colors.red)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildAddInvoiceForm(Color primaryColor) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _editingIndex != null ? 'Edit Invoice' : 'New Sales Invoice',
            style: GoogleFonts.outfit(
                fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1E234E)),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new record for tracking sales',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.blueGrey[300]),
          ),
          const SizedBox(height: 40),
          _buildMedlioField('Invoice ID', _idController, primaryColor, Icons.tag_rounded),
          const SizedBox(height: 24),
          _buildMedlioField(
              'Invoice Date', _dateController, primaryColor, Icons.calendar_today_rounded),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _currentView = InvoiceView.viewList;
                    _editingIndex = null;
                    _idController.clear();
                  }),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.blueGrey[100]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.outfit(
                          color: Colors.blueGrey[400], fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveInvoice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 8,
                    shadowColor: primaryColor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('SAVE INVOICE',
                      style:
                      GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedlioField(
      String label, TextEditingController controller, Color primaryColor, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
              fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E234E)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey[200]),
            hintText: 'Enter $label',
            hintStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.blueGrey[200]),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
          style: GoogleFonts.outfit(fontSize: 14),
        ),
      ],
    );
  }
}