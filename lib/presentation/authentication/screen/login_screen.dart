// ignore_for_file: curly_braces_in_flow_control_structures, prefer_final_fields, type_literal_in_constant_pattern, deprecated_member_use, unused_field

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/cubit/auth_cubit.dart';
import 'package:onsetway_services/presentation/authentication/screen/forget_password_screen.dart';
import 'package:onsetway_services/presentation/authentication/widget/signup_tabs_page.dart';
import 'package:onsetway_services/presentation/home/widget/main_screen_nav.dart';
import 'package:onsetway_services/state/auth_state.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Form Management
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // State Management
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _rememberCredentials = false;

  // Animation Controllers
  late final AnimationController _mainController;
  late final AnimationController _waveController;
  late final AnimationController _pulseController;

  // Animations
  late final Animation<double> _slideUpAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _waveAnimation;
  late final Animation<double> _pulseAnimation;

  // Video Player
  late final VideoPlayerController _videoController;
  Future<void>? _initializeVideoFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVideoPlayer();
    _setupFormListeners();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

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

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _mainController.forward();
    _waveController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.asset('assets/video/ow3.mp4');
    _initializeVideoFuture = _videoController.initialize().then((_) {
      if (mounted) {
        _videoController
          ..setLooping(true)
          ..setVolume(0.0)
          ..play();
        setState(() {});
      }
    });
  }

  void _setupFormListeners() {
    _emailController.addListener(_clearErrorOnType);
    _passwordController.addListener(_clearErrorOnType);
  }

  void _clearErrorOnType() {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size screenSize = mediaQuery.size;
    final double scaleFactor = _calculateScaleFactor(screenSize.width);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                current is AuthFailure || current is AuthSuccess,
            listener: _handleAuthStateChange,
            builder: (context, state) =>
                _buildBody(context, state, scaleFactor),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 0, 0, 0),
          Color.fromARGB(255, 7, 7, 7),
          Color.fromARGB(255, 0, 0, 0),
        ],
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    switch (state.runtimeType) {
      case AuthFailure:
        HapticFeedback.vibrate();
        setState(() => _errorMessage = (state as AuthFailure).message);
        break;
      case AuthSuccess:
        HapticFeedback.lightImpact();
        setState(() => _errorMessage = null);
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainScreen(),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
        break;
    }
  }

  Widget _buildBody(BuildContext context, AuthState state, double scale) {
    final bool isLoading = state is AuthLoading;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0 * scale),
          child: Column(
            children: [
              SizedBox(height: 60.0 * scale),
              _buildAnimatedHeader(scale),
              SizedBox(height: 30.0 * scale),
              _buildLoginForm(scale, isLoading),
              SizedBox(height: 20.0 * scale),
              _buildFooter(scale),
              SizedBox(height: 20.0 * scale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(double scale) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _slideUpAnimation.value),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildVideoLogo(scale),
              SizedBox(height: 16.0 * scale),
              _buildWelcomeText(scale),
              SizedBox(height: 10.0 * scale),
              _buildSubtitleText(scale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoLogo(double scale) {
    return FutureBuilder<void>(
      future: _initializeVideoFuture,
      builder: (context, snapshot) => AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: _pulseAnimation.value,
          child: SizedBox(
            height: 140.0 * scale,
            width: 140.0 * scale,
            child: ClipOval(
              child:
                  (snapshot.connectionState == ConnectionState.done &&
                      _videoController.value.isInitialized)
                  ? VideoPlayer(_videoController)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText(double scale) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF987A28), Color(0xFFF5F1E8), Color(0xFF987A28)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: Text(
        'WELCOME TO ONSETWAY',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'MAIAN',
          fontSize: 24.0 * scale,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubtitleText(double scale) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) => Transform.translate(
        offset: Offset(6 * math.sin(_waveAnimation.value), 0),
        child: Text(
          'Sign in to continue to Onset Way',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'MAIAN',
            fontSize: 14.0 * scale,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(double scale, bool isLoading) {
    return Container(
      padding: EdgeInsets.all(24.0 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0 * scale),
        color: Colors.black.withOpacity(0.30),
        border: Border.all(color: Colors.white.withOpacity(0.10), width: 1.5),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (_errorMessage != null) _buildErrorMessage(),
            _buildEmailField(),
            SizedBox(height: 16.0 * scale),
            _buildPasswordField(),
            SizedBox(height: 20.0 * scale),
            _buildLoginButton(isLoading),
            SizedBox(height: 12.0 * scale),
            _buildActionButtons(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        ),
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.redAccent, fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.white),
      decoration: _buildInputDecoration('Email Address', Icons.email_outlined),
      validator: _validateEmail,
      onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      style: const TextStyle(color: Colors.white),
      decoration: _buildInputDecoration('Password', Icons.lock_outline)
          .copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
      validator: _validatePassword,
      onFieldSubmitted: (_) => _handleLogin(),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: ConstColor.darkGold, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
      ),
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _handleLogin,
      child: Container(
        width: double.infinity,
        height: 48.0,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF987A28), Color(0xFFF4E4BC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF987A28).withOpacity(0.4),
              blurRadius: 15.0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22.0,
                  height: 22.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontFamily: 'MAIAN',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    return Column(
      children: [
        // Forgot Password Button with Icon
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: TextButton.icon(
            onPressed: isLoading ? null : _navigateToForgotPassword,
            icon: Icon(
              Icons.help_outline,
              color: isLoading
                  ? ConstColor.darkGold.withOpacity(0.3)
                  : ConstColor.darkGold,
              size: 16.0,
            ),
            label: Text(
              'Forgot Password?',
              style: TextStyle(
                color: isLoading
                    ? ConstColor.darkGold.withOpacity(0.3)
                    : ConstColor.darkGold,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8.0),

        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'OR',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 1.0,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // Create Account Button with Enhanced Styling
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : _navigateToSignup,
            icon: Icon(
              Icons.person_add_outlined,
              color: isLoading
                  ? ConstColor.darkGold.withOpacity(0.3)
                  : ConstColor.darkGold,
              size: 18.0,
            ),
            label: Text(
              'Create New Account',
              style: TextStyle(
                color: isLoading
                    ? ConstColor.darkGold.withOpacity(0.3)
                    : ConstColor.darkGold,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                letterSpacing: 0.5,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              side: BorderSide(
                color: isLoading
                    ? ConstColor.darkGold.withOpacity(0.3)
                    : ConstColor.darkGold.withOpacity(0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              backgroundColor: isLoading
                  ? Colors.transparent
                  : ConstColor.darkGold.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(double scale) {
    return Text(
      '© 2025 Onsetway. All rights reserved.',
      style: TextStyle(
        color: ConstColor.darkGold.withOpacity(0.8),
        fontSize: 14.0 * scale,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Helper Methods
  double _calculateScaleFactor(double screenWidth) {
    const double baseWidth = 390.0;
    return (screenWidth / baseWidth).clamp(0.80, 1.20);
  }

  String? _validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'Password is required';
    if (value!.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);

    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.selectionClick();
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _navigateToSignup() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupTabsPage()));
  }

  void _navigateToForgotPassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
  }

  @override
  void dispose() {
    _mainController.dispose();
    _waveController.dispose();
    _pulseController.dispose();
    _videoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
