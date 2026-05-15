import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentReconciliationScreen extends StatefulWidget {
  const PaymentReconciliationScreen({super.key});

  @override
  State<PaymentReconciliationScreen> createState() => _PaymentReconciliationScreenState();
}

class _PaymentReconciliationScreenState extends State<PaymentReconciliationScreen> {
  final List<double> amounts = [5, 10, 20, 50, 100, 150, 200, 250];
  double selectedAmount = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Payment', style: GoogleFonts.outfit(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Methods', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.account_balance, color: Colors.purple),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bank Transfer (BNO)', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                          Text('**** **** **** 5324', style: GoogleFonts.outfit(color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text('Payment Amount', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16)),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '\$ ', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold)),
                          TextSpan(text: selectedAmount.toStringAsFixed(2).replaceAll('.', ','), style: GoogleFonts.outfit(color: Colors.black87, fontSize: 40, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: amounts.length,
                itemBuilder: (context, index) {
                  final amount = amounts[index];
                  final isSelected = amount == selectedAmount;
                  return InkWell(
                    onTap: () => setState(() => selectedAmount = amount),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF26A69A).withValues(alpha: 0.3) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? const Color(0xFF26A69A) : Colors.grey.withValues(alpha: 0.3)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '\$${amount.toInt()}',
                        style: GoogleFonts.outfit(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.black87 : Colors.grey[700],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showPaymentOptions(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Payment',
                    style: GoogleFonts.outfit(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                     BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
                  ]
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Detail Payment', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                        Text('Bank Transfer (BNO)', style: GoogleFonts.outfit(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('From', 'Top Up Neopay'),
                    _buildDetailRow('To', '\$200.00'),
                    _buildDetailRow('Amount', '\$1.00'),
                    _buildDetailRow('Tax', '\$201.00', isTotal: true),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: Colors.grey, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: GoogleFonts.outfit(color: isTotal ? Colors.black87 : Colors.grey, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  void _showPaymentOptions(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _PaymentOptionsModal(),
      );
  }
}

class _PaymentOptionsModal extends StatefulWidget {
  @override
  State<_PaymentOptionsModal> createState() => _PaymentOptionsModalState();
}

class _PaymentOptionsModalState extends State<_PaymentOptionsModal> {
  String selectedMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text('Payment Method', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 40), // Balance the flex
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildPaymentOption('Credit Card', '+1 6006 **** 24', 'assets/mastercard_logo.png'),
                  const SizedBox(height: 16),
                  _buildPaymentOption('Paytm', '5221 **** 2465', 'assets/paytm_logo.png'),
                  const SizedBox(height: 16),
                  _buildPaymentOption('Google Pay', '4142 **** 7667', 'assets/gpay_logo.png'),
                  
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF26A69A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            const Icon(Icons.local_offer, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text('Promo Code', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E1A23),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            elevation: 0,
                          ),
                          child: Text('Apply', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),
                  _buildSummaryRow('Transfer Amount', '\$7.20'),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Additional Cost', '\$0.5'),
                  const SizedBox(height: 16),
                  Container(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Total', '\$7.25', isTotal: true),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 150, width: 150, child: AnimatedCheck()),
                            const SizedBox(height: 24),
                            Text('Payment Successful!', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Your transaction was completed.', style: GoogleFonts.outfit(color: Colors.grey)),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); 
                                  Navigator.pop(context); 
                                  Navigator.pop(context); 
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF26A69A),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                ),
                                child: Text('Back to Dashboard', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1A23),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: Text('Pay', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, String iconPath) {
    final isSelected = selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = title),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.black : Colors.transparent, width: 1.5),
          boxShadow: [
             BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ]
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 40, height: 40, fit: BoxFit.contain),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!, width: 2),
                color: isSelected ? Colors.black : Colors.transparent,
              ),
              child: isSelected 
                ? const Icon(Icons.circle, color: Colors.white, size: 10)
                : null,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
     return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Text(label, style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500)),
         Text(value, style: GoogleFonts.outfit(color: Colors.black87, fontSize: isTotal ? 18 : 16, fontWeight: FontWeight.bold)),
       ],
     );
  }
}

class AnimatedCheck extends StatefulWidget {
  const AnimatedCheck({super.key});

  @override
  State<AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF26A69A),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 80),
      ),
    );
  }
}
