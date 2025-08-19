// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Palette
  static const Color black = Color(0xFF000000);
  static const Color darkGold = Color(0xFFcd9733);
  static const Color gold = Color(0xFFb8964c);
  static const Color white = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();

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
    _textScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _layoutCtrl, curve: Curves.easeOutCubic));

    _videoFade = CurvedAnimation(parent: _layoutCtrl, curve: Curves.easeIn);
    _bgAnim = Tween<double>(begin: 0, end: 1).animate(_bgCtrl);
    _pulse = Tween<double>(begin: 0.985, end: 1.025).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _videoController = VideoPlayerController.asset('assets/video/ow3.mp4')
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _start();
      });
    _videoController
      ..setLooping(false)
      ..setVolume(0.0);
  }

  Future<void> _start() async {
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() => _showVideo = true);
    _layoutCtrl.forward();
    _videoController.play();

    _videoController.addListener(() {
      final v = _videoController.value;
      if (v.isInitialized && v.position >= v.duration && mounted) {
        _goNext();
      }
    });
  }

  Future<void> _goNext() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      navigatorKey.currentState?.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => MainScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _layoutCtrl.dispose();
    _bgCtrl.dispose();
    _pulseCtrl.dispose();
    if (_videoController.value.isInitialized) _videoController.pause();
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
                  // Video
                  if (_showVideo && _videoController.value.isInitialized)
                    FadeTransition(
                      opacity: _videoFade,
                      child: Transform.scale(
                        scale: _pulse.value,
                        child: SizedBox(
                          width: 220,
                          height: 220,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: VideoPlayer(_videoController),
                          ),
                        ),
                      ),
                    ),

                  // Brand name with extra space
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: ScaleTransition(
                        scale: _textScale,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40), // المسافة هنا
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
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
                              child: const Text(
                                'OnsetWay',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'MAIAN',
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.0,
                                  color: white, // masked by shader
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

/// Background painter (same as قبل)
class _PlayfulOrbitsPainter extends CustomPainter {
  final double t;
  final double pulse;

  const _PlayfulOrbitsPainter(this.t, this.pulse);

  static const Color darkGold = Color(0xFFcd9733);
  static const Color gold = Color(0xFFb8964c);
  static const Color white = Color(0xFFFFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (int i = 1; i <= 5; i++) {
      final r = (54.0 * i) + (20 * Math.sin((t + i * 0.07) * Math.pi * 2));
      final dashCount = 36 + i * 4;
      final angleOffset = t * Math.pi * 2 * (i.isOdd ? 1 : -1);

      final p = Paint()
        ..color = darkGold.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4;

      for (int d = 0; d < dashCount; d++) {
        final a1 = angleOffset + (d / dashCount) * Math.pi * 2;
        final a2 = a1 + (Math.pi * 2 / dashCount) * 0.5;
        final p1 = Offset(cx + r * Math.cos(a1), cy + r * Math.sin(a1));
        final p2 = Offset(cx + r * Math.cos(a2), cy + r * Math.sin(a2));
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
    final freqX = 3.0, freqY = 2.0;
    for (int i = 0; i <= 320; i++) {
      final tt = (i / 320) * Math.pi * 2;
      final x = cx + ampX * Math.sin(freqX * tt + t * Math.pi * 2);
      final y = cy + ampY * Math.sin(freqY * tt + t * Math.pi * 2 * 0.9);
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
        ..quadraticBezierTo(x + 70, size.height * 0.25, x + 130, size.height + 10)
        ..lineTo(x + 60, size.height + 10)
        ..quadraticBezierTo(x - 10, size.height * 0.25, x - 40, -10)
        ..close();
      canvas.drawPath(path, comet);
    }

    final starPaint = Paint()
      ..color = white.withOpacity(0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final starCount = 8;
    final starRadius = 120.0;
    for (int i = 0; i < starCount; i++) {
      final a = (i / starCount) * Math.pi * 2 + t * 2.0;
      final x = cx + starRadius * Math.cos(a);
      final y = cy + starRadius * Math.sin(a);
      _drawStar(canvas, Offset(x, y), 8 + 2 * Math.sin(t * 6 + i), starPaint,
          rotate: t * Math.pi * 2 + i);
    }

    final dot = Paint()
      ..color = darkGold.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 22; i++) {
      final ang = (t * 2 * Math.pi * (1.0 + (i % 5) * 0.06)) + (i * 0.35);
      final r = 80 + (i % 6) * 18 + 8 * Math.sin(t * 4 + i);
      final x = cx + r * Math.cos(ang);
      final y = cy + r * Math.sin(ang);
      final sz = 2.0 + (i % 3) * 0.6 + 0.6 * (0.5 + 0.5 * Math.sin(t * 10 + i));
      canvas.drawCircle(Offset(x, y), sz * pulse, dot);
    }
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint p, {double rotate = 0}) {
    final path = Path();
    final spikes = 8;
    final inner = r * 0.45;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(rotate);
    for (int i = 0; i < spikes; i++) {
      final a = (i / spikes) * Math.pi * 2;
      final o1 = Offset(Math.cos(a) * r, Math.sin(a) * r);
      final o2 = Offset(Math.cos(a + Math.pi / spikes) * inner,
          Math.sin(a + Math.pi / spikes) * inner);
      if (i == 0) {
        path.moveTo(o1.dx, o1.dy);
      } else {
        path.lineTo(o1.dx, o1.dy);
      }
      path.lineTo(o2.dx, o2.dy);
    }
    path.close();
    canvas.drawPath(path, p);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
