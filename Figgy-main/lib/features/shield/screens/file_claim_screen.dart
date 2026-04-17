import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'add_proof_screen.dart';

class FileClaimScreen extends StatefulWidget {
  final bool isResubmit;
  final String? claimId;
  final bool isAppeal;

  const FileClaimScreen({
    super.key, 
    this.isResubmit = false, 
    this.claimId,
    this.isAppeal = false,
  });

  @override
  State<FileClaimScreen> createState() => _FileClaimScreenState();
}

class _FileClaimScreenState extends State<FileClaimScreen> {
  String selectedDisruption = 'Heavy Rain';
  bool hasDeclared = false;
  final TextEditingController _reasonController = TextEditingController(
    text: 'Roads near T Nagar were flooded. No orders came for 3 hours.'
  );

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          widget.isAppeal ? 'Formal Appeal' : (widget.isResubmit ? 'Resubmit claim' : 'File a claim'),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                if (widget.isResubmit || widget.isAppeal) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: widget.isAppeal ? Colors.orange.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: widget.isAppeal ? Colors.orange.shade100 : Colors.red.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(widget.isAppeal ? Icons.gavel_rounded : Icons.info_outline, color: widget.isAppeal ? Colors.orange.shade700 : Colors.red.shade700, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.isAppeal 
                              ? 'APPEALING CLAIM ${widget.claimId ?? ""}\nYou are launching a formal review request.'
                              : 'RESUBMITTING CLAIM ${widget.claimId ?? ""}\nPlease provide additional proof to verify your loss.',
                            style: TextStyle(color: widget.isAppeal ? Colors.orange.shade900 : Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Progress Indicator
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Step 1 of 3 — ${widget.isAppeal ? "Appeal Details" : "What happened"}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  widget.isAppeal ? 'Why should we review this?' : 'Tell us what happened', 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                ),
                const SizedBox(height: 24),
                const Text('What disruption?', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildChip('Heavy Rain'),
                    _buildChip('Flood'),
                    _buildChip('Extreme Heat'),
                    _buildChip('Strike'),
                    _buildChip('Traffic'),
                    _buildChip('Other'),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('When did it happen?', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker('Started', '11:45'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker('Ended', '13:45'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('How much income did you lose? (₹)', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Text('₹', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 12),
                      Text('300', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Between ₹1 and ₹4,999', style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 32),
                Text(
                  widget.isAppeal ? 'Appeal reason (max 500 chars)' : 'What happened? (optional)', 
                  style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _reasonController,
                    maxLines: 5,
                    maxLength: 500,
                    onChanged: (val) => setState(() {}),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('${_reasonController.text.length} / 500', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ),
                const SizedBox(height: 32),
                if (widget.isAppeal) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: hasDeclared ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: hasDeclared ? AppColors.primary : Colors.grey.shade300),
                    ),
                    child: CheckboxListTile(
                      value: hasDeclared,
                      onChanged: (val) {
                        setState(() {
                          hasDeclared = val ?? false;
                        });
                      },
                      title: const Text(
                        'I declare that the information provided is truthful and accurate. False claims will affect my Trust Score.',
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                      activeColor: AppColors.primary,
                      controlAffinity: ListTileControlAffinity.leading,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                ElevatedButton(
                  onPressed: widget.isAppeal && !hasDeclared ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProofScreen(
                          isAppeal: widget.isAppeal,
                          claimId: widget.claimId,
                          reason: _reasonController.text,
                        )
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    minimumSize: const Size(double.infinity, 60),
                    disabledBackgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.isAppeal ? 'Attach Evidence' : 'Continue', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    final bool isSelected = selectedDisruption == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDisruption = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Icon(Icons.access_time_rounded, color: Colors.grey, size: 22),
            ],
          ),
        ),
      ],
    );
  }
}
