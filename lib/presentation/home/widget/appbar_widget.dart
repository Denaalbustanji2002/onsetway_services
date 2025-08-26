// ow_app_bar.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:onsetway_services/presentation/settings/view/privacy_policy_screen.dart';
import 'package:onsetway_services/presentation/settings/view/terms_Conditions.dart';

class OWScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final String? logoAsset;
  final List<Widget>? actions;

  const OWScaffold({
    super.key,
    required this.title,
    required this.body,
    this.logoAsset,
    this.actions,
  });

  // Palette
  static const Color black = Color(0xFF000000);
  static const Color darkGold = Color(0xFFcd9733);
  static const Color gold = Color(0xFFb8964c);
  static const Color white = Color(0xFFFFFFFF);

  // Black AppBar background
  LinearGradient get _barGradient =>
      const LinearGradient(colors: [black, black]);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ⬇️ عامل التصغير على Android
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final double factor = isAndroid ? 0.8 : 1.0;
    double sf(double v) => v * factor;

    return Scaffold(
      backgroundColor: black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sf(64)),
        child: _OWAppBar(
          title: title,
          logoAsset: logoAsset,
          gradient: _barGradient,
          actions: actions,
          foreground: white,
          factor: factor, // تمرير العامل للـ AppBar
        ),
      ),
      drawer: _OWDrawer(
        logoAsset: logoAsset,
        gradient: _barGradient,
        isDark: isDark,
        factor: factor, // تمرير العامل للـ Drawer
      ),
      body: body,
    );
  }
}

class _OWAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? logoAsset;
  final LinearGradient gradient;
  final List<Widget>? actions;
  final Color foreground;
  final double factor;

  const _OWAppBar({
    required this.title,
    required this.gradient,
    required this.foreground,
    required this.factor,
    this.logoAsset,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(64 * factor);

  @override
  Widget build(BuildContext context) {
    double sf(double v) => v * factor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: foreground,
          centerTitle: true,
          titleSpacing: 0,
          leadingWidth: sf(56),
          leading: Builder(
            builder: (context) => IconButton(
              iconSize: sf(24),
              padding: EdgeInsets.all(sf(8)),
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Menu',
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logoAsset != null)
                Padding(
                  padding: EdgeInsets.only(right: sf(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sf(8)),
                    child: Image.asset(
                      logoAsset!,
                      width: sf(28),
                      height: sf(28),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  colors: [
                    OWScaffold.darkGold,
                    OWScaffold.gold,
                    OWScaffold.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(rect),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: sf(20),
                    fontWeight: FontWeight.w700,
                    color: OWScaffold.white,
                  ),
                ),
              ),
            ],
          ),
          actions:
              (actions ??
              [
                IconButton(
                  iconSize: sf(22),
                  padding: EdgeInsets.symmetric(horizontal: sf(8)),
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () {},
                ),
                SizedBox(width: sf(6)),
              ]),
        ),
      ),
    );
  }
}

class _OWDrawer extends StatelessWidget {
  final String? logoAsset;
  final LinearGradient gradient;
  final bool isDark;
  final double factor;

  const _OWDrawer({
    required this.gradient,
    required this.isDark,
    required this.factor,
    this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    const darkGold = OWScaffold.darkGold;
    const white = OWScaffold.white;
    const gold = OWScaffold.gold;

    double sf(double v) => v * factor;

    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A), // أفتح شوي من الأسود
      child: Column(
        children: [
          SizedBox(
            height: sf(160),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(decoration: BoxDecoration(gradient: gradient)),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.15)),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (logoAsset != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(sf(12)),
                          child: Image.asset(
                            logoAsset!,
                            width: sf(44),
                            height: sf(44),
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(width: sf(12)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OnsetWay',
                            style: TextStyle(
                              color: white,
                              fontSize: sf(20),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: sf(4)),
                          Text(
                            'services',
                            style: TextStyle(
                              color: const Color(0xFFD9C9A3),
                              fontSize: sf(12.5),
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _tile(
                  icon: Icons.design_services_outlined,
                  label: 'Profile',
                  onTap: () {},
                  factor: factor,
                ),
                _tile(
                  icon: Icons.person_outlined,
                  label: 'Support',
                  onTap: () {},
                  factor: factor,
                ),
                _tile(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () {
                    // التنقل إلى شاشة سياسة الخصوصية
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                  factor: factor,
                ),
                _tile(
                  icon: Icons.description_outlined,
                  label: 'Terms & Condition',
                  onTap: () {
                    // التنقل إلى شاشة الشروط والأحكام
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TermsConditions(),
                      ),
                    );
                  },
                  factor: factor,
                ),
                _tile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () {},
                  factor: factor,
                ),
                _tile(
                  icon: Icons.info_outline_rounded,
                  label: 'About',
                  onTap: () {},
                  factor: factor,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              sf(16),
              sf(4),
              sf(16),
              sf(4),
            ), // تقليل الـ padding الخارجي
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sf(12)),
                border: Border.all(
                  color: darkGold.withOpacity(0.35),
                  width: 0.8,
                ),
                color: Colors.white.withOpacity(0.04),
              ),
              padding: EdgeInsets.symmetric(
                vertical: sf(2),
                horizontal: sf(10),
              ), // تقليل padding الداخلي
              child: Row(
                children: [
                  IconButton(
                    iconSize: sf(20), // تقليل حجم الأيقونة
                    padding:
                        EdgeInsets.zero, // إزالة padding الافتراضي للأيقونة
                    constraints:
                        BoxConstraints(), // تصغير الـ constraints الخاصة بالأيقونة
                    icon: const Icon(Icons.logout_outlined),
                    color: gold,
                    onPressed: () {
                      // أي عملية تسجيل خروج
                    },
                  ),
                  SizedBox(width: sf(8)), // تقليل المسافة بين الأيقونة والنص
                  Expanded(
                    child: Text(
                      'log out',
                      style: TextStyle(
                        color: white,
                        fontSize: sf(12.5),
                      ), // تقليل حجم النص
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    double factor = 1.0,
    VoidCallback? onTap,
  }) {
    const white = OWScaffold.white;
    const gold = OWScaffold.gold;
    double sf(double v) => v * factor;

    return ListTile(
      leading: Icon(icon, color: gold, size: sf(24)),
      title: Text(
        label,
        style: TextStyle(
          color: white,
          fontSize: sf(15.5),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      horizontalTitleGap: sf(8),
      contentPadding: EdgeInsets.symmetric(horizontal: sf(16)),
      minLeadingWidth: sf(24),
    );
  }
}
