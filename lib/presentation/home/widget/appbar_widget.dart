// ow_app_bar.dart
// ignore_for_file: deprecated_member_use, unused_element, sized_box_for_whitespace, use_build_context_synchronously, unused_field, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

import 'package:onsetway_services/core/storage/token_helper.dart';
import 'package:onsetway_services/presentation/authentication/screen/login_screen.dart';
import 'package:onsetway_services/presentation/profile/view/company_profile_page.dart';
import 'package:onsetway_services/presentation/profile/view/person_profile_page.dart';
import 'package:onsetway_services/presentation/settings/view/aboutus.dart';
import 'package:onsetway_services/presentation/settings/view/privacy_policy_screen.dart';
import 'package:onsetway_services/presentation/settings/view/terms_Conditions.dart';
import 'package:onsetway_services/presentation/support/widget/support_hub_screen.dart';

class OWScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const OWScaffold({
    super.key,
    required this.title,
    required this.body,
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

    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final double factor = isAndroid ? 0.8 : 1.0;
    double sf(double v) => v * factor;

    return Scaffold(
      backgroundColor: black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sf(64)),
        child: _OWAppBar(
          title: title,
          gradient: _barGradient,
          actions: actions,
          foreground: white,
          factor: factor,
        ),
      ),
      drawer: _OWDrawer(gradient: _barGradient, isDark: isDark, factor: factor),
      body: body,
    );
  }
}

