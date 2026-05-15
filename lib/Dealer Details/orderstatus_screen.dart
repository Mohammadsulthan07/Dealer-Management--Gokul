import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

enum OrderListMode { view, add, edit }

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  OrderListMode _currentMode = OrderListMode.view;
  Map<String, dynamic>? _selectedRecord;

  final Color primaryColor = const Color(0xFF26A69A);
  final Color darkColor = const Color(0xFF1E234E);
  final Color bgColor = const Color(0xFFF1F5F9);

  // Location & Device info
  String _latitude = '0';
  String _longitude = '0';
  String _deviceId = 'unknown';

  final Map<String, TextEditingController> _controllers = {
    'ID': TextEditingController(),
    'Date': TextEditingController(),
    'Product Id': TextEditingController(),
    'Order Date': TextEditingController(),
    'Cus Id': TextEditingController(),
    'Quantity': TextEditingController(),
    'Total Price': TextEditingController(),
    'Order Status': TextEditingController(),
    'Payment Status': TextEditingController(),
    'Payment Method': TextEditingController(),
    'Billing Address': TextEditingController(),
    'Ship Method': TextEditingController(),
    'Tracking Number': TextEditingController(),
  };

  List<dynamic> orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initLocationAndDevice();
  }

  // ─── STEP 1: Get location permission + coordinates ───────────────────────
  Future<void> _initLocationAndDevice() async {
    await _getDeviceInfo();
    await _getLocation();
    _fetchOrders();
  }

  Future<void> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        setState(() {
          _deviceId = info.id; // Unique Android ID
        });
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        setState(() {
          _deviceId = info.identifierForVendor ?? 'ios-unknown';
        });
      }
      
      print('=== Original Device ID: $_deviceId ===');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_id', _deviceId);

    } catch (e) {
      debugPrint("Device info error: $e");
    }
  }

  Future<void> _getLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled.");
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint("Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint("Location permission permanently denied");
        return;
      }

      // Get current position (latitude & longitude)
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _latitude = position.latitude.toString();   // e.g. "13.0827"
        _longitude = position.longitude.toString(); // e.g. "80.2707"
      });

      print('=== Original Latitude: $_latitude, Original Longitude: $_longitude ===');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('latitude', _latitude);
      await prefs.setString('longitude', _longitude);

      debugPrint("Location: $_latitude, $_longitude");
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  // ─── STEP 2: Use lat, lng, device_id in API call ─────────────────────────
  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
        body: {
          'type': '2083',
          'cid': '85788578',
          'lt': _latitude,      // ← Real latitude from GPS
          'ln': _longitude,     // ← Real longitude from GPS
          'device_id': _deviceId, // ← Real device ID
          'form': 'sm_main_form_72601',
          'select': '*',
          'where': "qc_status like '%Pend%'",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          setState(() {
            orders = data['data'] ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _openAddMode() {
    _clearForm();
    setState(() {
      _currentMode = OrderListMode.add;
      _selectedRecord = null;
    });
  }

  void _openEditMode(Map<String, dynamic> record) {
    _controllers.forEach((key, controller) {
      controller.text = record[key]?.toString() ?? '';
    });
    setState(() {
      _currentMode = OrderListMode.edit;
      _selectedRecord = record;
    });
  }

  void _deleteRecord(Map<String, dynamic> record) {
    setState(() {
      orders.remove(record);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order deleted successfully')),
    );
  }

  void _saveData() {
    final newData = <String, dynamic>{};
    _controllers.forEach((key, controller) {
      newData[key] = controller.text;
    });

    setState(() {
      if (_currentMode == OrderListMode.add) {
        orders.insert(0, newData);
      } else if (_currentMode == OrderListMode.edit && _selectedRecord != null) {
        final index = orders.indexOf(_selectedRecord!);
        if (index != -1) {
          orders[index] = newData;
        }
      }
      _currentMode = OrderListMode.view;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentMode == OrderListMode.add ? 'Order created' : 'Order updated',
        ),
      ),
    );
  }

  void _clearForm() {
    for (var c in _controllers.values) {
      c.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 380;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _buildHeader(isSmallScreen),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _currentMode == OrderListMode.view
                  ? _buildListView(isSmallScreen)
                  : _buildFormView(isSmallScreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
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
                  if (_currentMode == OrderListMode.view) {
                    Navigator.pop(context);
                  } else {
                    setState(() => _currentMode = OrderListMode.view);
                  }
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                _currentMode == OrderListMode.view
                    ? 'Order Status'
                    : _currentMode == OrderListMode.add
                        ? 'Add New Order'
                        : 'Edit Order',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          if (_currentMode == OrderListMode.view) ...[
            const SizedBox(height: 24),
            Text(
              'Orders Management',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: isSmallScreen ? 22 : 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track and update dealer orders',
              style: GoogleFonts.outfit(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
            const SizedBox(height: 12),
            // Shows live location info in header
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Lat: $_latitude  |  Lng: $_longitude',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _openAddMode,
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: Text(
                'Add New',
                style: GoogleFonts.outfit(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListView(bool isSmallScreen) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 64, color: Colors.blueGrey[200]),
            const SizedBox(height: 16),
            Text('No orders found.',
                style:
                    GoogleFonts.outfit(color: Colors.blueGrey, fontSize: 16)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchOrders,
              style:
                  ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child:
                  const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final data = orders[index];
        return _buildOrderCard(data, isSmallScreen);
      },
    );
  }

  Widget _buildOrderCard(dynamic data, bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                border: Border(
                    bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.receipt_long,
                            color: primaryColor, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['id']?.toString() ?? '-',
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: darkColor,
                                fontSize: 14),
                          ),
                          Text(
                            data['dtime'] ?? '-',
                            style: GoogleFonts.outfit(
                                color: Colors.blueGrey[400], fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: Colors.blueGrey, size: 20),
                        onPressed: () =>
                            _openEditMode(Map<String, dynamic>.from(data)),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 20),
                        onPressed: () =>
                            _deleteRecord(Map<String, dynamic>.from(data)),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow('Product ID', data['prid']?.toString(),
                      'Cus ID', data['cus_id']?.toString()),
                  const SizedBox(height: 12),
                  _buildDetailRow('Status', data['status'],
                      'Payment Status', data['payment_status']),
                  const SizedBox(height: 12),
                  _buildDetailRow('Payment Method', data['payment_method'],
                      'Tracking No', data['tracking_number']),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Billing Address',
                                style: GoogleFonts.outfit(
                                    color: Colors.blueGrey[400],
                                    fontSize: 11)),
                            Text(data['billing_address'] ?? '-',
                                style: GoogleFonts.outfit(
                                    color: darkColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ],
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
    );
  }

  Widget _buildDetailRow(
      String label1, String? value1, String label2, String? value2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1,
                  style: GoogleFonts.outfit(
                      color: Colors.blueGrey[400], fontSize: 11)),
              Text(value1 ?? '-',
                  style: GoogleFonts.outfit(
                      color: darkColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2,
                  style: GoogleFonts.outfit(
                      color: Colors.blueGrey[400], fontSize: 11)),
              Text(value2 ?? '-',
                  style: GoogleFonts.outfit(
                      color: darkColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormView(bool isSmallScreen) {
    final keys = _controllers.keys.toList();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  for (int i = 0; i < keys.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Expanded(child: _buildTextField(keys[i])),
                          const SizedBox(width: 16),
                          if (i + 1 < keys.length)
                            Expanded(child: _buildTextField(keys[i + 1]))
                          else
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
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
                  color: Colors.black.withValues(alpha: 0.05),
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
                      setState(() => _currentMode = OrderListMode.view),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: Colors.blueGrey[200]!),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.outfit(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Save',
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: darkColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _controllers[label],
          style: GoogleFonts.outfit(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle:
                GoogleFonts.outfit(fontSize: 12, color: Colors.blueGrey[300]),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
    );
  }
}