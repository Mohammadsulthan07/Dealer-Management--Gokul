import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'confirmorders_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

enum OrderDetailsView { viewList, addNew, filterList }

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late List<Map<String, dynamic>> _orders;
  OrderDetailsView _currentView = OrderDetailsView.viewList;

  @override
  void initState() {
    super.initState();
    _orders = [
      {
        'ID': '1',
        'Customer ID': 'GBD99763JS',
        'Order ID': 'ORD-8822',
        'Product ID': 'PRD-900',
        'Order Status': 'Upcoming',
        'Order Date': '24/09/2024',
        'Tracking Number': 'TRK-99021',
        'Payment Method': 'Register',
        'Shipping Address': 'Infinity Event Center',
        'Price': '\$65',
        'Quantity': '1',
        'color': '0xFF7A8CFF' // Blue-ish
      },
      {
        'ID': '2',
        'Customer ID': 'GBD997275JP',
        'Order ID': 'ORD-9911',
        'Product ID': 'PRD-821',
        'Order Status': 'Past',
        'Order Date': '29/08/2024',
        'Tracking Number': 'TRK-88122',
        'Payment Method': 'View Detail',
        'Shipping Address': 'Inspire Impact Organizers',
        'Price': '\$75',
        'Quantity': '2',
        'color': '0xFFF1F54B' // Yellow
      },
      {
        'ID': '3',
        'Customer ID': 'GBD99711MK',
        'Order ID': 'ORD-1022',
        'Product ID': 'PRD-772',
        'Order Status': 'Past',
        'Order Date': '10/08/2024',
        'Tracking Number': 'TRK-77122',
        'Payment Method': 'View Detail',
        'Shipping Address': 'Trendsetters Collective',
        'Price': '\$95',
        'Quantity': '1',
        'color': '0xFFFF9CEE' // Pink
      },
      {
        'ID': '4',
        'Customer ID': 'GBD99812MK',
        'Order ID': 'ORD-2022',
        'Product ID': 'PRD-442',
        'Order Status': 'Past',
        'Order Date': '10/04/2024',
        'Tracking Number': 'TRK-55122',
        'Payment Method': 'View Detail',
        'Shipping Address': 'Art Art Organizer',
        'Price': '\$85',
        'Quantity': '3',
        'color': '0xFF96F2D1' // Green
      },
    ];
  }

  // Form Controllers
  final Map<String, TextEditingController> _controllers = {
    'Customer ID': TextEditingController(),
    'Order ID': TextEditingController(),
    'Product ID': TextEditingController(),
    'Order Status': TextEditingController(),
    'Order Date': TextEditingController(text: '19-04-2026'),
    'Payment Status': TextEditingController(),
    'Payment Method': TextEditingController(),
    'Shipping Address': TextEditingController(),
    'Billing Address': TextEditingController(),
    'Shipping Method': TextEditingController(),
    'Tracking Number': TextEditingController(),
    'Coupon Code': TextEditingController(),
    'PID Count': TextEditingController(),
    'Discount amount': TextEditingController(),
    'Shipping Cost': TextEditingController(),
    'Tax Amount': TextEditingController(),
    'Price': TextEditingController(),
    'Quantity': TextEditingController(),
    'Cancellation Date': TextEditingController(text: '19-04-2026'),
    'Cancellation Reason': TextEditingController(),
    'Cancelled By': TextEditingController(),
    'Refund Status': TextEditingController(),
    'Date': TextEditingController(text: '19-04-2026'),
    'Total Price': TextEditingController(),
    'Account Number': TextEditingController(),
    'Bank Name': TextEditingController(),
    'Holder Name': TextEditingController(),
    'IFSC': TextEditingController(),
  };

  final List<String> _allFields = [
    'Customer ID', 'Order ID', 'Product ID', 'Order Status', 'Order Date',
    'Payment Status', 'Payment Method', 'Shipping Address', 'Billing Address',
    'Shipping Method', 'Tracking Number', 'Coupon Code', 'PID Count',
    'Discount amount', 'Shipping Cost', 'Tax Amount', 'Price', 'Quantity',
    'Cancellation Date', 'Cancellation Reason', 'Cancelled By', 'Refund Status',
    'Date', 'Total Price', 'Account Number', 'Bank Name', 'Holder Name', 'IFSC'
  ];

  void _saveOrder() {
    setState(() {
      Map<String, dynamic> newOrder = {};
      
      for (var field in _allFields) {
        newOrder[field] = _controllers[field]!.text;
      }
      
      newOrder['ID'] = (_orders.length + 1).toString();
      newOrder['color'] = indexToColor(_orders.length);
      _orders.insert(0, newOrder);
      _currentView = OrderDetailsView.viewList;
      
      // Clear controllers
      for (var field in _allFields) {
        if (!field.contains('Date') && field != 'Date') _controllers[field]!.clear();
      }
    });
  }

  String indexToColor(int index) {
    List<String> colors = ['0xFF7A8CFF', '0xFFF1F54B', '0xFFFF9CEE', '0xFF96F2D1'];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order Details',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      floatingActionButton: _currentView == OrderDetailsView.viewList 
        ? FloatingActionButton.extended(
            onPressed: () => setState(() => _currentView = OrderDetailsView.addNew),
            backgroundColor: const Color(0xFF26A69A),
            icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white),
            label: Text('Add New Product', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        : null,
      body: SafeArea(
        child: Column(
          children: [
            _buildActionHeader(),
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_currentView) {
      case OrderDetailsView.addNew:
        return _buildAddOrderForm();
      case OrderDetailsView.filterList:
        return _buildFilterForm();
      case OrderDetailsView.viewList:
        return _buildOrderList();
    }
  }

  Widget _buildActionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildHeaderButton('Orders Active', Colors.grey[100]!, Colors.grey[700]!),
            const SizedBox(width: 8),
            _buildHeaderButton(
              'View List', 
              _currentView == OrderDetailsView.viewList ? const Color(0xFF26A69A).withValues(alpha: 0.1) : Colors.white, 
              _currentView == OrderDetailsView.viewList ? const Color(0xFF26A69A) : Colors.grey, 
              icon: Icons.grid_view_rounded,
              onTap: () => setState(() => _currentView = OrderDetailsView.viewList),
            ),
            const SizedBox(width: 8),
            _buildHeaderButton(
              'Filter', 
              _currentView == OrderDetailsView.filterList ? const Color(0xFF26A69A).withValues(alpha: 0.1) : Colors.white, 
              _currentView == OrderDetailsView.filterList ? const Color(0xFF26A69A) : Colors.grey, 
              icon: Icons.tune_rounded, // Professional filter icon
              onTap: () => setState(() => _currentView = OrderDetailsView.filterList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton(String label, Color bg, Color text, {IconData? icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: GoogleFonts.outfit(fontSize: 12, color: text, fontWeight: FontWeight.w600)),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: text),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _buildEventStyleCard(order);
      },
    );
  }

  Widget _buildEventStyleCard(Map<String, dynamic> order) {
    Color cardColor = Color(int.parse(order['color'] ?? '0xFF7A8CFF'));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colorful Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['Customer ID'] ?? 'N/A',
                  style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
                ),
                Text(
                  order['Order Date'] ?? 'N/A',
                  style: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID: ${order['Order ID'] ?? 'N/A'}',
                          style: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Product ID: ${order['Product ID'] ?? 'N/A'}',
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E234E)),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order['Order Status'] ?? 'Status',
                        style: GoogleFonts.outfit(color: cardColor, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Logistics Section
                _buildSectionTitle('Logistics'),
                _buildInfoGrid([
                  {'icon': Icons.local_shipping_outlined, 'label': 'Tracking', 'value': order['Tracking Number']},
                  {'icon': Icons.map_outlined, 'label': 'S. Method', 'value': order['Shipping Method']},
                  {'icon': Icons.location_on_outlined, 'label': 'S. Address', 'value': order['Shipping Address']},
                  {'icon': Icons.business_outlined, 'label': 'B. Address', 'value': order['Billing Address']},
                ]),
                
                const SizedBox(height: 16),
                // Payment & Pricing Section
                _buildSectionTitle('Payment & Pricing'),
                _buildInfoGrid([
                  {'icon': Icons.payments_outlined, 'label': 'Method', 'value': order['Payment Method']},
                  {'icon': Icons.verified_outlined, 'label': 'Status', 'value': order['Payment Status']},
                  {'icon': Icons.confirmation_number_outlined, 'label': 'Coupon', 'value': order['Coupon Code']},
                  {'icon': Icons.shopping_bag_outlined, 'label': 'Quantity', 'value': order['Quantity']},
                  {'icon': Icons.money_off_outlined, 'label': 'Discount', 'value': order['Discount amount']},
                  {'icon': Icons.receipt_long_outlined, 'label': 'Tax', 'value': order['Tax Amount']},
                  {'icon': Icons.attach_money_outlined, 'label': 'Price', 'value': order['Price']},
                  {'icon': Icons.account_balance_wallet_outlined, 'label': 'Total', 'value': order['Total Price']},
                ]),

                if ((order['Bank Name'] ?? '').isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSectionTitle('Bank Details'),
                  _buildInfoGrid([
                    {'icon': Icons.account_balance_outlined, 'label': 'Bank', 'value': order['Bank Name']},
                    {'icon': Icons.numbers_outlined, 'label': 'Acc No', 'value': order['Account Number']},
                    {'icon': Icons.person_outline, 'label': 'Holder', 'value': order['Holder Name']},
                    {'icon': Icons.code_outlined, 'label': 'IFSC', 'value': order['IFSC']},
                  ]),
                ],

                if ((order['Cancellation Reason'] ?? '').isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSectionTitle('Cancellation info', color: Colors.redAccent),
                  _buildInfoGrid([
                    {'icon': Icons.event_busy_outlined, 'label': 'Date', 'value': order['Cancellation Date']},
                    {'icon': Icons.info_outline, 'label': 'Reason', 'value': order['Cancellation Reason']},
                    {'icon': Icons.person_off_outlined, 'label': 'By', 'value': order['Cancelled By']},
                    {'icon': Icons.history_outlined, 'label': 'Refund', 'value': order['Refund Status']},
                  ]),
                ],
                
                const SizedBox(height: 20),
                Divider(color: Colors.grey[100], thickness: 1),
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Amount', style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w500)),
                        Text(
                          order['Total Price']?.startsWith('\$') == true ? order['Total Price']! : '\$${order['Total Price'] ?? '0'}',
                          style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF1E234E)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildCardActionBtn('Edit', cardColor, () {}),
                        const SizedBox(width: 10),
                        _buildCardActionBtn(
                          'Confirm Order', 
                          const Color(0xFF1E234E), 
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmOrdersScreen(initialOrder: order),
                            ),
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
    );
  }

  Widget _buildSectionTitle(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 10, 
          fontWeight: FontWeight.bold, 
          color: color ?? Colors.grey[400],
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildInfoGrid(List<Map<String, dynamic>> items) {
    List<Widget> rows = [];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(child: _buildCardInfoRow(items[i]['icon'], items[i]['label'], items[i]['value'] ?? '-')),
              const SizedBox(width: 8),
              if (i + 1 < items.length)
                Expanded(child: _buildCardInfoRow(items[i + 1]['icon'], items[i + 1]['label'], items[i + 1]['value'] ?? '-'))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildCardInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[400]),
          const SizedBox(width: 8),
          Text('$label ', style: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 12)),
          Expanded(
            child: Text(value, style: GoogleFonts.outfit(color: const Color(0xFF1E234E), fontWeight: FontWeight.w600, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildCardActionBtn(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Text(label, style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFilterForm() {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Orders',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E234E)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildFilterField('Order Date')),
                const SizedBox(width: 16),
                Expanded(child: _buildFilterField('Date')),
              ],
            ),
            const SizedBox(height: 16),
            _buildFilterField('Cancellation Date'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => _currentView = OrderDetailsView.viewList),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Apply Filters', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[700])),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: TextField(
            controller: _controllers[label],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
              hintText: '08-04-2026',
              hintStyle: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[400]),
            ),
            style: GoogleFonts.outfit(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAddOrderForm() {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF26A69A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Form',
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Fill in the details to create a new order',
                          style: GoogleFonts.outfit(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // Form Fields
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildFormGrid(),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() => _currentView = OrderDetailsView.viewList),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: Colors.grey[200]!),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Discard', style: GoogleFonts.outfit(color: Colors.grey[600], fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveOrder,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF26A69A),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Submit Order', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormGrid() {
    return Column(
      children: [
        for (int i = 0; i < _allFields.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildMedlioTextField(_allFields[i])),
                const SizedBox(width: 16),
                if (i + 1 < _allFields.length)
                  Expanded(child: _buildMedlioTextField(_allFields[i + 1]))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMedlioTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFF1E234E), fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.outfit(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controllers[label],
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF26A69A), width: 1.5),
              ),
            ),
            style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF1E234E)),
          ),
        ],
      ),
    );
  }
}
