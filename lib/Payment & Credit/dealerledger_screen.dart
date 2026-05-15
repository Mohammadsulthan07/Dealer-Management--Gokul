import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DealerLedgerScreen extends StatefulWidget {
  const DealerLedgerScreen({super.key});

  @override
  State<DealerLedgerScreen> createState() => _DealerLedgerScreenState();
}

class _DealerLedgerScreenState extends State<DealerLedgerScreen> {
  bool _isCreditExpanded = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Dealer Ledger',
          style: GoogleFonts.outfit(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width > 600 ? size.width * 0.15 : 16, 
            vertical: 8
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildLedgerCard(
                icon: Icons.account_balance_wallet,
                iconColor: Colors.orange,
                title: 'Main Account',
                subtitle: 'Reconciled',
                amount: '₹ 12,45,000',
                subAmount: 'Updated Today',
              ),
              const SizedBox(height: 16),
              
              // Expandable Card (like Ethereum in reference image)
              Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isCreditExpanded = !_isCreditExpanded),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildIconContainer(Icons.credit_card, const Color(0xFF26A69A)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Credit Line', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.green, size: 14),
                                      const SizedBox(width: 4),
                                      Text('Reconciled', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹ 2,30,000', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                const SizedBox(height: 4),
                                Text('Used / Limit: ₹5L', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[500])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    if (_isCreditExpanded) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 20, bottom: 8),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                color: Colors.grey[300],
                                margin: const EdgeInsets.only(left: 8, right: 24),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildSubItem('Inv #4029', '₹ 1,00,000', 'Due 12 Aug', const Color(0xFF26A69A), 'I'),
                                    const SizedBox(height: 16),
                                    _buildSubItem('Inv #4030', '₹ 1,30,000', 'Due 18 Aug', Colors.blue, 'I'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _isCreditExpanded = false),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Hide invoices', style: GoogleFonts.outfit(color: const Color(0xFF26A69A), fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_up, color: Color(0xFF26A69A), size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildLedgerCard(
                icon: Icons.hourglass_top,
                iconColor: Colors.red[400]!,
                title: 'Pending Clearance',
                subtitle: 'Action Required',
                amount: '₹ 45,500',
                subAmount: '2 Cheques',
                isReconciled: false,
              ),
              const SizedBox(height: 16),

              _buildLedgerCard(
                icon: Icons.monetization_on_outlined,
                iconColor: Colors.indigo,
                title: 'Advance Payment',
                subtitle: 'Reconciled',
                amount: '₹ 80,000',
                subAmount: 'To be adjusted',
              ),
              const SizedBox(height: 16),

               _buildLedgerCard(
                icon: Icons.shopping_bag_outlined,
                iconColor: Colors.pink,
                title: 'Reward Points',
                subtitle: 'Synchronised',
                amount: '12,500 Pts',
                subAmount: 'Value: ₹12,500',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 15,
          offset: const Offset(0, 5),
        )
      ],
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildSubItem(String title, String amount, String subtitle, Color avatarColor, String initial) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: avatarColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(initial, style: GoogleFonts.outfit(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 15)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Text(amount, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)),
             const SizedBox(height: 2),
             Text(subtitle, style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 12)),
          ],
        )
      ],
    );
  }

  Widget _buildLedgerCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required String subAmount,
    bool isReconciled = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIconContainer(icon, iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(isReconciled ? Icons.check_circle : Icons.error_outline, color: isReconciled ? Colors.green : Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(subAmount, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }
}
