import 'package:flutter/cupertino.dart';

class CardAnimationManager {
  final AnimationController mainController;
  final AnimationController pulseController;
  final AnimationController slideController;

  late final Animation<double> scaleAnimation;
  late final Animation<double> rotationAnimation;
  late final Animation<double> pulseAnimation;
  late final Animation<Offset> slideAnimation;

  CardAnimationManager(TickerProvider vsync, double androidScaleFactor)
    : mainController = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: vsync,
      ),
      pulseController = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: vsync,
      ),
      slideController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: vsync,
      ) {
    scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: mainController, curve: Curves.elasticOut),
    );
    rotationAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(parent: mainController, curve: Curves.easeInOut));
    pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
        );
  }

  void dispose() {
    mainController.dispose();
    pulseController.dispose();
    slideController.dispose();
  }

  void updateState(bool isActive) {
    if (isActive) {
      mainController.forward();
      slideController.forward();
      pulseController.repeat(reverse: true);
    } else {
      mainController.reverse();
      slideController.reverse();
      pulseController.stop();
      pulseController.reset();
    }
  }
}
