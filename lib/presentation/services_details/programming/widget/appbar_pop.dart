// ow_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OWPScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final String? logoAsset;
  final List<Widget>? actions;
  final bool canPop;

  const OWPScaffold({
    super.key,
    required this.title,
    required this.body,
    this.logoAsset,
    this.actions,
    this.canPop = false, // true if you want a back button
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
    // final isDark = Theme.of(context).brightness == Brightness.dark;

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
          canPop: canPop,
        ),
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
  final bool canPop;

  const _OWAppBar({
    required this.title,
    required this.gradient,
    required this.foreground,
    this.logoAsset,
    this.actions,
    this.canPop = false,
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                debugPrint('No previous page to pop!');
              }
            },
            tooltip: 'Back',
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
                  colors: [
                    OWPScaffold.darkGold,
                    OWPScaffold.gold,
                    OWPScaffold.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(rect),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: OWPScaffold.white,
                  ),
                ),
              ),
            ],
          ),
          actions:
              actions ??
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
