import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dispatch_notification_detail.dart';

enum DispatchView { viewList, addNew, filterList }

class DispatchmentScreen extends StatefulWidget {
  const DispatchmentScreen({super.key});

  @override
  State<DispatchmentScreen> createState() => _DispatchmentScreenState();
}

class _DispatchmentScreenState extends State<DispatchmentScreen> {
  DispatchView _currentView = DispatchView.viewList;

  late List<Map<String, dynamic>> dispatchRecords;

  // Controllers for Add New (all fields from image)
  final Map<String, TextEditingController> _addControllers = {
    'Dispatch no':     TextEditingController(),
    'Order ID':        TextEditingController(),
    'Customer ID':     TextEditingController(),
    'Warehose':        TextEditingController(),
    'Dispatch Date':   TextEditingController(text: '19-04-2026'),
    'Total Quantity':  TextEditingController(),
    'Total Amount':    TextEditingController(),
    'Status':          TextEditingController(),
    'Created Time':    TextEditingController(text: '12:35:00'),
    'Product Name':    TextEditingController(),
    'Product ID':      TextEditingController(),
    'Order Date':      TextEditingController(text: '19-04-2026'),
  };

  // Controllers for Filter
  final Map<String, TextEditingController> _filterControllers = {
    'Dispatch Date': TextEditingController(text: '19-04-2026'),
    'Order Date':    TextEditingController(text: '19-04-2026'),
  };

  // Left column fields (image: left side)
  final List<String> _leftFields = [
    'Dispatch no',
    'Order ID',
    'Customer ID',
    'Warehose',
    'Dispatch Date',
    'Total Quantity',
  ];

  // Right column fields (image: right side)
  final List<String> _rightFields = [
    'Total Amount',
    'Status',
    'Created Time',
    'Product Name',
    'Product ID',
    'Order Date',
  ];

  @override
  void initState() {
    super.initState();
    dispatchRecords = [
      {
        'id': '1',
        'dispatchNo': '-',
        'orderId': 'ORD-29-1775192568-3831',
        'customerId': '29',
        'warehouse': '-',
        'dispatchDate': '0000-00-00',
        'totalQuantity': '1',
        'totalAmount': '0',
        'status': '1',
        'createdTime': '-',
        'productName': 'Door Bell with Music',
        'productId': '49',
        'orderDate': '2026-04-03',
        'color': const Color(0xFF26A69A),
      },
      {
        'id': '2',
        'dispatchNo': '-',
        'orderId': 'ORD-34-1773138922-7449',
        'customerId': '34',
        'warehouse': '-',
        'dispatchDate': '0000-00-00',
        'totalQuantity': '1',
        'totalAmount': '1',
        'status': '1',
        'createdTime': '-',
        'productName': '89',
        'productId': '89',
        'orderDate': '2026-03-10',
        'color': const Color(0xFF4CAF50),
      },
      {
        'id': '3',
        'dispatchNo': '-',
        'orderId': 'ORD-34-1773137040-5323',
        'customerId': '34',
        'warehouse': '-',
        'dispatchDate': '0000-00-00',
        'totalQuantity': '1',
        'totalAmount': '1',
        'status': '1',
        'createdTime': '-',
        'productName': '89',
        'productId': '89',
        'orderDate': '2026-03-10',
        'color': const Color(0xFFFF9800),
      },
      {
        'id': '4',
        'dispatchNo': '-',
        'orderId': 'ORD-41-1772025597-2246',
        'customerId': '41',
        'warehouse': '-',
        'dispatchDate': '0000-00-00',
        'totalQuantity': '1',
        'totalAmount': '1',
        'status': '1',
        'createdTime': '-',
        'productName': '-give technical name & short description',
        'productId': '67',
        'orderDate': '2026-02-25',
        'color': const Color(0xFF26A69A),
      },
    ];
  }

