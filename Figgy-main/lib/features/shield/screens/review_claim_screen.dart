import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../../../services/api_service.dart';
import 'dart:convert';

class ReviewClaimScreen extends StatefulWidget {
  final bool isAppeal;
  final String? claimId;
  final String? reason;
  final List<String>? proofUrls;

  const ReviewClaimScreen({
    super.key, 
    this.isAppeal = false,
    this.claimId,
    this.reason,
    this.proofUrls,
  });

  @override
  State<ReviewClaimScreen> createState() => _ReviewClaimScreenState();
}

class _ReviewClaimScreenState extends State<ReviewClaimScreen> {
  bool isSubmitted = false;
  bool isSubmitting = false;
  String? errorMessage;

  Future<void> _submitAppeal() async {
    if (!widget.isAppeal || widget.claimId == null) return;

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    try {
      await ApiService().appealClaim(
        widget.claimId!,
        statement: widget.reason ?? 'No statement provided',
        proofUrls: widget.proofUrls,
      );
      
      if (mounted) {
        setState(() {
          isSubmitted = true;
          isSubmitting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isSubmitting = false;
          errorMessage = e.toString().contains('ApiException') 
              ? e.toString().split('): ').last 
              : 'Connection failed. Try again.';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(widget.isAppeal ? 'Review appeal' : 'Review claim', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Indicator
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Step 3 of 3 — ${widget.isAppeal ? "Final Review" : "Review"}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  widget.isAppeal ? 'Final Appeal Review' : 'Review your claim', 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                ),
                const SizedBox(height: 24),
                // Review Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildReviewRow(Icons.water_drop_outlined, 'Disruption type', 'Heavy Rain'),
                      _buildReviewRow(Icons.access_time, 'Time period', '11:45 AM - 1:45 PM'),
                      _buildReviewRow(Icons.add, 'Estimated loss', '₹300'),
                      _buildReviewRow(
                        widget.isAppeal ? Icons.gavel_rounded : Icons.shopping_bag_outlined, 
                        widget.isAppeal ? 'Appeal Reason' : 'Description', 
                        'Roads near T Nagar were flooded...'
                      ),
                      _buildReviewRow(Icons.check_box_outlined, 'Evidence added', '2 photos attached', isLast: true),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.isAppeal 
                        ? 'Formal appeals are reviewed by human specialists within 24 hours. False declarations may result in loss of platform access.'
                        : 'Submitting confirms all details are accurate. False claims may result in policy cancellation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: (isSubmitted || isSubmitting) ? null : () {
                    if (widget.isAppeal) {
                      _submitAppeal();
                    } else {
                      // Manual claim logic would go here
                      setState(() {
                        isSubmitted = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSubmitted ? const Color(0xFF1E3A1A) : AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    minimumSize: const Size(double.infinity, 60),
                    disabledBackgroundColor: isSubmitted ? const Color(0xFF1E3A1A) : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: isSubmitting 
                    ? const SizedBox(
                        height: 24, 
                        width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : Text(
                        isSubmitted 
                          ? (widget.isAppeal ? 'Appeal launched! ✓' : 'Claim submitted! ✓') 
                          : (widget.isAppeal ? 'Launch Formal Appeal' : 'Submit claim'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                ),
                const SizedBox(height: 40),
                if (isSubmitted)
                  Center(
                    child: FadeInButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: Text(
                        widget.isAppeal ? 'Go to Shield Tracker' : 'Back to Home', 
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRow(IconData icon, String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue.shade50.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.blue.shade300, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
          Text(
            'Edit',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}


class FadeInButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  const FadeInButton({super.key, required this.child, required this.onPressed});

  @override
  State<FadeInButton> createState() => _FadeInButtonState();
}

class _FadeInButtonState extends State<FadeInButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: TextButton(onPressed: widget.onPressed, child: widget.child));
  }
}
