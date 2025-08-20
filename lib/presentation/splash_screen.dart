// ignore_for_file: deprecated_member_use, library_prefixes

import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';
import 'home/widget/main_screen_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _textCtrl;
  late AnimationController _layoutCtrl;
  late AnimationController _bgCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _textFade;
  late Animation<double> _textScale;
  late Animation<Offset> _textSlide;
  late Animation<double> _videoFade;
  late Animation<double> _bgAnim;
  late Animation<double> _pulse;

  bool _showVideo = false;
  bool _navigating = false;
  Timer? _navigationTimer;

  // Palette
  static const Color black = Color(0xFF000000);
  static const Color darkGold = Color(0xFFcd9733);
  static const Color gold = Color(0xFFb8964c);
  static const Color white = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();

    _initializeControllers();
    _initializeVideo();
  }

  void _initializeControllers() {
    _textCtrl = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _layoutCtrl = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _bgCtrl = AnimationController(
      duration: const Duration(milliseconds: 4200),
      vsync: this,
    )..repeat();

    _pulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);

    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);

    _textScale = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));

    _textSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _layoutCtrl, curve: Curves.easeOutCubic));

    _videoFade = CurvedAnimation(parent: _layoutCtrl, curve: Curves.easeIn);

    _bgAnim = Tween<double>(begin: 0, end: 1).animate(_bgCtrl);
    _pulse = Tween<double>(
      begin: 0.985,
      end: 1.025,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.asset('assets/video/ow3.mp4')
      ..initialize()
          .then((_) {
            if (mounted) setState(() {});
            _startAnimations();
          })
          .catchError((error) {
            if (mounted) _startAnimations();
          });
  }

  void _startAnimations() {
    _textCtrl.forward();

    // Start fallback navigation timer
    _navigationTimer = Timer(const Duration(seconds: 5), _goNext);

    if (_videoController.value.isInitialized) {
      setState(() => _showVideo = true);
      _layoutCtrl.forward();
      _videoController
        ..setLooping(false)
        ..setVolume(0.0)
        ..play();

      // Add video completion listener
      _videoController.addListener(_checkVideoCompletion);
    } else {
      // If video fails, proceed with animations
      _layoutCtrl.forward();
    }
  }

  void _checkVideoCompletion() {
    if (_videoController.value.isInitialized &&
        _videoController.value.position >= _videoController.value.duration) {
      _goNext();
    }
  }

  void _goNext() {
    if (_navigating) return;
    _navigating = true;

    // Clean up resources
    _navigationTimer?.cancel();
    _videoController.removeListener(_checkVideoCompletion);

    navigatorKey.currentState?.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _layoutCtrl.dispose();
    _bgCtrl.dispose();
    _pulseCtrl.dispose();
    _navigationTimer?.cancel();
    _videoController.removeListener(_checkVideoCompletion);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          // Background animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([_bgAnim, _pulse]),
              builder: (_, __) => CustomPaint(
                painter: _PlayfulOrbitsPainter(_bgAnim.value, _pulse.value),
              ),
            ),
          ),

          // Blur overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: Colors.black.withOpacity(0.12)),
            ),
          ),

          // Center content
          AnimatedBuilder(
            animation: Listenable.merge([_textCtrl, _layoutCtrl, _pulseCtrl]),
            builder: (context, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Video player
                  // Video player (بدون أي Opacity على الفيديو نفسه)
                  if (_showVideo && _videoController.value.isInitialized)
                    Transform.scale(
                      scale: _pulse.value,
                      child: SizedBox(
                        width: Platform.isAndroid ? 212 : 220,
                        height: Platform.isAndroid ? 212 : 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // عزل رسم الفيديو عن أي تأثير توريث شفافية
                              const RepaintBoundary(
                                child:
                                    SizedBox.expand(), // placeholder سيتم استبداله بالسطر التالي
                              ),
                              RepaintBoundary(
                                child: VideoPlayer(_videoController),
                              ),

                              IgnorePointer(
                                child: FadeTransition(
                                  opacity: ReverseAnimation(_videoFade),
                                  child: const ColoredBox(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Brand name with spacing
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: ScaleTransition(
                        scale: _textScale,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.06),
                            ),
                            child: ShaderMask(
                              shaderCallback: (rect) => const LinearGradient(
                                colors: [darkGold, gold, white],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(rect),
                              child: Text(
                                'OnsetWay',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'MAIAN',
                                  fontSize: Platform.isAndroid ? 40 - 8.0 : 40,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.0,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
}

class _PlayfulOrbitsPainter extends CustomPainter {
  final double t;
  final double pulse;

  const _PlayfulOrbitsPainter(this.t, this.pulse);

  static const Color darkGold = Color(0xFFcd9733);
  static const Color gold = Color(0xFFb8964c);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (int i = 1; i <= 5; i++) {
      final r = (54.0 * i) + (20 * math.sin((t + i * 0.07) * math.pi * 2));
      final dashCount = 36 + i * 4;
      final angleOffset = t * math.pi * 2 * (i.isOdd ? 1 : -1);

      final p = Paint()
        ..color = darkGold.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4;

      for (int d = 0; d < dashCount; d++) {
        final a1 = angleOffset + (d / dashCount) * math.pi * 2;
        final a2 = a1 + (math.pi * 2 / dashCount) * 0.5;
        final p1 = Offset(cx + r * math.cos(a1), cy + r * math.sin(a1));
        final p2 = Offset(cx + r * math.cos(a2), cy + r * math.sin(a2));
        canvas.drawLine(p1, p2, p);
      }
    }

    final ribbon = Paint()
      ..color = gold.withOpacity(0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    final ampX = size.width * 0.28;
    final ampY = size.height * 0.18;
    const freqX = 3.0, freqY = 2.0;
    for (int i = 0; i <= 320; i++) {
      final tt = (i / 320) * math.pi * 2;
      final x = cx + ampX * math.sin(freqX * tt + t * math.pi * 2);
      final y = cy + ampY * math.sin(freqY * tt + t * math.pi * 2 * 0.9);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, ribbon);

    final comet = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          gold.withOpacity(0.08),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final off = ((t + i * 0.2) * size.width * 1.4) % (size.width * 1.4);
      final x = -size.width + off + (i * size.width * 0.45);
      final path = Path()
        ..moveTo(x, -10)
        ..quadraticBezierTo(
          x + 70,
          size.height * 0.25,
          x + 130,
          size.height + 10,
        )
        ..lineTo(x + 60, size.height + 10)
        ..quadraticBezierTo(x - 10, size.height * 0.25, x - 40, -10)
        ..close();
      canvas.drawPath(path, comet);
    }

    final dot = Paint()
      ..color = darkGold.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 22; i++) {
      final ang = (t * 2 * math.pi * (1.0 + (i % 5) * 0.06)) + (i * 0.35);
      final r = 80 + (i % 6) * 18 + 8 * math.sin(t * 4 + i);
      final x = cx + r * math.cos(ang);
      final y = cy + r * math.sin(ang);
      final sz = 2.0 + (i % 3) * 0.6 + 0.6 * (0.5 + 0.5 * math.sin(t * 10 + i));
      canvas.drawCircle(Offset(x, y), sz * pulse, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
