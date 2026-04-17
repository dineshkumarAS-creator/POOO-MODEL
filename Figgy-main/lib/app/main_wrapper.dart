// Hot reload triggered at 2026-04-17 13:08
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:figgy_app/core/navigation/main_tab_scope.dart';
import 'package:figgy_app/theme/app_theme.dart';
import 'package:figgy_app/features/demand/demand_screen.dart';
import 'package:figgy_app/features/radar/radar_screen.dart';
import 'package:figgy_app/features/profile/profile_screen.dart';
import 'package:figgy_app/features/shield/shield_timeline_tab_screen.dart';
import 'package:figgy_app/features/shield/claims_tab_screen.dart';
import 'package:figgy_app/widgets/verification_dialog.dart';

class MainWrapper extends StatefulWidget {
  final int initialIndex;
  const MainWrapper({super.key, this.initialIndex = 0});

  static MainWrapperState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainWrapperState>();

  void refresh(BuildContext context) {
    context.findAncestorStateOfType<MainWrapperState>()?.refreshState();
  }

  @override
  State<MainWrapper> createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  late int _currentIndex;
  bool _isLoading = true;
  String _tier = 'Smart';
  String _status = 'inactive';
  bool _showVerificationBanner = true;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void refreshState() {
    _loadSavedStatus();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadSavedStatus();
  }

  Future<void> _loadSavedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tier = (prefs.getString('selected_tier') ?? 'Smart').trim();
      _status = (prefs.getString('policy_status') ?? 'inactive').trim();
      _isLoading = false;
    });
    debugPrint("MainWrapper Loaded: Tier=$_tier, Status=$_status");
  }

  Future<void> _saveIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_nav_index', index);
  }

  void setIndex(int index) {
    if (_currentIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() {
      _currentIndex = index;
    });
    _saveIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.brandPrimary)),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentIndex].currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentIndex != 0) {
            setIndex(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: MainTabScope(
        goToTab: setIndex,
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                if (_showVerificationBanner)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _buildTopBanner(),
                  ),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      const DemandScreen(),
                      const ShieldTimelineTabScreen(),
                      const ClaimsTabScreen(),
                      const RadarScreen(),
                      const ProfileScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(),
        ),
      ),
    );
  }


  Widget _buildTopBanner() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              showVerificationDialog(context, () {
                setState(() {
                  _showVerificationBanner = false;
                });
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFDC2626).withOpacity(0.8),
                    const Color(0xFF991B1B).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.gps_fixed_rounded, color: Colors.white, size: 12),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'ACTION REQUIRED',
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.small.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text('•', style: TextStyle(color: Colors.white70, fontSize: 8)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '28:15',
                      style: AppTypography.small.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFF3F3F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_filled, 'Home', 0),
              _buildNavItem(Icons.radar_rounded, 'Radar', 3),
              _buildNavItem(Icons.shield_rounded, 'Insurance', 1),
              _buildNavItem(Icons.person_rounded, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final Color color = isActive ? AppColors.brandPrimary : const Color(0xFF94A3B8);

    return Expanded(
      child: InkWell(
        onTap: () => setIndex(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.small.copyWith(
                fontSize: 10,
                color: color,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
