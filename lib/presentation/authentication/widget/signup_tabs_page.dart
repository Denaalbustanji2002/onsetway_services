// ignore_for_file: unnecessary_import, deprecated_member_use, unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/presentation/authentication/screen/signup_company_page.dart';
import 'package:onsetway_services/presentation/authentication/screen/signup_person_screen.dart';
import 'package:onsetway_services/presentation/authentication/widget/appbarauth.dart';
import 'package:video_player/video_player.dart';

class SignupTabsPage extends StatefulWidget {
  const SignupTabsPage({super.key});

  @override
  State<SignupTabsPage> createState() => _SignupTabsPageState();
}

class _SignupTabsPageState extends State<SignupTabsPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // Video Player
  late final VideoPlayerController _videoController;
  late final Future<void> _initializeVideoFuture;

  @override
  void initState() {
    super.initState();

    // Tabs
    _tabController = TabController(length: 2, vsync: this);

    // Fade Animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController as Animation<double>,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    // Video Player
    _videoController = VideoPlayerController.asset('assets/video/ow3.mp4');
    _initializeVideoFuture = _videoController.initialize().then((_) {
      setState(() {});
      _videoController.setLooping(true);
      _videoController.play();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create Account',
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF0A0A0A), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // const SizedBox(height: 4),
                // _buildHeader(),
                // const SizedBox(height: 14),
                _buildTabBar(),
                const SizedBox(height: 4),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const ClampingScrollPhysics(),
                    children: const [SignupPersonPage(), SignupCompanyPage()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- APP BAR ----------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.of(context).pop(),
            focusColor: ConstColor.darkGold.withOpacity(0.20),
            splashColor: ConstColor.darkGold.withOpacity(0.12),
            child: Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildVideoLogo(double scale) {
    return FutureBuilder<void>(
      future: _initializeVideoFuture,
      builder: (context, snapshot) => SizedBox(
        height: 110.0 * scale,
        width: 110.0 * scale,
        child: ClipOval(
          child:
              (snapshot.connectionState == ConnectionState.done &&
                  _videoController.value.isInitialized)
              ? VideoPlayer(_videoController)
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  // ---------------- TABS ----------------
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ConstColor.darkGold.withOpacity(0.22),
            width: 1,
          ),
        ),
        child: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(.6),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          splashFactory: InkRipple.splashFactory,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF987A28), Color(0xFFF4E4BC)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: ConstColor.gold.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          tabs: [
            _buildTab(
              index: 0,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Individual',
            ),
            _buildTab(
              index: 1,
              icon: Icons.business_outlined,
              activeIcon: Icons.business,
              label: 'Business',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return AnimatedBuilder(
      animation: _tabController.animation!,
      builder: (context, _) {
        final isActive = _tabController.index == index;
        return SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isActive ? activeIcon : icon, size: 20),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
        );
      },
    );
  }
}
