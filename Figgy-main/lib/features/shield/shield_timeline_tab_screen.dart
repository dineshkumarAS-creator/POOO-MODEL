import 'package:flutter/material.dart';
import 'screens/my_shield_screen.dart';

class ShieldTimelineTabScreen extends StatefulWidget {
  const ShieldTimelineTabScreen({super.key});

  @override
  State<ShieldTimelineTabScreen> createState() => _ShieldTimelineTabScreenState();
}

class _ShieldTimelineTabScreenState extends State<ShieldTimelineTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9), // Premium cream background
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
                  'My Shield',
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
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: MyShieldScreenContent(),
          ),
        ),
      ),
    );
  }
}
