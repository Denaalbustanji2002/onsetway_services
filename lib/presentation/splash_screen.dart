// ignore_for_file: unused_import, unnecessary_import, deprecated_member_use

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart'; // <--- إضافة للتحقق من النظام
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'home/widget/main_screen_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _textAnimationController;
  late AnimationController _layoutAnimationController;
  late AnimationController _progressAnimationController;

  late Animation<double> _textFadeAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<Offset> _textSlideAnimation;

  late Animation<double> _videoFadeAnimation;
  late Animation<double> _videoScaleAnimation;

  late Animation<double> _progressAnimation;

  bool _showVideo = false;
  bool _navigating = false;
  Timer? _navigationTimer;

  late bool _isAndroid;
  late double _logoFontSize;
  late double _subtitleFontSize;
  late double _videoSize;
  late double _progressWidth;
  late double _progressTextSize;

  @override
  void initState() {
    super.initState();

    _isAndroid = defaultTargetPlatform == TargetPlatform.android;

    // تقليل الأحجام لو Android
    _logoFontSize = _isAndroid ? 32 : 40;
    _subtitleFontSize = _isAndroid ? 12 : 14;
    _videoSize = _isAndroid ? 180 : 220;
    _progressWidth = _isAndroid ? 160 : 200;
    _progressTextSize = _isAndroid ? 8 : 10;

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _layoutAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _textScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.9, curve: Curves.elasticOut),
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, -0.4)).animate(
          CurvedAnimation(
            parent: _layoutAnimationController,
            curve: Curves.easeInOutCubic,
          ),
        );

    _videoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _layoutAnimationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _videoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _layoutAnimationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _videoController = VideoPlayerController.asset('assets/video/ow3.mp4')
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });

    _videoController.setLooping(false);
    _videoController.setVolume(0.0);

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    _textAnimationController.forward();
    _progressAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    setState(() {
      _showVideo = true;
    });

    _layoutAnimationController.forward();

    if (_videoController.value.isInitialized) {
      _videoController.play();
    }

    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (_navigating) return;
    _navigating = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainScreen(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _layoutAnimationController.dispose();
    _progressAnimationController.dispose();
    _navigationTimer?.cancel();
    if (_videoController.value.isInitialized) {
      _videoController.pause();
    }
    _videoController.dispose();
    super.dispose();
  }

  Widget _buildVideoContainer() {
    return AnimatedBuilder(
      animation: Listenable.merge([_videoFadeAnimation, _videoScaleAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _videoFadeAnimation,
          child: ScaleTransition(
            scale: _videoScaleAnimation,
            child: SizedBox(
              width: _videoSize,
              height: _videoSize,
              child: ClipOval(child: VideoPlayer(_videoController)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Center(
            child: Column(
              children: [
                Container(
                  width: _progressWidth,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFcd9733), Color(0xFFb8964c)],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: _isAndroid ? 12 : 16),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: _progressTextSize,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [Color(0xFF0a0a0a), Colors.black],
                ),
              ),
            ),
          ),

          AnimatedBuilder(
            animation: Listenable.merge([
              _textAnimationController,
              _layoutAnimationController,
            ]),
            builder: (context, child) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showVideo && _videoController.value.isInitialized)
                      _buildVideoContainer(),

                    if (_showVideo) SizedBox(height: _isAndroid ? 60 : 80),

                    SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _textFadeAnimation,
                        child: ScaleTransition(
                          scale: _textScaleAnimation,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  const LinearGradient textGradient =
                                      LinearGradient(
                                        colors: [
                                          Color(0xFFcd9733),
                                          Color(0xFFb8964c),
                                          Colors.white,
                                          Color(0xFFb8964c),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [0.0, 0.3, 0.7, 1.0],
                                      );
                                  return textGradient.createShader(bounds);
                                },
                                child: Text(
                                  'OnsetWay',
                                  style: TextStyle(
                                    fontFamily: 'MAIAN',
                                    fontSize: _logoFontSize,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                              SizedBox(height: _isAndroid ? 6 : 8),
                              Text(
                                'Premium Experience',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: _subtitleFontSize,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 3.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          _buildProgressIndicator(),
        ],
      ),
    );
  }
}
