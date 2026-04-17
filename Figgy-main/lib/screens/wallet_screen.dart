import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/services/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService _wallet = WalletService();
  bool _loading = true;
  int _balance = 0;
  List<WalletTransaction> _txs = const [];
  String _selectedFilter = 'Payouts';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final txs = await _wallet.getTransactions();
    final bal = txs.fold<int>(0, (s, t) => s + t.amountInr);
    if (!mounted) return;
    setState(() {
      _txs = txs;
      _balance = bal;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.brandPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My wallet',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.brandPrimary))
          : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.brandPrimary,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 80), // Space for AppBar (extendBodyBehindAppBar)
                  _buildMainBalanceCard(),
                  const SizedBox(height: 32),
                  _buildFilterTabs(),
                  const SizedBox(height: 24),
                  if (_txs.isEmpty) _buildEmptyState() else ..._txs.map(_buildTxTile),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildMainBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE67E22), // Matching the image's orange
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE67E22).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total balance', style: AppTypography.bodySmall.copyWith(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('₹ ${_balance.toStringAsFixed(2)}', style: AppTypography.h1.copyWith(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text('UPI: worker@upi · verified', style: AppTypography.small.copyWith(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w700, fontSize: 10)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Withdraw', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Edit UPI', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppStyles.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_rounded, color: AppColors.brandPrimary, size: 44),
          ),
          const SizedBox(height: 20),
          Text('No transactions yet', style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(
            'Premium payments and claim payouts will appear here.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _buildFilterBtn('Payouts'),
        const SizedBox(width: 12),
        _buildFilterBtn('Premiums\npaid'),
        const SizedBox(width: 12),
        _buildFilterBtn('Pending'),
      ],
    );
  }

  Widget _buildFilterBtn(String label) {
    final bool active = _selectedFilter.replaceAll('\n', ' ') == label.replaceAll('\n', ' ');
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label.replaceAll('\n', ' ')),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: active ? Colors.black.withOpacity(0.3) : const Color(0xFFF3F3F1), width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 14,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTxTile(WalletTransaction tx) {
    final isPayout = tx.category == 'payout';
    final amountSign = isPayout ? '+' : '-';
    final amountColor = isPayout ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F3F1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.reason, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w900, color: Colors.black)),
                const SizedBox(height: 4),
                Text(
                  'Apr 2 · Heavy rain · Smart Saver', // Mocking details to match image
                  style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$amountSign ₹ ${tx.amountInr.abs()}',
            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w900, color: amountColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

