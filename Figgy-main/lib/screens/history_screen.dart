import 'package:flutter/material.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/models/ride.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.brandPrimary,
        elevation: 0,
        toolbarHeight: 80,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Delivery History',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      body: ValueListenableBuilder<List<Ride>>(
        valueListenable: globalCompletedRidesNotifier,
        builder: (context, rides, _) {
          if (rides.isEmpty) {
            return Center(
              child: Text(
                "No deliveries completed yet.",
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: rides.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final ride = rides[i];
              final h = ride.endTime!.hour;
              final m = ride.endTime!.minute.toString().padLeft(2, '0');
              final period = h >= 12 ? 'PM' : 'AM';
              final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
              
              final now = DateTime.now();
              final end = ride.endTime!;
              final diff = DateTime(now.year, now.month, now.day)
                  .difference(DateTime(end.year, end.month, end.day))
                  .inDays;
              
              String dateStr;
              if (diff == 0) {
                dateStr = 'Today';
              } else if (diff == 1) {
                dateStr = 'Yesterday';
              } else {
                const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                dateStr = '${end.day} ${months[end.month - 1]}';
              }
              
              final timeStr = '$dateStr, $displayH:$m $period';

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF3F3F1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(timeStr, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Delivered', style: AppTypography.small.copyWith(color: const Color(0xFF2E7D32), fontWeight: FontWeight.w900, fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ride.restaurantName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w900, color: Colors.black)),
                              const SizedBox(height: 4),
                              Text(ride.customerAddress, style: AppTypography.small.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('₹${ride.earnings}', style: AppTypography.bodyLarge.copyWith(color: AppColors.brandPrimary, fontWeight: FontWeight.w900, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
