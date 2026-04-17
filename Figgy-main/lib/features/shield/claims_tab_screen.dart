import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:figgy_app/features/shield/screens/claims_screen.dart';
import 'package:figgy_app/features/shield/shield_theme.dart';

/// Main-tab Claims list (mudiayalaba “Claims” pane).
class ClaimsTabScreen extends StatelessWidget {
  const ClaimsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFF1F5F9),
                Color(0xFFFFF7ED),
                Color(0xFFF0FDF4),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  ShieldColors.primary.withOpacity(0.06),
                  ShieldColors.primary.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: AppColors.brandPrimary,
            elevation: 0,
            toolbarHeight: 80,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const Text(
                  'figgy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Your Claims',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                ),
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          body: const SafeArea(
            child: ClaimsScreen(),
          ),
        ),
        ),
      ],
    );
  }
}
