// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:onsetway_services/presentation/authentication/screen/login_screen.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class PasswordResetSentScreen extends StatefulWidget {
  const PasswordResetSentScreen({super.key});

  @override
  State<PasswordResetSentScreen> createState() =>
      _PasswordResetSentScreenState();
}

class _PasswordResetSentScreenState extends State<PasswordResetSentScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _waveController;
  late Animation<double> _slideUpAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _waveAnimation;

  // فيديو مكان اللوجو
  late VideoPlayerController _videoController;
  Future<void>? _initializeVideoFuture;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..forward();

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _slideUpAnimation = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_waveController);

    // تهيئة الفيديو
    _videoController = VideoPlayerController.asset('assets/video/ow3.mp4');
    _initializeVideoFuture = _videoController.initialize().then((_) {
      _videoController
        ..setLooping(true)
        ..setVolume(0)
        ..play();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _waveController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // مقياس استجابي
    const baseWidth = 390.0;
    final double scale = (size.width / baseWidth).clamp(0.80, 1.00);
    double fs(double v) => v * scale;
    double px(double v) => v * scale;

    // خلفية ثابتة (دارك فقط)
    final LinearGradient backgroundGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 0, 0, 0),
        Color.fromARGB(255, 10, 10, 10),
        Color.fromARGB(255, 0, 0, 0),
      ],
    );

    // زر ثابت (ذهبي)
    final LinearGradient buttonGradient = const LinearGradient(
      colors: [Color(0xFF987A28), Color(0xFFF4E4BC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: px(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: px(120)),
                        // ===== الهيدر (فيديو + عنوان + سطر مساعد) =====
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, _) {
                            return Transform.translate(
                              offset: Offset(0, _slideUpAnimation.value),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // فيديو داخل دائرة
                                    FutureBuilder(
                                      future: _initializeVideoFuture,
                                      builder: (context, snapshot) {
                                        return Transform.translate(
                                          offset: Offset(0, px(8)),
                                          child: SizedBox(
                                            height: px(160),
                                            width: px(140),
                                            child: ClipOval(
                                              child:
                                                  (snapshot.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      _videoController
                                                          .value
                                                          .isInitialized)
                                                  ? FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: SizedBox(
                                                        width: _videoController
                                                            .value
                                                            .size
                                                            .width,
                                                        height: _videoController
                                                            .value
                                                            .size
                                                            .height,
                                                        child: VideoPlayer(
                                                          _videoController,
                                                        ),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: SizedBox(
                                                        width: px(22),
                                                        height: px(22),
                                                        child:
                                                            const CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: px(22)),
                                    // العنوان بخاصية ShaderMask
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                            colors: [
                                              Color(0xFF987A28),
                                              Color(0xFFF5F1E8),
                                              Color(0xFF987A28),
                                            ],
                                            stops: [0.0, 0.5, 1.0],
                                          ).createShader(bounds),
                                      child: Text(
                                        'CHECK YOUR EMAIL',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'MAIAN',
                                          fontSize: fs(24),
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: px(10)),
                                    // سطر مساعد متماوج
                                    AnimatedBuilder(
                                      animation: _waveController,
                                      builder: (context, _) {
                                        return Transform.translate(
                                          offset: Offset(
                                            10 * math.sin(_waveAnimation.value),
                                            0,
                                          ),
                                          child: Text(
                                            'We’ve sent you a password reset link.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'MAIAN',
                                              fontSize: fs(13.5),
                                              color: Colors.white.withOpacity(
                                                0.8,
                                              ),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: px(16)),

                        // ===== بطاقة زجاجية للنص التوضيحي =====
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, _) {
                            return Transform.translate(
                              offset: Offset(0, _slideUpAnimation.value * 2),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                    px(4),
                                    0,
                                    px(4),
                                    px(16),
                                  ),
                                  padding: EdgeInsets.all(px(24)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.black.withOpacity(0.30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.10),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: px(24),
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Please check your inbox and follow the instructions in the message to reset your password. '
                                    'If you don’t see the email, check your spam folder.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'MAIAN',
                                      fontSize: fs(13.5),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: px(16)),
                        // ===== زر العودة إلى تسجيل الدخول بنفس الستايل =====
                        _buildFuturisticButton(
                          gradient: buttonGradient,
                          label: 'Back To Login',
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                        ),

                        SizedBox(height: px(16)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFuturisticButton({
    required LinearGradient gradient,
    required String label,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 220,
          height: 48,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF987A28).withOpacity(0.4),
                blurRadius: 15,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Back To Login',
              style: TextStyle(
                fontFamily: 'MAIAN',
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
