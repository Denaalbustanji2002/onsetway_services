// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/cubit/auth_cubit.dart';
import 'package:onsetway_services/model/auth_model/signup_company_request.dart';
import 'package:onsetway_services/state/auth_state.dart';

class SignupCompanyPage extends StatefulWidget {
  const SignupCompanyPage({super.key});
  @override
  State<SignupCompanyPage> createState() => _SignupCompanyPageState();
}

class _SignupCompanyPageState extends State<SignupCompanyPage>
    with TickerProviderStateMixin {
  final _f = GlobalKey<FormState>();

  // Controllers
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _phone = TextEditingController();
  final _companyName = TextEditingController();
  final _authorizePerson = TextEditingController();
  final _crn = TextEditingController();
  final _unified = TextEditingController();
  final _tax = TextEditingController();
  final _address = TextEditingController();

  String? _serverError;
  bool _obscurePassword = true;

  late final AnimationController _anim;
  late final Animation<Offset> _slide;

  final List<Map<String, dynamic>> _formSections = const [
    {
      'title': 'Account Information',
      'icon': Icons.account_circle_outlined,
      'fields': ['email', 'password', 'phone'],
    },
    {
      'title': 'Company Details',
      'icon': Icons.business_outlined,
      'fields': ['companyName', 'authorizePerson', 'address'],
    },
    {
      'title': 'Registration Information',
      'icon': Icons.assignment_outlined,
      'fields': ['crn', 'unified', 'tax'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, .25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    for (final c in [
      _email,
      _pass,
      _phone,
      _companyName,
      _authorizePerson,
      _crn,
      _unified,
      _tax,
      _address,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Background + dark theme look
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF000000), Color(0xFF0A0A0A), Color(0xFF000000)],
        ),
      ),
      child: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (p, c) => c is AuthFailure || c is AuthActionOk,
          listener: (_, s) {
            if (s is AuthFailure) setState(() => _serverError = s.message);
            if (s is AuthActionOk) {
              setState(() => _serverError = null);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(s.message),
                  backgroundColor: ConstColor.darkGold,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          builder: (context, s) {
            final loading = s is AuthLoading;
            return SlideTransition(
              position: _slide,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerCard(),
                    const SizedBox(height: 24),
                    if (_serverError != null) _errorBanner(_serverError!),
                    _form(loading),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ConstColor.darkGold.withOpacity(0.10),
            ConstColor.darkGold.withOpacity(0.04),
          ],
        ),
        border: Border.all(
          color: ConstColor.darkGold.withOpacity(0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF987A28), Color(0xFFF4E4BC)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.business, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Business Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Register your company with Onset Way',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.75),
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- ERROR ----------------

  Widget _errorBanner(String message) {
    return Semantics(
      liveRegion: true,
      label: 'Signup error',
      child: Container(
        margin: const EdgeInsets.only(top: 16, bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.redAccent.withOpacity(0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- FORM ----------------

  Widget _form(bool loading) {
    return Form(
      key: _f,
      child: Column(
        children: [
          ..._formSections.map((section) {
            return _sectionCard(
              title: section['title'] as String,
              icon: section['icon'] as IconData,
              fields: (section['fields'] as List).cast<String>(),
            );
          }),
          const SizedBox(height: 8),
          _submitButton(loading),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<String> fields,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(
          color: ConstColor.darkGold.withOpacity(0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ConstColor.darkGold.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: ConstColor.darkGold, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...fields.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: FocusHalo(child: _buildFieldByName(f)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldByName(String fieldName) {
    switch (fieldName) {
      case 'email':
        return _field(
          controller: _email,
          label: 'Email Address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Email is required';
            final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
            return ok ? null : 'Enter a valid email address';
          },
        );
      case 'password':
        return _field(
          controller: _pass,
          label: 'Password',
          icon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (v) => (v == null || v.length < 6)
              ? 'Password must be at least 6 characters'
              : null,
        );
      case 'phone':
        return _field(
          controller: _phone,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Phone number is required'
              : null,
        );
      case 'companyName':
        return _field(
          controller: _companyName,
          label: 'Company Name',
          icon: Icons.business_outlined,
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Company name is required'
              : null,
        );
      case 'authorizePerson':
        return _field(
          controller: _authorizePerson,
          label: 'Authorized Person',
          icon: Icons.person_outline,
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Authorized person is required'
              : null,
        );
      case 'address':
        return _field(
          controller: _address,
          label: 'Company Address',
          icon: Icons.location_on_outlined,
          maxLines: 2,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Address is required' : null,
        );
      case 'crn':
        return _field(
          controller: _crn,
          label: 'Commercial Registration Number',
          icon: Icons.assignment_outlined,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'CR Number is required' : null,
        );
      case 'unified':
        return _field(
          controller: _unified,
          label: 'Unified Number',
          icon: Icons.confirmation_number_outlined,
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Unified Number is required'
              : null,
        );
      case 'tax':
        return _field(
          controller: _tax,
          label: 'Tax Number',
          icon: Icons.receipt_outlined,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Tax Number is required' : null,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(.80),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.30)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: ConstColor.darkGold, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: maxLines > 1 ? 14 : 12,
        ),
      ),
      validator: validator,
    );
  }

  // ---------------- SUBMIT ----------------
  Widget _submitButton(bool loading) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: loading ? null : _handleSubmit,
        focusColor: ConstColor.darkGold.withOpacity(0.18),
        splashColor: ConstColor.darkGold.withOpacity(0.12),
        child: Container(
          height: 50,
          width: 210, // 👈 هون بتحكم بالعرض
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF987A28), Color(0xFFF4E4BC)],
            ),
            boxShadow: [
              BoxShadow(
                color: ConstColor.darkGold.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Create Company Account',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: .2,
                  ),
                ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    setState(() => _serverError = null);
    if (_f.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signupCompany(
        SignupCompanyRequest(
          email: _email.text.trim(),
          password: _pass.text,
          phoneNumber: _phone.text.trim(),
          companyName: _companyName.text.trim(),
          authorizePerson: _authorizePerson.text.trim(),
          commercialRegistrationNumber: _crn.text.trim(),
          unifiedNumber: _unified.text.trim(),
          taxNumber: _tax.text.trim(),
          address: _address.text.trim(),
        ),
      );
    }
  }
}

// ---------------- UTIL: Focus Halo ----------------

class FocusHalo extends StatelessWidget {
  final Widget child;
  const FocusHalo({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(
        builder: (ctx) {
          final focused = Focus.of(ctx).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            decoration: BoxDecoration(
              boxShadow: focused
                  ? [
                      BoxShadow(
                        color: ConstColor.darkGold.withOpacity(0.20),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ]
                  : const [],
            ),
            child: child,
          );
        },
      ),
    );
  }
}
