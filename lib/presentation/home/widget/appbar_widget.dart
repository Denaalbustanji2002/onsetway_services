// ow_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const Color black    = Color(0xFF000000);
  static const Color darkGold = Color(0xFFcd9733);
  static const Color gold     = Color(0xFFb8964c);
  static const Color white    = Color(0xFFFFFFFF);

  // Black AppBar background
  LinearGradient get _barGradient => const LinearGradient(
    colors: [black, black],
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _OWAppBar(
          title: title,
          logoAsset: logoAsset,
          gradient: _barGradient,
          actions: actions,
          foreground: white,
        ),
      ),
      drawer: _OWDrawer(
        logoAsset: logoAsset,
        gradient: _barGradient,
        isDark: isDark,
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

  const _OWAppBar({
    required this.title,
    required this.gradient,
    required this.foreground,
    this.logoAsset,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
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
          leading: Builder(
            builder: (context) => IconButton(
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
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      logoAsset!,
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  colors: [OWScaffold.darkGold, OWScaffold.gold, OWScaffold.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(rect),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: OWScaffold.white,
                  ),
                ),
              ),
            ],
          ),
          actions: actions ??
              [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () {},
                ),
                const SizedBox(width: 6),
              ],
        ),
      ),
    );
  }
}

class _OWDrawer extends StatelessWidget {
  final String? logoAsset;
  final LinearGradient gradient;
  final bool isDark;

  const _OWDrawer({
    required this.gradient,
    required this.isDark,
    this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {

    const darkGold = OWScaffold.darkGold;

    const white = OWScaffold.white;

    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A), // أفتح شوي من الأسود
      child: Column(
        children: [
          SizedBox(
            height: 160,
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
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            logoAsset!,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'OnsetWay',
                            style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'services',
                            style: TextStyle(
                              color: Color(0xFFD9C9A3),
                              fontSize: 12.5,
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
              //  _tile(icon: Icons.home_outlined, label: 'Home', onTap: () => Navigator.pop(context)),
                _tile(icon: Icons.design_services_outlined, label: 'Profile', onTap: () {}),
                _tile(icon: Icons.person_outlined, label: 'Support', onTap: () {}),
                _tile(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
                _tile( icon: Icons.description_outlined, label: 'Terms & Condition', onTap: () {}),
                _tile(icon: Icons.settings_outlined, label: 'Settings', onTap: () {}),
                _tile(icon: Icons.info_outline_rounded, label: 'About', onTap: () {}),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: darkGold.withOpacity(0.35), width: 0.8),
                color: Colors.white.withOpacity(0.04),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout_outlined),
                    color: OWScaffold.gold,
                    onPressed: () {
                      // هنا تحطي أي عملية تسجيل خروج
                    },
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'log out',
                      style: TextStyle(color: OWScaffold.white, fontSize: 13.5),
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

  Widget _tile({required IconData icon, required String label, VoidCallback? onTap}) {
    const white = OWScaffold.white;
    const gold = OWScaffold.gold;
    return ListTile(
      leading: Icon(icon, color: gold),
      title: Text(label, style: const TextStyle(color: white, fontSize: 15.5, fontWeight: FontWeight.w500)),
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 8,
    );
  }
}
