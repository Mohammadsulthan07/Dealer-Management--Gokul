import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum PriceView { viewList, addNew, editRecord }

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final Color primaryColor = const Color(0xFF26A69A);
  final Color darkBlue = const Color(0xFF1E234E);

  PriceView _currentView = PriceView.viewList;
  bool _isLoading = true;
  List<Map<String, dynamic>> _priceRecords = [];
  String _searchQuery = '';
  Map<String, dynamic>? _editingRecord;
  final Set<String> _confirmDeleteIds = {};

  final Map<String, TextEditingController> _addControllers = {
    'date':         TextEditingController(),
    'productId':    TextEditingController(),
    'productName':  TextEditingController(),
    'productGroup': TextEditingController(),
    'mrpPrice':     TextEditingController(),
    'ssPrice':      TextEditingController(),
    'size':         TextEditingController(),
  };

  final Map<String, TextEditingController> _editControllers = {
    'date':         TextEditingController(),
    'productId':    TextEditingController(),
    'productName':  TextEditingController(),
    'productGroup': TextEditingController(),
    'mrpPrice':     TextEditingController(),
    'ssPrice':      TextEditingController(),
    'size':         TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _addControllers['date']!.text =
    '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    fetchPriceRecords();
  }

  @override
  void dispose() {
    for (var c in _addControllers.values) {
      c.dispose();
    }
    for (var c in _editControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ─── FETCH ───────────────────────────────────────────────────────────────
  Future<void> fetchPriceRecords() async {
    setState(() => _isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String cid = prefs.getString('cid') ?? '85788578';

      final response = await http.post(
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
        body: {
          "type":      "2083",
          "cid":       cid,
          "lt":        "123",
          "ln":        "123",
          "device_id": "123",
          "form":      "sm_main_form_80006",
          "select":    "*",
          "where":     "",
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['error'] == false) {
        final List<dynamic> apiList = data['data'] ?? [];
        setState(() {
          _priceRecords = apiList.map((item) => {
            'id':           item['id']?.toString() ?? '-',
            'date':         item['date']?.toString() ?? '-',
            'productId':    item['product_id']?.toString() ?? '-',
            'productName':  item['product_name']?.toString() ?? '-',
            'productGroup': item['product_group']?.toString() ?? '-',
            'mrpPrice':     item['mrp_price']?.toString() ?? '-',
            'ssPrice':      item['ss_price']?.toString() ?? '-',
            'size':         item['size']?.toString() ?? '-',
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ─── ADD NEW API ─────────────────────────────────────────────────────────
  Future<void> _addNewApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String cid = prefs.getString('cid') ?? '85788578';

      final response = await http.post(
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
        body: {
          "type":          "2082",
          "cid":           cid,
          "lt":            "123",
          "ln":            "123",
          "device_id":     "123",
          "form":          "sm_main_form_80006",
          "date":          _addControllers['date']!.text,
          "product_id":    _addControllers['productId']!.text,
          "product_name":  _addControllers['productName']!.text,
          "product_group": _addControllers['productGroup']!.text,
          "mrp_price":     _addControllers['mrpPrice']!.text,
          "ss_price":      _addControllers['ssPrice']!.text,
          "size":          _addControllers['size']!.text,
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['error'] == false) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Added successfully!', style: GoogleFonts.outfit()),
            backgroundColor: primaryColor,
          ));
        }
        for (var c in _addControllers.values) {
          c.clear();
        }
        final now = DateTime.now();
        _addControllers['date']!.text =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
        setState(() => _currentView = PriceView.viewList);
        await fetchPriceRecords();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'] ?? 'Failed', style: GoogleFonts.outfit()),
            backgroundColor: Colors.red,
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ─── EDIT API ────────────────────────────────────────────────────────────
  Future<void> _editSaveApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String cid = prefs.getString('cid') ?? '85788578';

      final response = await http.post(
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
        body: {
          "type":          "2084",
          "cid":           cid,
          "lt":            "123",
          "ln":            "123",
          "device_id":     "123",
          "form":          "sm_main_form_80006",
          "id":            _editingRecord!['id'],
          "date":          _editControllers['date']!.text,
          "product_id":    _editControllers['productId']!.text,
          "product_name":  _editControllers['productName']!.text,
          "product_group": _editControllers['productGroup']!.text,
          "mrp_price":     _editControllers['mrpPrice']!.text,
          "ss_price":      _editControllers['ssPrice']!.text,
          "size":          _editControllers['size']!.text,
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['error'] == false) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Updated successfully!', style: GoogleFonts.outfit()),
            backgroundColor: primaryColor,
          ));
        }
        setState(() => _currentView = PriceView.viewList);
        await fetchPriceRecords();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'] ?? 'Update failed', style: GoogleFonts.outfit()),
            backgroundColor: Colors.red,
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ─── DELETE API ──────────────────────────────────────────────────────────
  Future<void> _deleteApi(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String cid = prefs.getString('cid') ?? '85788578';

      final response = await http.post(
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
        body: {
          "type":      "2085",
          "cid":       cid,
          "lt":        "123",
          "ln":        "123",
          "device_id": "123",
          "form":      "sm_main_form_80006",
          "id":        id,
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['error'] == false) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Deleted successfully!', style: GoogleFonts.outfit()),
            backgroundColor: primaryColor,
          ));
        }
        await fetchPriceRecords();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'] ?? 'Delete failed', style: GoogleFonts.outfit()),
            backgroundColor: Colors.red,
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _filteredRecords {
    if (_searchQuery.isEmpty) return _priceRecords;
    return _priceRecords.where((r) =>
    r['productName'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        r['productId'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  // ─── BUILD ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 380;
    final hp = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          _buildHeader(isSmallScreen, hp),
          Expanded(child: _buildBody(isSmallScreen, hp)),
        ],
      ),
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────────────────
  Widget _buildHeader(bool isSmallScreen, double hp) {
    String title = 'Pricing & Schemes';
    if (_currentView == PriceView.addNew) title = 'Add New Price';
    if (_currentView == PriceView.editRecord) title = 'Edit Price';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: hp, right: hp, bottom: 28,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () {
                    if (_currentView == PriceView.viewList) {
                      Navigator.pop(context);
                    } else {
                      setState(() => _currentView = PriceView.viewList);
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (_currentView == PriceView.viewList) ...[
            const SizedBox(height: 20),
            Text('Price List',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 22 : 26,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 4),
            Text('${_filteredRecords.length} products',
                style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.7), fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.outfit(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: GoogleFonts.outfit(
                            color: Colors.blueGrey[300], fontSize: 13),
                        prefixIcon:
                        Icon(Icons.search, color: primaryColor, size: 20),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => setState(() => _currentView = PriceView.addNew),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline_rounded,
                            color: primaryColor, size: 18),
                        const SizedBox(width: 6),
                        Text('Add New',
                            style: GoogleFonts.outfit(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─── BODY SWITCHER ───────────────────────────────────────────────────────
  Widget _buildBody(bool isSmallScreen, double hp) {
    switch (_currentView) {
      case PriceView.addNew:
        return _buildFormView(isAdd: true, isSmallScreen: isSmallScreen, hp: hp);
      case PriceView.editRecord:
        return _buildFormView(isAdd: false, isSmallScreen: isSmallScreen, hp: hp);
      case PriceView.viewList:
        return _buildListBody(isSmallScreen, hp);
    }
  }

  // ─── LIST BODY ───────────────────────────────────────────────────────────
  Widget _buildListBody(bool isSmallScreen, double hp) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
    if (_filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.price_change_outlined,
                size: 60, color: Colors.blueGrey[200]),
            const SizedBox(height: 12),
            Text('No price records found',
                style: GoogleFonts.outfit(
                    color: Colors.blueGrey[400], fontSize: 14)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: hp, vertical: 16),
      itemCount: _filteredRecords.length,
      itemBuilder: (context, index) =>
          _buildPriceCard(_filteredRecords[index], isSmallScreen),
    );
  }

  // ─── FORM VIEW ───────────────────────────────────────────────────────────
  Widget _buildFormView({
    required bool isAdd,
    required bool isSmallScreen,
    required double hp,
  }) {
    final controllers = isAdd ? _addControllers : _editControllers;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(hp + 4),
              child: Column(
                children: [
                  _formRow(
                    left: _formField('Date', controllers['date']!, isSmallScreen),
                    right: _formField('MRP Price', controllers['mrpPrice']!, isSmallScreen, isNum: true),
                  ),
                  _formRow(
                    left: _formField('Product Id', controllers['productId']!, isSmallScreen),
                    right: _formField('SS Price', controllers['ssPrice']!, isSmallScreen, isNum: true),
                  ),
                  _formRow(
                    left: _formField('Product Name', controllers['productName']!, isSmallScreen),
                    right: _formField('Size', controllers['size']!, isSmallScreen),
                  ),
                  _formField('Product Group', controllers['productGroup']!, isSmallScreen),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () =>
                      setState(() => _currentView = PriceView.viewList),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    side: BorderSide(color: Colors.blueGrey[200]!),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.outfit(
                          color: Colors.blueGrey[400],
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isAdd ? _addNewApi : _editSaveApi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isAdd ? primaryColor : const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    isAdd ? 'Save' : 'Edit Save',
                    style: GoogleFonts.outfit(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formRow({required Widget left, required Widget right}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      ),
    );
  }

  Widget _formField(String label, TextEditingController controller,
      bool isSmallScreen, {bool isNum = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: darkBlue,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: isNum ? TextInputType.number : TextInputType.text,
            style: GoogleFonts.outfit(fontSize: 13),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: GoogleFonts.outfit(
                  fontSize: 12, color: Colors.blueGrey[200]),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blueGrey[100]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blueGrey[100]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: primaryColor, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PRICE CARD ──────────────────────────────────────────────────────────
  Widget _buildPriceCard(Map<String, dynamic> data, bool isSmallScreen) {
    final isConfirming = _confirmDeleteIds.contains(data['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product name + ID badge ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['productName'] ?? '-',
                        style: GoogleFonts.outfit(
                          fontSize: isSmallScreen ? 13 : 15,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data['productGroup'] != '-'
                            ? data['productGroup']!
                            : 'No Group',
                        style: GoogleFonts.outfit(
                            color: Colors.blueGrey[300], fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    'ID: ${data['productId']}',
                    style: GoogleFonts.outfit(
                      color: primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Container(height: 1, color: Colors.grey[100]),
            const SizedBox(height: 12),

            // ── Price info ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(
                    Icons.calendar_today_outlined, data['date'] ?? '-'),
                _buildInfoChip(Icons.straighten_outlined,
                    data['size'] != '-' ? data['size']! : 'N/A'),
                _buildPriceChip('SS', data['ssPrice'] ?? '-', primaryColor),
                _buildPriceChip('MRP', data['mrpPrice'] ?? '-', darkBlue),
              ],
            ),

            const SizedBox(height: 12),
            Container(height: 1, color: Colors.grey[100]),
            const SizedBox(height: 10),

            // ── Delete confirm container OR Edit+Delete buttons ──────
            if (isConfirming) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFCDD2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Color(0xFFE53935), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Are you sure to delete?',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFE53935),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 26),
                      child: Text(
                        '"${data['productName']}" ',
                        style: GoogleFonts.outfit(
                          color: Colors.blueGrey[400],
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 36,
                            child: OutlinedButton(
                              onPressed: () => setState(
                                      () => _confirmDeleteIds.remove(data['id'])),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.blueGrey[200]!),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text('Cancel',
                                  style: GoogleFonts.outfit(
                                    color: Colors.blueGrey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 36,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                setState(() =>
                                    _confirmDeleteIds.remove(data['id']));
                                await _deleteApi(data['id']);
                              },
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 14, color: Colors.white),
                              label: Text('Delete',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE53935),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _editControllers['date']!.text =
                              data['date'] ?? '';
                          _editControllers['productId']!.text =
                              data['productId'] ?? '';
                          _editControllers['productName']!.text =
                              data['productName'] ?? '';
                          _editControllers['productGroup']!.text =
                              data['productGroup'] ?? '';
                          _editControllers['mrpPrice']!.text =
                              data['mrpPrice'] ?? '';
                          _editControllers['ssPrice']!.text =
                              data['ssPrice'] ?? '';
                          _editControllers['size']!.text =
                              data['size'] ?? '';
                          setState(() {
                            _editingRecord = data;
                            _currentView = PriceView.editRecord;
                          });
                        },
                        icon: const Icon(Icons.edit_outlined,
                            size: 15, color: Colors.white),
                        label: Text('Edit',
                            style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: () => setState(
                                () => _confirmDeleteIds.add(data['id'])),
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 15, color: Colors.white),
                        label: Text('Delete',
                            style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────
  Widget _buildInfoChip(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.blueGrey[300]),
        const SizedBox(width: 4),
        Text(value,
            style: GoogleFonts.outfit(
              color: const Color(0xFF1E234E),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  Widget _buildPriceChip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label,
            style: GoogleFonts.outfit(
                color: Colors.blueGrey[300], fontSize: 9)),
        Text('₹$value',
            style: GoogleFonts.outfit(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            )),
      ],
    );
  }
}