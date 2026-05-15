import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../Order Managment/orderdetails_screen.dart';
import '../Order Managment/confirmorders_screen.dart';
import '../Order Managment/dispatchment_screen.dart';
import '../Order Managment/dealersalesinvoice_screen.dart';
import '../Order Managment/ordertracking_screen.dart';
import '../Pricing & Schemes/price_screen.dart';
import '../Pricing & Schemes/discountschems_screen.dart';
import '../Inventory & Returns/purchasereturn_screen.dart';
import '../Inventory & Returns/stockavailability_screen.dart';
import '../Inventory & Returns/salesreturn_screen.dart';
import '../Inventory & Returns/replacementcredit_screen.dart';
import '../Payment & Credit/paymentreconciliation_screen.dart';
import '../Payment & Credit/paymentcollections_screen.dart';
import '../Payment & Credit/creditmanagement_screen.dart';
import '../Payment & Credit/dealerledger_screen.dart';
import '../Dealer Reports/salescollection_screen.dart';
import '../Dealer Reports/dealerperformance_screen.dart';
import '../Dealer Details/wishlist_screen.dart';
import '../Dealer Details/licenseupload_screen.dart';
import '../Dealer Details/advertisement_screen.dart';
import '../Dealer Details/orderstatus_screen.dart';
import '../Dealer Details/specialdeals_screen.dart';
import '../Access Control/accesscontrol_screen.dart';
import '../Profile/profile_screen.dart';
import '../Help Support/helpsupport_screen.dart';
import 'notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: _buildCustomDrawer(context),
        body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).padding.top > 0 ? MediaQuery.of(context).padding.top : 24,
            color: Colors.black,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPremiumHeader(context),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopCardsGrid(),
                        const SizedBox(height: 20),
                        _buildQuickActionsTopText(),
                        const SizedBox(height: 12),
                        _buildQuickActionsCards(),
                        const SizedBox(height: 20),
                        _buildSalesOverviewSection(),
                        const SizedBox(height: 20),
                        _buildReportAnalyticsSection(),
                        const SizedBox(height: 20),
                        _buildRecentOrdersSection(),
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
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF26A69A),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                Expanded(  
                  child: Text(
                    'Dealer Management',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                ),
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/Profile.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopCardsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDashCard(
                title: "Total Sales",
                value: "₹24.5L",
                subtitle: "+12%",
                gradientColors: const [Color(0xFFF70E37), Color(0xFFFF869B)],
                iconBgColor: const Color(0xFFFFA6B5),
                iconBorderColor: const Color(0xFFFFAAB9),
                imageName: "Card1.png",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDashCard(
                title: "Total Orders",
                value: "1,247",
                subtitle: "+8.3%",
                gradientColors: const [Color(0xFF3A00CA), Color(0xFF8E60FF)],
                iconBgColor: const Color(0xFFBA9FFF),
                iconBorderColor: const Color(0xFFBA9FFF),
                imageName: "Card2.png",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDashCard(
                title: "Invoice",
                value: "1,189",
                subtitle: "+5.3%",
                gradientColors: const [Color(0xFF018477), Color(0xFF15F3DD)],
                iconBgColor: Colors.white.withValues(alpha: 0.2),
                iconBorderColor: Colors.transparent,
                imageName: "Card3.png",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDashCard(
                title: "Collections",
                value: "36.0",
                subtitle: "+3.1%",
                gradientColors: const [Color(0xFFA8076A), Color(0xFFFF7CCD)],
                iconBgColor: Colors.white.withValues(alpha: 0.2),
                iconBorderColor: Colors.transparent,
                imageName: "Card4.png",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashCard({
    required String title,
    required String value,
    required String subtitle,
    required List<Color> gradientColors,
    required Color iconBgColor,
    required Color iconBorderColor,
    required String imageName,
  }) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBgColor,
                border: Border.all(color: iconBorderColor, width: 0.5),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/Dashboard/$imageName',
                width: 14,
                height: 14,
                errorBuilder: (ctx, err, stk) => const Icon(Icons.insert_chart, size: 14, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsTopText() {
    return Text(
      'Quick Actions',
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildQuickActionsCards() {
    return Container(
      width: double.infinity,
      height: 115,
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickActionItem("Add\nDealer", "Add Dealer.png", const [Color(0xFFF7143C), Color(0xFFFD6A84)], () {
             Navigator.push(context, CupertinoPageRoute(builder: (context) => const AdvertisementScreen())); 
          }),
          _buildQuickActionItem("Approve", "Approve.png", const [Color(0xFF02897B), Color(0xFF13EAD4)], () {
             Navigator.push(context, CupertinoPageRoute(builder: (context) => const OrderDetailsScreen()));
          }),
          _buildQuickActionItem("Create\nOrder", "Create Order.png", const [Color(0xFF3C03CB), Color(0xFF895BFC)], () {
             Navigator.push(context, CupertinoPageRoute(builder: (context) => const ConfirmOrdersScreen()));
          }),
          _buildQuickActionItem("Invoice", "Invoice.png", const [Color(0xFFB31677), Color(0xFFFC79CA)], () {
             Navigator.push(context, CupertinoPageRoute(builder: (context) => const DealerSalesInvoiceScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(String title, String imageName, List<Color> gradientColors, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/Dashboard/$imageName',
              width: 24,
              height: 24,
              errorBuilder: (ctx, err, stk) => Container(
                width: 24, height: 24,
                decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                child: const Icon(Icons.touch_app, size: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesOverviewSection() {
    return Container(
      width: double.infinity,
      height: 221,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Overview',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '₹2.85M',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF26A69A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300],
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[400]!, width: 2),
                    left: BorderSide(color: Colors.grey[400]!, width: 2),
                    top: BorderSide.none,
                    right: BorderSide.none,
                  ),
                ),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(3, 5),
                      FlSpot(5, 5),
                      FlSpot(9, 3.5),
                      FlSpot(11, 5.5)
                    ],
                    isCurved: true,
                    color: const Color(0xFF0288D1),
                    barWidth: 4,
                    shadow: BoxShadow(color: const Color(0xFF0288D1).withValues(alpha: 0.5), blurRadius: 6, offset: const Offset(0, 3)),
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(radius: 6, color: const Color(0xFF0288D1), strokeWidth: 0);
                      },
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(3, 3),
                      FlSpot(6, 1.5),
                      FlSpot(9, 1.2),
                      FlSpot(11, 2),
                    ],
                    isCurved: true,
                    color: const Color(0xFFC0CA33),
                    barWidth: 4,
                    shadow: BoxShadow(color: const Color(0xFFC0CA33).withValues(alpha: 0.5), blurRadius: 6, offset: const Offset(0, 3)),
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(radius: 6, color: const Color(0xFFC0CA33), strokeWidth: 0);
                      },
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(3, 2.9),
                      FlSpot(6, 3),
                      FlSpot(9, 2.5),
                      FlSpot(11, 3),
                    ],
                    isCurved: true,
                    color: const Color(0xFFF4511E),
                    barWidth: 4,
                    shadow: BoxShadow(color: const Color(0xFFF4511E).withValues(alpha: 0.5), blurRadius: 6, offset: const Offset(0, 3)),
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(radius: 6, color: const Color(0xFFF4511E), strokeWidth: 0);
                      },
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(3, 2),
                      FlSpot(5, 1.4),
                      FlSpot(9, 4.3),
                      FlSpot(11, 5),
                    ],
                    isCurved: true,
                    color: const Color(0xFF26A69A),
                    barWidth: 4,
                    shadow: BoxShadow(color: const Color(0xFF26A69A).withValues(alpha: 0.5), blurRadius: 6, offset: const Offset(0, 3)),
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(radius: 6, color: const Color(0xFF26A69A), strokeWidth: 0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportAnalyticsSection() {
    return Container(
      width: double.infinity,
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Analytics',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildAnalyticsBar("JAN", const Color(0xFF0288D1), 0.2, "20%"),
                _buildAnalyticsBar("FEB", const Color(0xFF26A69A), 0.3, "30%"),
                _buildAnalyticsBar("MAR", const Color(0xFFF4511E), 0.85, "40%"),
                _buildAnalyticsBar("APR", const Color(0xFFFFA000), 0.4, "25%"),
                _buildAnalyticsBar("MAY", const Color(0xFFC0CA33), 0.6, "36%"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsBar(String month, Color color, double heightFactor, String percentage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          percentage,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 20,
              height: 124,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ),
            Container(
              width: 35,
              height: 124 * heightFactor,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          month,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
         'View All',
            style: GoogleFonts.inter(
           fontSize: 14,
           fontWeight: FontWeight.w600,
           color: const Color(0xFF0288D1),
           decoration: TextDecoration.underline,
           decorationColor: const Color(0xFF0288D1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRecentOrderCard("ORD - 2401", "ABC Traders - Dec 1", "1 item(s)", "₹ 59,500", "Approved", const Color(0xFF037712), const Color(0xFF037712), Colors.white),
        const SizedBox(height: 12),
        _buildRecentOrderCard("ORD - 2405", "XYZ Enterprises - Dec 12", "1 item(s)", "₹ 48,500", "Rejected", const Color(0xFFA60D0D), const Color(0xFFA60D0D), Colors.white),
        const SizedBox(height: 12),
        _buildRecentOrderCard("ORD - 2404", "ABC Traders - Dec 1", "1 item(s)", "₹ 79,500", "Approved", const Color(0xFF037712), const Color(0xFF037712), Colors.white),
        const SizedBox(height: 12),
        _buildRecentOrderCard("ORD - 2402", "XYZ Enterprises - Dec 5", "1 item(s)", "₹ 79,500", "Pending", const Color(0xFFDD5C2D), const Color(0xFFDD5C2D), Colors.white),
      ],
    );
  }

  Widget _buildRecentOrderCard(String orderId, String details, String items, String price, String status, Color statusColor, Color statusBgColor, Color statusTextColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0E5663),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                details,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                price,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                items,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF26A69A),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_balance, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                Text(
                  'DEALER MANAGEMENT',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _buildDrawerItem('Dashboard', Icons.dashboard_outlined, () => Navigator.pop(context)),
                _buildDrawerItem('Profile', Icons.person_outline, () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const ProfileScreen()));
                }),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text('MANAGEMENT', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.2)),
                ),
                
                ..._buildManagementDropdowns(context),

                const Divider(),
                _buildDrawerItem('Help & Support', Icons.help_outline_rounded, () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const HelpSupportScreen()));
                }),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: Text('Logout', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  onTap: () {},
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF26A69A)),
      title: Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      onTap: onTap,
    );
  }

  List<Widget> _buildManagementDropdowns(BuildContext context) {
    final modules = [
      {'title': 'Order Management', 'icon': Icons.assignment_outlined, 'subItems': ['Order Details', 'Confirm Orders', 'Dispatchment', 'Dealer Sales Invoice', 'Order Tracking']},
      {'title': 'Pricing & Schemes', 'icon': Icons.local_offer_outlined, 'subItems': ['Price', 'Discount Schemes']},
      {'title': 'Inventory & Returns', 'icon': Icons.inventory_2_outlined, 'subItems': ['Purchase return', 'Stock Availability', 'Sales return', 'Replacement/ Credit Note']},
      {'title': 'Payment & Credit', 'icon': Icons.account_balance_wallet_outlined, 'subItems': ['Payment Collections', 'Credit Management', 'Payment Reconciliation', 'Dealer Ledger']},
      {'title': 'Dealer Reports', 'icon': Icons.analytics_outlined, 'subItems': ['Sales & Collection Report', 'Dealer performance']},
      {'title': 'Dealer Details', 'icon': Icons.business_outlined, 'subItems': ['Wishlist', 'License Uploads', 'Advertisement', 'Order List', 'Special Deals']},
      {'title': 'Access Control', 'icon': Icons.security_outlined, 'subItems': []},
    ];

    return modules.map((m) {
      final title = m['title'] as String;
      final icon = m['icon'] as IconData;
      final subItems = List<String>.from(m['subItems'] as List);

      if (subItems.isEmpty) {
        return ListTile(
          leading: Icon(icon, color: const Color(0xFF26A69A)),
          title: Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
          onTap: () {
            _navigateToScreen(context, title);
          },
        );
      }

      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: const Color(0xFF26A69A)),
          title: Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
          iconColor: Colors.black,
          collapsedIconColor: Colors.black54,
          childrenPadding: const EdgeInsets.only(left: 32, bottom: 8),
          children: subItems.map((item) {
            return ListTile(
              dense: true,
              title: Text(item, style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500)),
              onTap: () {
                _navigateToScreen(context, item);
              },
            );
          }).toList(),
        ),
      );
    }).toList();
  }

  void _navigateToScreen(BuildContext context, String item) {
    if (item == 'Order Details') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetailsScreen()));
    } else if (item == 'Confirm Orders') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmOrdersScreen()));
    } else if (item == 'Dispatchment') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const DispatchmentScreen()));
    } else if (item == 'Dealer Sales Invoice') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const DealerSalesInvoiceScreen()));
    } else if (item == 'Order Tracking') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const OrderTrackingScreen()));
    } else if (item == 'Price') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const PriceScreen()));
    } else if (item == 'Discount Schemes') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const DiscountSchemesScreen()));
    } else if (item == 'Purchase return') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const PurchaseReturnScreen()));
    } else if (item == 'Stock Availability') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const StockAvailabilityScreen()));
    } else if (item == 'Sales return') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const SalesReturnScreen()));
    } else if (item == 'Replacement/ Credit Note') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const ReplacementCreditScreen()));
    } else if (item == 'Payment Collections') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const PaymentCollectionsScreen()));
    } else if (item == 'Credit Management') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const CreditManagementScreen()));
    } else if (item == 'Payment Reconciliation') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const PaymentReconciliationScreen()));
    } else if (item == 'Dealer Ledger') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const DealerLedgerScreen()));
    } else if (item == 'Sales & Collection Report') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const SalesCollectionScreen()));
    } else if (item == 'Dealer performance') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const DealerPerformanceScreen()));
    } else if (item == 'Wishlist') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const WishlistScreen()));
    } else if (item == 'License Uploads') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const LicenseUploadScreen()));
    } else if (item == 'Advertisement') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const AdvertisementScreen()));
    } else if (item == 'Order List') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const OrderStatusScreen()));
    } else if (item == 'Special Deals') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const SpecialDealsScreen()));
    } else if (item == 'Access Control') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => const AccessControlScreen()));
    }
  }
}