class _OWAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final LinearGradient gradient;
  final List<Widget>? actions;
  final Color foreground;
  final double factor;

  const _OWAppBar({
    required this.title,
    required this.gradient,
    required this.foreground,
    required this.factor,
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
          title: RepaintBoundary(
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                colors: [
                  OWScaffold.darkGold,
                  OWScaffold.gold,
                  OWScaffold.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(rect),
              blendMode: BlendMode.srcIn,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: sf(20),
                  fontWeight: FontWeight.w700,
                  color: OWScaffold.white,
                ),
              ),
            ),
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

class _OWDrawer extends StatefulWidget {
  final LinearGradient gradient;
  final bool isDark;
  final double factor;

  const _OWDrawer({
    required this.gradient,
    required this.isDark,
    required this.factor,
  });

  @override
  State<_OWDrawer> createState() => _OWDrawerState();
}

class _OWDrawerState extends State<_OWDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  void _openSupport(BuildContext context) async {
    Navigator.of(context).pop(); // close drawer first
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SupportCenterPage()));
  }

  Future<void> _openProfile(BuildContext context) async {
    print("🔹 بدء تنفيذ _openProfile");

    // أغلق الـ Drawer إذا كان مفتوح
    Navigator.maybeOf(context)?.pop();
    print("📌 تم إغلاق الـ Drawer إذا كان مفتوح");

    await Future.delayed(const Duration(milliseconds: 120));
    print("⏳ تم الانتظار 120ms بعد إغلاق الـ Drawer");

    // اقرأ الدور من التوكن
    final role = (await TokenHelper.instance.readRole())?.toLowerCase();
    print("🔑 الدور المسترجع من التوكن: $role");

    // تحقق أن الـ context ما زال صالح
    if (!mounted) {
      print("⚠️ الـ context لم يعد صالح، الخروج من الدالة");
      return;
    }

    if (role == 'company') {
      print("🏢 الدور = company → فتح CompanyProfilePage");
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CompanyProfilePage()));
    } else if (role == 'person') {
      print("👤 الدور = person → فتح PersonProfilePage");
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PersonProfilePage()));
    } else {
      print("❓ الدور غير معروف → إظهار Dialog للاختيار");
      final target = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Open Profile',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Which profile do you want to open?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                print("👤 المستخدم اختار Person من الـ Dialog");
                Navigator.pop(context, 'person');
              },
              child: const Text('Person'),
            ),
            ElevatedButton(
              onPressed: () {
                print("🏢 المستخدم اختار Company من الـ Dialog");
                Navigator.pop(context, 'company');
              },
              child: const Text('Company'),
            ),
          ],
        ),
      );

      // تحقق أن الـ context ما زال صالح وأن المستخدم اختار خيار
      if (!mounted) {
        print("⚠️ الـ context لم يعد صالح بعد الـ Dialog، الخروج");
        return;
      }
      if (target == null) {
        print("❌ المستخدم لم يختار أي خيار من الـ Dialog");
        return;
      }

      print("✅ الخيار النهائي بعد الـ Dialog: $target");

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => target == 'company'
              ? const CompanyProfilePage()
              : const PersonProfilePage(),
        ),
      );
      print("🚀 تم فتح صفحة البروفايل بناءً على الاختيار: $target");
    }

    print("🔚 انتهاء تنفيذ _openProfile");
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-0.3, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const darkGold = OWScaffold.darkGold;
    const white = OWScaffold.white;
    const gold = OWScaffold.gold;

    double sf(double v) => v * widget.factor;

    return Drawer(
      backgroundColor: const Color(0xFF0F0F0F),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F), Color(0xFF000000)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEnhancedHeader(sf, white, darkGold),
                      _buildNavigationSection(sf),
                      _buildEnhancedLogoutSection(sf, white, gold, darkGold),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(
    double Function(double) sf,
    Color white,
    Color darkGold,
  ) {
    return Container(
      height: sf(120),
      decoration: BoxDecoration(
        gradient: widget.gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFcd9733), Color(0xFFb8964c), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            'OnsetWay',
            style: TextStyle(
              color: white,
              fontSize: sf(24),
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationSection(double Function(double) sf) {
    final menuItems = [
      {
        'icon': Icons.person_outline_rounded,
        'label': 'Profile',
        'onTap': () => _openProfile(context),
      },
      {'icon': Icons.settings_outlined, 'label': 'Settings', 'onTap': () {}},
      {
        'icon': Icons.support_agent_outlined,
        'label': 'Support',
        'onTap': () => _openSupport(context),
      },
      {
        'icon': Icons.privacy_tip_outlined,
        'label': 'Privacy Policy',
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PrivacyPolicyScreen(),
            ),
          );
        },
      },
      {
        'icon': Icons.description_outlined,
        'label': 'Terms & Conditions',
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TermsConditions()),
          );
        },
      },
      {
        'icon': Icons.info_outline_rounded,
        'label': 'About',
        'onTap': () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AboutUsPage()));
        },
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: sf(8), vertical: sf(16)),
      child: Column(
        children: [
          for (int index = 0; index < menuItems.length; index++)
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-0.5, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        0.3 + (index * 0.1),
                        1.0,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                  ),
              child: Padding(
                padding: EdgeInsets.only(bottom: sf(6)),
                child: _buildEnhancedTile(
                  icon: menuItems[index]['icon'] as IconData,
                  label: menuItems[index]['label'] as String,
                  onTap: (menuItems[index]['onTap'] as VoidCallback?) ?? () {},
                  factor: widget.factor,
                  delay: index * 100.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double factor,
    required double delay,
  }) {
    double sf(double v) => v * factor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: sf(4)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(sf(12)),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: sf(16), vertical: sf(14)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sf(12)),
              color: Colors.white.withOpacity(0.02),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: sf(36),
                  height: sf(36),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sf(8)),
                    gradient: LinearGradient(
                      colors: [
                        OWScaffold.darkGold.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: sf(20),
                    color: OWScaffold.gold.withOpacity(0.9),
                  ),
                ),
                SizedBox(width: sf(16)),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: OWScaffold.white.withOpacity(0.9),
                      fontSize: sf(14),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: sf(18),
                  color: OWScaffold.darkGold.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedLogoutSection(
    double Function(double) sf,
    Color white,
    Color gold,
    Color darkGold,
  ) {
    return Container(
      margin: EdgeInsets.all(sf(16)),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
              ),
            ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sf(16)),
            gradient: LinearGradient(
              colors: [
                darkGold.withOpacity(0.1),
                Colors.transparent,
                darkGold.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: darkGold.withOpacity(0.4), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(sf(16)),
              onTap: () => _showLogoutDialog(context),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: sf(16),
                  horizontal: sf(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: sf(40),
                      height: sf(40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            gold.withOpacity(0.2),
                            gold.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: gold.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        size: sf(20),
                        color: gold,
                      ),
                    ),
                    SizedBox(width: sf(16)),
                    Expanded(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          color: white.withOpacity(0.9),
                          fontSize: sf(15),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: sf(16),
                      color: darkGold.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: OWScaffold.darkGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            color: OWScaffold.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: OWScaffold.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.15),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: OWScaffold.white.withOpacity(0.85)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: OWScaffold.gold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await TokenHelper.instance.clear();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