  @override
  void dispose() {
    for (var c in _addControllers.values) {
      c.dispose();
    }
    for (var c in _filterControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveNewDispatch() {
    setState(() {
      final newEntry = {
        'id': (dispatchRecords.length + 1).toString(),
        'dispatchNo':    _addControllers['Dispatch no']!.text,
        'orderId':       _addControllers['Order ID']!.text,
        'customerId':    _addControllers['Customer ID']!.text,
        'warehouse':     _addControllers['Warehose']!.text,
        'dispatchDate':  _addControllers['Dispatch Date']!.text,
        'totalQuantity': _addControllers['Total Quantity']!.text,
        'totalAmount':   _addControllers['Total Amount']!.text,
        'status':        _addControllers['Status']!.text.isEmpty ? '1' : _addControllers['Status']!.text,
        'createdTime':   _addControllers['Created Time']!.text,
        'productName':   _addControllers['Product Name']!.text,
        'productId':     _addControllers['Product ID']!.text,
        'orderDate':     _addControllers['Order Date']!.text,
        'color': const Color(0xFF26A69A),
      };

      if (newEntry['dispatchNo'].toString().isNotEmpty ||
          newEntry['orderId'].toString().isNotEmpty) {
        dispatchRecords.insert(0, newEntry);
      }

      _currentView = DispatchView.viewList;
      for (var key in _addControllers.keys) {
        if (!key.contains('Date') && key != 'Created Time') {
          _addControllers[key]!.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF26A69A);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 380;
    final horizontalPadding = size.width * 0.06;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: 40,
            ),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () {
                        if (_currentView == DispatchView.viewList) {
                          Navigator.pop(context);
                        } else {
                          setState(() => _currentView = DispatchView.viewList);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Text(
                      _currentView == DispatchView.addNew
                          ? 'Add New Dispatch'
                          : _currentView == DispatchView.filterList
                          ? 'Filter Records'
                          : 'Dispatchment Portal',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DispatchNotificationDetail(),
                        ),
                      ),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.notifications_none_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                if (_currentView == DispatchView.viewList) ...[
                  const SizedBox(height: 32),
                  Text(
                    'Manage Shipments',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track and confirm order dispatches',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildHeaderAction(
                          icon: Icons.add_circle_outline_rounded,
                          label: 'Add New',
                          onTap: () => setState(
                                  () => _currentView = DispatchView.addNew),
                          isSmallScreen: isSmallScreen,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildHeaderAction(
                          icon: Icons.history_rounded,
                          label: 'View Logs',
                          onTap: () {},
                          isSmallScreen: isSmallScreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── BODY ────────────────────────────────────────────────────────
          Expanded(
            child: _buildMainContent(
                isSmallScreen, horizontalPadding, primaryColor),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN CONTENT SWITCHER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMainContent(
      bool isSmallScreen, double horizontalPadding, Color primaryColor) {
    switch (_currentView) {
      case DispatchView.addNew:
        return _buildAddNewForm(primaryColor);
      case DispatchView.filterList:
        return _buildFilterForm(primaryColor);
      case DispatchView.viewList:
        return _buildViewList(isSmallScreen, horizontalPadding, primaryColor);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VIEW LIST — Table like image 1
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildViewList(
      bool isSmallScreen, double horizontalPadding, Color primaryColor) {
    return Column(
      children: [
        // Filter bar
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sorted by',
                      style: GoogleFonts.outfit(
                          color: Colors.blueGrey[300], fontSize: 12)),
                  Row(
                    children: [
                      Text('Recent Dispatch',
                          style: GoogleFonts.outfit(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 13 : 15,
                          )),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: primaryColor, size: 20),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () =>
                    setState(() => _currentView = DispatchView.filterList),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: isSmallScreen ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text('Filter',
                          style: GoogleFonts.outfit(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 12 : 14,
                          )),
                      const SizedBox(width: 8),
                      Icon(Icons.tune_rounded,
                          color: primaryColor,
                          size: isSmallScreen ? 16 : 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Card List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: dispatchRecords.length,
            itemBuilder: (context, index) =>
                _buildDispatchCard(dispatchRecords[index], isSmallScreen),
          ),
        ),
      ],
    );
  }
  Widget _buildDispatchCard(Map<String, dynamic> data, bool isSmallScreen) {
    const darkColor = Color(0xFF1E234E);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Top section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Product name + status badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                color: darkColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Product ID: ${data['productId']}',
                              style: GoogleFonts.outfit(
                                  color: Colors.blueGrey[300], fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Warehouse → Customer route
                  Row(
                    children: [
                      _buildRoutePoint('Warehouse', data['warehouse'] ?? '-'),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: List.generate(
                                isSmallScreen ? 6 : 10,
                                    (i) => Expanded(
                                  child: Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    color: Colors.blueGrey[100],
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.local_shipping_rounded,
                                color: darkColor, size: 16),
                          ],
                        ),
                      ),
                      _buildRoutePoint(
                          'Customer ID', data['customerId'] ?? '-',
                          alignRight: true),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dates row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabelValue('Order Date', data['orderDate'] ?? '-'),
                      _buildLabelValue(
                          'Dispatch Date', data['dispatchDate'] ?? '-',
                          alignRight: true),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Container(
                height: 1,
                color: Colors.grey[100],
                margin: const EdgeInsets.symmetric(horizontal: 16)),

            // Bottom info bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniInfo(Icons.confirmation_number_outlined,
                          'DP No', data['dispatchNo'] ?? '-'),
                      _buildMiniInfo(Icons.list_alt_rounded, 'Order ID',
                          (data['orderId'] ?? '-').toString().length > 14
                              ? '${data['orderId'].toString().substring(0, 14)}...'
                              : data['orderId'] ?? '-'),
                      _buildMiniInfo(Icons.inventory_2_outlined, 'Qty',
                          data['totalQuantity'] ?? '-'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniInfo(Icons.access_time_rounded, 'Created',
                          data['createdTime'] ?? '-'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total Amount',
                              style: GoogleFonts.outfit(
                                  color: Colors.blueGrey[400], fontSize: 10)),
                          Text(
                            '₹${data['totalAmount'] ?? '0'}',
                            style: GoogleFonts.outfit(
                              color: darkColor,
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutePoint(String label, String value,
      {bool alignRight = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
        alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              GoogleFonts.outfit(color: Colors.blueGrey[300], fontSize: 9)),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: const Color(0xFF1E234E),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value,
      {bool alignRight = false}) {
    return Column(
      crossAxisAlignment:
      alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            GoogleFonts.outfit(color: Colors.blueGrey[300], fontSize: 9)),
        Text(value,
            style: GoogleFonts.outfit(
                color: const Color(0xFF1E234E),
                fontWeight: FontWeight.bold,
                fontSize: 12)),
      ],
    );
  }

  Widget _buildMiniInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.blueGrey[400]),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.outfit(
                    color: Colors.blueGrey[300], fontSize: 8)),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: const Color(0xFF1E234E),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Unused table methods removed.
  // ═══════════════════════════════════════════════════════════════════════════
  // ADD NEW FORM — 2 column layout like image 2
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildAddNewForm(Color primaryColor) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 2-column grid of fields
                  ...List.generate(_leftFields.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          // Left field
                          Expanded(
                            child: _buildTwoColField(
                              label: _leftFields[i],
                              controller: _addControllers[_leftFields[i]]!,
                              primaryColor: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Right field
                          Expanded(
                            child: _buildTwoColField(
                              label: _rightFields[i],
                              controller: _addControllers[_rightFields[i]]!,
                              primaryColor: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Save button (bottom right like image 2)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _saveNewDispatch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('Save',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColField({
    required String label,
    required TextEditingController controller,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: const Color(0xFF1E234E),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: GoogleFonts.outfit(fontSize: 13),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.outfit(
                fontSize: 12, color: Colors.blueGrey[200]),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blueGrey[100]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blueGrey[100]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FILTER FORM
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildFilterForm(Color primaryColor) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTwoColField(
              label: 'Dispatch Date',
              controller: _filterControllers['Dispatch Date']!,
              primaryColor: primaryColor),
          const SizedBox(height: 16),
          _buildTwoColField(
              label: 'Order Date',
              controller: _filterControllers['Order Date']!,
              primaryColor: primaryColor),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(
                          () => _currentView = DispatchView.viewList),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.blueGrey[200]!),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.outfit(
                          color: Colors.blueGrey[400],
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(
                          () => _currentView = DispatchView.viewList),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Apply Filter',
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeaderAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF26A69A),
                size: isSmallScreen ? 18 : 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: const Color(0xFF26A69A),
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}