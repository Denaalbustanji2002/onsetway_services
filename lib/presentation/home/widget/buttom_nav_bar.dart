// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/services/access_api.dart';

class TabItem {
  final IconData icon;
  final String title;
  final bool enabled;

  const TabItem({required this.icon, required this.title, this.enabled = true});
}

/// If you want a fixed fallback while loading or on error
const List<TabItem> _fallbackItems = [
  TabItem(icon: Icons.home_filled, title: 'Home'),
  TabItem(icon: Icons.local_offer_rounded, title: 'My Offer', enabled: false),
  TabItem(
    icon: Icons.event_available_rounded,
    title: 'Appointment',
    enabled: false,
  ),
  TabItem(icon: Icons.handshake_rounded, title: 'Be Partner'),
  TabItem(icon: Icons.settings_rounded, title: 'Settings'),
];

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // fetch once and cache
  late Future<Map<String, bool>> _featuresFuture;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Kick off the request once
    final accessApi = context.read<AccessApi>();
    _featuresFuture = _getFeatures(accessApi);
  }

  Future<Map<String, bool>> _getFeatures(AccessApi api) async {
    // Expected keys in response:
    // canAccessAppointments, canAccessOffers
    final f = await api.getUserFeatures();
    return <String, bool>{
      'offers': f.canAccessOffers,
      'appointments': f.canAccessAppointments,
    };
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  List<TabItem> _buildItemsFromFeatures(Map<String, bool> features) {
    final canOffers = features['offers'] ?? false;
    final canAppointments = features['appointments'] ?? false;

    return <TabItem>[
      const TabItem(icon: Icons.home_filled, title: 'Home'),
      TabItem(
        icon: Icons.local_offer_rounded,
        title: 'My Offer',
        enabled: canOffers,
      ),
      TabItem(
        icon: Icons.event_available_rounded,
        title: 'Appointment',
        enabled: canAppointments,
      ),
      const TabItem(icon: Icons.handshake_rounded, title: 'Be Partner'),
      const TabItem(icon: Icons.settings_rounded, title: 'Settings'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;

    final double margin = isAndroid ? 0 : 20;
    final double iconSize = isAndroid ? 20 : 28;
    final double fontSize = isAndroid ? 9 : 13;

    return FutureBuilder<Map<String, bool>>(
      future: _featuresFuture,
      builder: (context, snapshot) {
        // While loading (or on error), we fall back to a known list with disabled protected tabs.
        final List<TabItem> items = snapshot.hasData
            ? _buildItemsFromFeatures(snapshot.data!)
            : _fallbackItems;

        final double availableWidth =
            MediaQuery.of(context).size.width - (margin * 2);
        final double cellWidth = availableWidth / items.length;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: margin,
            vertical: margin * 0.8,
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF2A2A2A).withOpacity(0.95),
                          const Color(0xFF1A1A1A).withOpacity(0.98),
                          ConstColor.black.withOpacity(0.99),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ConstColor.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: items.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final TabItem item = entry.value;
                        final bool isSelected = widget.selectedIndex == index;

                        return GestureDetector(
                          onTapDown: (_) => _scaleController.forward(),
                          onTapUp: (_) => _scaleController.reverse(),
                          onTapCancel: () => _scaleController.reverse(),
                          onTap: () {
                            if (!item.enabled) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    item.title == 'Appointment'
                                        ? 'Appointments are not enabled for your account.'
                                        : 'This section is not enabled for your account.',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }
                            widget.onTap(index);
                          },
                          child: AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              final Color iconColor = item.enabled
                                  ? (isSelected
                                        ? ConstColor.gold
                                        : ConstColor.white.withOpacity(0.6))
                                  : const Color.fromARGB(
                                      255,
                                      250,
                                      245,
                                      245,
                                    ).withOpacity(0.5);

                              final Color textColor = item.enabled
                                  ? (isSelected
                                        ? ConstColor.gold
                                        : ConstColor.white.withOpacity(0.7))
                                  : const Color.fromARGB(
                                      255,
                                      241,
                                      238,
                                      238,
                                    ).withOpacity(0.6);

                              return Transform.scale(
                                scale: isSelected ? _scaleAnimation.value : 1.0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: iconSize + 16,
                                      height: iconSize + 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: (item.enabled && isSelected)
                                            ? LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  ConstColor.gold.withOpacity(
                                                    0.2,
                                                  ),
                                                  ConstColor.darkGold
                                                      .withOpacity(0.1),
                                                  Colors.transparent,
                                                ],
                                              )
                                            : null,
                                        border: (item.enabled && isSelected)
                                            ? Border.all(
                                                color: ConstColor.gold
                                                    .withOpacity(0.4),
                                                width: 1,
                                              )
                                            : null,
                                      ),
                                      child: Icon(
                                        item.icon,
                                        size: iconSize,
                                        color: iconColor,
                                      ),
                                    ),
                                    SizedBox(height: isAndroid ? 3 : 6),
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // Glow indicator (align to dynamic items length)
              Positioned(
                top: 0,
                left: cellWidth * widget.selectedIndex,
                child: Container(
                  width: cellWidth,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        ConstColor.gold.withOpacity(0.7),
                        ConstColor.darkGold,
                        ConstColor.gold.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
