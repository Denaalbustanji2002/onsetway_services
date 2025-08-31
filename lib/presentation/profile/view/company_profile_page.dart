// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kDebugMode, debugPrint
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/cubit/company_profile_cubit.dart';
import 'package:onsetway_services/model/profile_model/company_profile.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/services/profile_api.dart';
import 'package:onsetway_services/state/company_profile_state.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage>
    with TickerProviderStateMixin {
  void _log(String msg) {
    if (kDebugMode) debugPrint('[CompanyProfilePage] $msg');
  }

  final _f = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _editable = false;
  int _buildCount = 0;

  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _companyName = TextEditingController();
  final _authorizedPerson = TextEditingController();
  final _crNumber = TextEditingController();
  final _unified = TextEditingController();
  final _tax = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    _log('initState()');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..addStatusListener((status) => _log('Animation status: $status'));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward().then(
      (_) => _log('Animation forward complete'),
    );
  }

  @override
  void dispose() {
    _log('dispose()');
    _animationController.dispose();
    for (final c in [
      _email,
      _phone,
      _companyName,
      _authorizedPerson,
      _crNumber,
      _unified,
      _tax,
      _address,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fill(CompanyProfile p) {
    _email.text = p.email;
    _phone.text = p.phoneNumber;
    _companyName.text = p.companyName;
    _authorizedPerson.text = p.authorizedPerson;
    _crNumber.text = p.commercialRegistrationNumber;
    _unified.text = p.unifiedNumber;
    _tax.text = p.taxNumber;
    _address.text = p.address;
  }

  Widget _buildElegantTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool enabled = true,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: enabled,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ConstColor.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: ConstColor.darkGold, size: 18)
              : null,
          labelStyle: TextStyle(
            color: ConstColor.black.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          floatingLabelStyle: const TextStyle(
            color: ConstColor.darkGold,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          filled: true,
          fillColor: enabled
              ? ConstColor.white
              : ConstColor.white.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ConstColor.black.withOpacity(0.1),
              width: 1.2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isPrimary,
    bool isLoading = false,
  }) {
    return Expanded(
      child: Container(
        height: 44,
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
          boxShadow: isPrimary
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
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(ConstColor.white),
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isPrimary
                            ? ConstColor.white
                            : ConstColor.darkGold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ConstColor.darkGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: ConstColor.darkGold, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ConstColor.black,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ConstColor.darkGold.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;

    return BlocProvider<CompanyProfileCubit>(
      create: (ctx) {
        final cubit = CompanyProfileCubit(ctx.read<ProfileApi>());
        cubit.load();
        return cubit;
      },
      child: Builder(
        builder: (context) {
          return OWPScaffold(
            title: 'Company Profile',
            body: BlocConsumer<CompanyProfileCubit, CompanyProfileState>(
              listener: (context, state) {
                if (state is CompanyProfileLoaded) {
                  _fill(state.profile);
                  if (!_editable) setState(() => _editable = true);
                }
                if (state is CompanyProfileMessage) {
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
                if (state is CompanyProfileFailure) {
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
                final loading = state is CompanyProfileLoading;
                final fieldsEnabled = _editable && !loading;

                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            child: Form(
                              key: _f,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          ConstColor.darkGold,
                                          ConstColor.gold,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ConstColor.darkGold
                                              .withOpacity(0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.business,
                                          color: ConstColor.white,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Company Profile Management',
                                          style: TextStyle(
                                            color: ConstColor.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _editable
                                              ? 'Manage your business information'
                                              : 'Loading your profile...',
                                          style: TextStyle(
                                            color: ConstColor.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Edit Mode',
                                          style: TextStyle(
                                            color: ConstColor.black.withOpacity(
                                              0.8,
                                            ),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Switch(
                                          value: _editable,
                                          onChanged: loading
                                              ? null
                                              : (v) => setState(
                                                  () => _editable = v,
                                                ),
                                          activeColor: ConstColor.darkGold,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: ConstColor.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ConstColor.black.withOpacity(
                                            0.05,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildSectionHeader(
                                          'Contact Information',
                                          Icons.contact_mail,
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

                                        _buildSectionHeader(
                                          'Company Details',
                                          Icons.business_outlined,
                                        ),
                                        _buildElegantTextField(
                                          controller: _companyName,
                                          label: 'Company Name',
                                          prefixIcon: Icons.corporate_fare,
                                          enabled: fieldsEnabled,
                                          validator: (v) =>
                                              (v == null || v.isEmpty)
                                              ? 'Company name is required'
                                              : null,
                                        ),
                                        _buildElegantTextField(
                                          controller: _authorizedPerson,
                                          label: 'Authorized Person',
                                          prefixIcon: Icons.person_outline,
                                          enabled: fieldsEnabled,
                                          validator: (v) =>
                                              (v == null || v.isEmpty)
                                              ? 'Authorized person is required'
                                              : null,
                                        ),

                                        _buildSectionHeader(
                                          'Legal Information',
                                          Icons.gavel_outlined,
                                        ),
                                        _buildElegantTextField(
                                          controller: _crNumber,
                                          label:
                                              'Commercial Registration Number',
                                          prefixIcon: Icons.receipt_long,
                                          enabled: fieldsEnabled,
                                          validator: (v) =>
                                              (v == null || v.isEmpty)
                                              ? 'CR number is required'
                                              : null,
                                        ),
                                        _buildElegantTextField(
                                          controller: _unified,
                                          label: 'Unified Number',
                                          prefixIcon: Icons.numbers,
                                          enabled: fieldsEnabled,
                                          validator: (v) =>
                                              (v == null || v.isEmpty)
                                              ? 'Unified number is required'
                                              : null,
                                        ),
                                        _buildElegantTextField(
                                          controller: _tax,
                                          label: 'Tax Number',
                                          prefixIcon: Icons.account_balance,
                                          enabled: fieldsEnabled,
                                          validator: (v) =>
                                              (v == null || v.isEmpty)
                                              ? 'Tax number is required'
                                              : null,
                                        ),

                                        _buildSectionHeader(
                                          'Location',
                                          Icons.location_on_outlined,
                                        ),
                                        _buildElegantTextField(
                                          controller: _address,
                                          label: 'Business Address',
                                          prefixIcon:
                                              Icons.location_on_outlined,
                                          maxLines: 2,
                                          enabled: fieldsEnabled,
                                          validator: (v) =>
                                              (v == null || v.isEmpty)
                                              ? 'Address is required'
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Row(
                                    children: [
                                      _buildActionButton(
                                        text: 'Save Profile',
                                        isPrimary: true,
                                        isLoading: loading,
                                        onPressed: (!fieldsEnabled || loading)
                                            ? null
                                            : () async {
                                                final valid =
                                                    _f.currentState
                                                        ?.validate() ??
                                                    false;
                                                if (!valid) return;

                                                final req =
                                                    UpdateCompanyProfileRequest(
                                                      email: _email.text.trim(),
                                                      phoneNumber: _phone.text
                                                          .trim(),
                                                      companyName: _companyName
                                                          .text
                                                          .trim(),
                                                      authorizedPerson:
                                                          _authorizedPerson.text
                                                              .trim(),
                                                      commercialRegistrationNumber:
                                                          _crNumber.text.trim(),
                                                      unifiedNumber: _unified
                                                          .text
                                                          .trim(),
                                                      taxNumber: _tax.text
                                                          .trim(),
                                                      address: _address.text
                                                          .trim(),
                                                    );

                                                try {
                                                  await context
                                                      .read<
                                                        CompanyProfileCubit
                                                      >()
                                                      .update(req);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Unexpected error during update',
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              },
                                      ),
                                      const SizedBox(width: 12),
                                      _buildActionButton(
                                        text: 'Delete Profile',
                                        isPrimary: false,
                                        onPressed: (!_editable || loading)
                                            ? null
                                            : () async {
                                                final ok = await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .warning_amber_rounded,
                                                          color: Colors
                                                              .orange[600],
                                                          size: 24,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        const Text(
                                                          'Delete Profile',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    content: const Text(
                                                      'This action will permanently delete your company profile and cannot be undone. Are you sure you want to proceed?',
                                                      style: TextStyle(
                                                        fontSize: 14,
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
                                                            color: Colors
                                                                .grey[600],
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
                                                  try {
                                                    await context
                                                        .read<
                                                          CompanyProfileCubit
                                                        >()
                                                        .deleteProfile();
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Unexpected error during delete',
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
