// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/cubit/person_profile_cubit.dart';
import 'package:onsetway_services/model/profile_model/person_profile.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/services/profile_api.dart';
import 'package:onsetway_services/state/person_profile_state.dart';

class PersonProfilePage extends StatefulWidget {
  const PersonProfilePage({super.key});

  @override
  State<PersonProfilePage> createState() => _PersonProfilePageState();
}

class _PersonProfilePageState extends State<PersonProfilePage>
    with TickerProviderStateMixin {
  final _f = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _first = TextEditingController();
  final _last = TextEditingController();

  bool _editable = false;
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shimmerAnimation;

  void _log(String msg) {
    if (kDebugMode) debugPrint('[PersonProfilePage] $msg');
  }

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Shimmer animation controller
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOutSine),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    for (final c in [_email, _phone, _first, _last]) c.dispose();
    super.dispose();
  }

  void _fill(PersonProfile p) {
    _email.text = p.email;
    _phone.text = p.phoneNumber;
    _first.text = p.firstName;
    _last.text = p.lastName;
  }

  Widget _buildShimmerField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment(_shimmerAnimation.value - 1, 0),
                end: Alignment(_shimmerAnimation.value, 0),
                colors: [
                  Colors.grey[200]!,
                  Colors.grey[100]!,
                  Colors.grey[200]!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          );
        },
      ),
    );
  }

  // مثال على تصغير TextField
  Widget _buildElegantTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool enabled = true,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        validator: validator,
        enabled: enabled,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14, // صغرنا الخط
          fontWeight: FontWeight.w500,
          color: ConstColor.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: ConstColor.darkGold,
                  size: 20,
                ) // صغرنا الأيقونة
              : null,
          labelStyle: TextStyle(
            color: enabled
                ? ConstColor.black.withOpacity(0.7)
                : ConstColor.black.withOpacity(0.4),
            fontWeight: FontWeight.w500,
            fontSize: 14, // صغرنا الخط
          ),
          floatingLabelStyle: const TextStyle(
            color: ConstColor.darkGold,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          filled: true,
          fillColor: enabled
              ? ConstColor.white
              : ConstColor.white.withOpacity(0.6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ConstColor.black.withOpacity(0.1),
              width: 1.2, // خففنا السماكة
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  // مثال على تصغير ActionButton
  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isPrimary,
    bool isLoading = false,
  }) {
    return Expanded(
      child: Container(
        height: 44, // صغرنا الارتفاع
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [ConstColor.darkGold, ConstColor.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: isPrimary
              ? null
              : Border.all(color: ConstColor.darkGold, width: 1.5),
          boxShadow: isPrimary && onPressed != null
              ? [
                  BoxShadow(
                    color: ConstColor.darkGold.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              alignment: Alignment.center,
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(ConstColor.white),
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontSize: 14, // صغرنا النص
                        fontWeight: FontWeight.w600,
                        color: isPrimary
                            ? ConstColor.white
                            : (onPressed != null
                                  ? ConstColor.darkGold
                                  : ConstColor.darkGold.withOpacity(0.5)),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // مثال على تصغير Profile Avatar
  Widget _buildProfileAvatar() {
    final firstName = _first.text.trim();
    final lastName = _last.text.trim();
    final initials =
        '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
            .toUpperCase();

    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [ConstColor.darkGold, ConstColor.gold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: ConstColor.darkGold.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: ConstColor.white.withOpacity(0.1),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials.isEmpty ? 'U' : initials,
              style: const TextStyle(
                color: ConstColor.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: ConstColor.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: ConstColor.gold.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: ConstColor.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              color: ConstColor.darkGold,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ConstColor.darkGold.withOpacity(0.15),
                  ConstColor.gold.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ConstColor.darkGold.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, color: ConstColor.darkGold, size: 18),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: ConstColor.black,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ConstColor.darkGold.withOpacity(0.4),
                    ConstColor.gold.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonProfileCubit>(
      create: (ctx) {
        final cubit = PersonProfileCubit(ctx.read<ProfileApi>());
        cubit.load();
        return cubit;
      },
      child: Builder(
        builder: (context) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: OWPScaffold(
                    title: 'Personal Profile',
                    body: BlocConsumer<PersonProfileCubit, PersonProfileState>(
                      listener: (context, state) {
                        if (state is PersonProfileLoaded) {
                          _fill(state.profile);
                          if (!_editable) setState(() => _editable = true);
                        }
                        if (state is PersonProfileMessage) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: ConstColor.darkGold,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                        if (state is PersonProfileFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final loading = state is PersonProfileLoading;
                        final fieldsEnabled = _editable && !loading;

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Profile Header Section
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        ConstColor.darkGold,
                                        ConstColor.gold,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ConstColor.darkGold.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      //  _buildProfileAvatar(),
                                      Text(
                                        loading
                                            ? 'Loading Profile...'
                                            : '${_first.text.trim()} ${_last.text.trim()}'
                                                  .trim()
                                                  .isEmpty
                                            ? 'Personal Profile'
                                            : '${_first.text.trim()} ${_last.text.trim()}',
                                        style: const TextStyle(
                                          color: ConstColor.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        loading
                                            ? 'Please wait...'
                                            : _email.text.trim().isEmpty
                                            ? 'Manage your personal information'
                                            : _email.text.trim(),
                                        style: TextStyle(
                                          color: ConstColor.white.withOpacity(
                                            0.9,
                                          ),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (!_editable && !loading) ...[
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ConstColor.white.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: ConstColor.white
                                                    .withOpacity(0.9),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Profile loading...',
                                                style: TextStyle(
                                                  color: ConstColor.white
                                                      .withOpacity(0.9),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Form Container
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: ConstColor.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ConstColor.black.withOpacity(
                                          0.08,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Form(
                                    key: _f,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Personal Information Section
                                        _buildSectionHeader(
                                          'Personal Information',
                                          Icons.person_outline,
                                        ),

                                        if (loading && !_editable) ...[
                                          _buildShimmerField(),
                                          _buildShimmerField(),
                                          _buildShimmerField(),
                                          _buildShimmerField(),
                                        ] else ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildElegantTextField(
                                                controller: _first,
                                                label: 'First Name',
                                                prefixIcon:
                                                    Icons.person_outline,
                                                enabled: fieldsEnabled,
                                                validator: (v) =>
                                                    (v == null || v.isEmpty)
                                                    ? 'First name is required'
                                                    : null,
                                              ),
                                              const SizedBox(height: 10),
                                              _buildElegantTextField(
                                                controller: _last,
                                                label: 'Last Name',
                                                prefixIcon:
                                                    Icons.person_outline,
                                                enabled: fieldsEnabled,
                                                validator: (v) =>
                                                    (v == null || v.isEmpty)
                                                    ? 'Last name is required'
                                                    : null,
                                              ),
                                            ],
                                          ),

                                          // Contact Information Section
                                          _buildSectionHeader(
                                            'Contact Information',
                                            Icons.contact_mail_outlined,
                                          ),

                                          _buildElegantTextField(
                                            controller: _email,
                                            label: 'Email Address',
                                            prefixIcon: Icons.email_outlined,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            enabled: fieldsEnabled,
                                            validator: (v) {
                                              if (v == null || v.isEmpty)
                                                return 'Email is required';
                                              return RegExp(
                                                    r'^[^@]+@[^@]+\.[^@]+$',
                                                  ).hasMatch(v)
                                                  ? null
                                                  : 'Please enter a valid email';
                                            },
                                          ),

                                          _buildElegantTextField(
                                            controller: _phone,
                                            label: 'Phone Number',
                                            prefixIcon: Icons.phone_outlined,
                                            keyboardType: TextInputType.phone,
                                            enabled: fieldsEnabled,
                                            validator: (v) =>
                                                (v == null || v.isEmpty)
                                                ? 'Phone number is required'
                                                : null,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Action Buttons
                                Row(
                                  children: [
                                    _buildActionButton(
                                      text: 'Save Profile',
                                      isPrimary: true,
                                      isLoading: loading,
                                      onPressed: (!fieldsEnabled || loading)
                                          ? null
                                          : () {
                                              if (_f.currentState?.validate() ??
                                                  false) {
                                                context
                                                    .read<PersonProfileCubit>()
                                                    .update(
                                                      UpdatePersonProfileRequest(
                                                        email: _email.text
                                                            .trim(),
                                                        phoneNumber: _phone.text
                                                            .trim(),
                                                        firstName: _first.text
                                                            .trim(),
                                                        lastName: _last.text
                                                            .trim(),
                                                      ),
                                                    );
                                              }
                                            },
                                    ),
                                    const SizedBox(width: 16),
                                    _buildActionButton(
                                      text: 'Delete Profile',
                                      isPrimary: false,
                                      onPressed: (!fieldsEnabled || loading)
                                          ? null
                                          : () async {
                                              final ok = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .warning_amber_rounded,
                                                        color:
                                                            Colors.orange[600],
                                                        size: 28,
                                                      ),
                                                      const SizedBox(width: 12),
                                                      const Text(
                                                        'Delete Profile',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: const Text(
                                                    'This action will permanently delete your personal profile and cannot be undone. Are you sure you want to proceed?',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            false,
                                                          ),
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            ConstColor.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            true,
                                                          ),
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (ok == true) {
                                                context
                                                    .read<PersonProfileCubit>()
                                                    .deleteProfile();
                                              }
                                            },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
