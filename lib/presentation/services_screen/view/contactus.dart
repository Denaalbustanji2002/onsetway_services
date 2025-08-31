// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_element, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/core/network/http_client.dart';
import 'package:onsetway_services/presentation/services_screen/widget/contact_info_helper.dart';
import 'package:onsetway_services/presentation/services_screen/widget/contact_thanks_page.dart';
import 'package:onsetway_services/services/support_api.dart';

import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart'; // OWPScaffold

class AddContactPage extends StatefulWidget {
  final String serviceName;
  const AddContactPage({super.key, required this.serviceName});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage>
    with TickerProviderStateMixin {
  final _f = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _desc = TextEditingController();
  final _service = TextEditingController();

  bool _loading = false;
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  )..forward();
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  // Focus nodes
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _descFocus = FocusNode();

  // Time range (9:00 → 18:00) full-hour steps
  final List<TimeOfDay> _times = List.generate(
    10,
    (i) => TimeOfDay(hour: 9 + i, minute: 0),
  );
  TimeOfDay? _start = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay? _end = const TimeOfDay(hour: 14, minute: 0);

  @override
  void initState() {
    super.initState();
    _service.text = widget.serviceName;

    // Prefill from profile
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final info = await fetchDefaultContactInfo(context);
      if (!mounted || info == null) return;
      _name.text = info.name;
      _email.text = info.email;
      _phone.text = info.phone;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _descFocus.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _desc.dispose();
    _service.dispose();
    super.dispose();
  }

  String _format(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final ampm = t.period == DayPeriod.am ? 'AM' : 'PM';
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hour:$mm $ampm';
  }

  List<DropdownMenuItem<TimeOfDay>> _items(List<TimeOfDay> times) => times
      .map(
        (t) => DropdownMenuItem(
          value: t,
          child: Text(
            _format(t),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      )
      .toList();

  InputDecoration _dec(String label, {IconData? icon, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null
          ? Container(
              margin: const EdgeInsets.only(right: 12),
              child: Icon(icon, color: ConstColor.darkGold, size: 22),
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ConstColor.darkGold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      floatingLabelStyle: const TextStyle(
        color: ConstColor.darkGold,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  Widget _buildAnimatedField({required Widget child, required int index}) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) ...[
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: ConstColor.darkGold, size: 18),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            ...children,
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_f.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final http = context.read<HttpClient>();
      final api = SupportApi(http);

      final preferredWindow = '${_format(_start!)} - ${_format(_end!)}';

      await api.addContact(
        name: _name.text.trim(),
        email: _email.text.trim(),
        phoneNumber: _phone.text.trim(),
        description: _desc.text.trim(),
        preferredContactTime: preferredWindow,
        serviceName: _service.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ContactThanksPage(
            title: 'Contact request sent',
            message: 'We\'ll contact you soon. Thanks for reaching out!',
            serviceName: _service.text.trim(),
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(e.message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Unexpected error occurred'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final startOptions = _times.sublist(0, _times.length - 1);
    final endOptions = _times
        .sublist(1)
        .where(
          (e) => _start == null
              ? true
              : (e.hour * 60 + e.minute) > (_start!.hour * 60 + _start!.minute),
        )
        .toList();

    return OWPScaffold(
      title: 'Contact Us',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 20, 20, 20),
              const Color.fromARGB(255, 0, 0, 0),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _f,
                child: Column(
                  children: [
                    // Header section
                    _buildAnimatedField(
                      index: 0,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ConstColor.gold.withOpacity(0.1),
                              ConstColor.darkGold.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ConstColor.gold.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ConstColor.gold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.support_agent_rounded,
                                size: 32,
                                color: ConstColor.darkGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Get in Touch',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: const Color.fromARGB(255, 250, 249, 249),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "We'll connect you with the right expert for ${widget.serviceName}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 241, 233, 233),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Service Information Section
                    _buildAnimatedField(
                      index: 1,
                      child: _buildSection(
                        title: 'Service Information',
                        icon: Icons.build_rounded,
                        children: [
                          TextFormField(
                            controller: _service,
                            decoration: _dec(
                              'Service Name',
                              icon: Icons.build_outlined,
                              hint: 'The service you\'re interested in',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Service name is required'
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // Personal Information Section
                    _buildAnimatedField(
                      index: 2,
                      child: _buildSection(
                        title: 'Your Information',
                        icon: Icons.person_rounded,
                        children: [
                          TextFormField(
                            controller: _name,
                            focusNode: _nameFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                            decoration: _dec(
                              'Full Name',
                              icon: Icons.person_outline,
                              hint: 'Enter your full name',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Name is required'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _email,
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                            decoration: _dec(
                              'Email Address',
                              icon: Icons.email_outlined,
                              hint: 'your.email@example.com',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Email is required';
                              final ok = RegExp(
                                r'^[^@]+@[^@]+\.[^@]+$',
                              ).hasMatch(v);
                              return ok ? null : 'Please enter a valid email';
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _phone,
                            focusNode: _phoneFocus,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _descFocus.requestFocus(),
                            decoration: _dec(
                              'Phone Number',
                              icon: Icons.phone_outlined,
                              hint: '+966 5x xxx xxxx',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Phone number is required'
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // Preferred Contact Time Section

                    // Preferred Contact Time Section
                    _buildAnimatedField(
                      index: 3,
                      child: _buildSection(
                        title: 'Preferred Contact Time',
                        icon: Icons.schedule_rounded,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: ConstColor.gold.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ConstColor.gold.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: ConstColor.darkGold,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Tap to select your preferred time window',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Time Selection Cards
                          Row(
                            children: [
                              // Start Time Card
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          _start ??
                                          const TimeOfDay(hour: 12, minute: 0),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            timePickerTheme:
                                                TimePickerThemeData(
                                                  backgroundColor: Colors.white,
                                                  hourMinuteTextColor:
                                                      ConstColor.darkGold,
                                                  dialHandColor:
                                                      ConstColor.gold,
                                                  dialBackgroundColor:
                                                      ConstColor.gold
                                                          .withOpacity(0.1),
                                                  entryModeIconColor:
                                                      ConstColor.darkGold,
                                                ),
                                            colorScheme: ColorScheme.light(
                                              primary: ConstColor.darkGold,
                                              onSurface: Colors.grey.shade800,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (time != null) {
                                      // Validate time is within business hours
                                      if (time.hour < 9 || time.hour > 17) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Row(
                                              children: [
                                                Icon(
                                                  Icons.warning_amber_rounded,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Please select time \nbetween 9:00 AM - 6:00 PM',
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.orange,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() {
                                        _start = time;
                                        // Clear end time if it's invalid
                                        if (_end != null) {
                                          final sMin =
                                              time.hour * 60 + time.minute;
                                          final eMin =
                                              _end!.hour * 60 + _end!.minute;
                                          if (eMin <= sMin) _end = null;
                                        }
                                      });
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _start != null
                                          ? ConstColor.gold.withOpacity(0.1)
                                          : Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _start != null
                                            ? ConstColor.gold
                                            : Colors.grey.shade300,
                                        width: _start != null ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.access_time_outlined,
                                          color: _start != null
                                              ? ConstColor.darkGold
                                              : Colors.grey.shade500,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Start Time',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _start != null
                                              ? _format(_start!)
                                              : 'Select',
                                          style: TextStyle(
                                            color: _start != null
                                                ? ConstColor.darkGold
                                                : Colors.grey.shade500,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Arrow connector
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ConstColor.gold.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: ConstColor.darkGold,
                                  size: 16,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // End Time Card
                              Expanded(
                                child: InkWell(
                                  onTap: _start == null
                                      ? null
                                      : () async {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime:
                                                _end ??
                                                TimeOfDay(
                                                  hour: (_start!.hour + 2)
                                                      .clamp(10, 18),
                                                  minute: 0,
                                                ),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  timePickerTheme:
                                                      TimePickerThemeData(
                                                        backgroundColor:
                                                            Colors.white,
                                                        hourMinuteTextColor:
                                                            ConstColor.darkGold,
                                                        dialHandColor:
                                                            ConstColor.gold,
                                                        dialBackgroundColor:
                                                            ConstColor.gold
                                                                .withOpacity(
                                                                  0.1,
                                                                ),
                                                        entryModeIconColor:
                                                            ConstColor.darkGold,
                                                      ),
                                                  colorScheme:
                                                      ColorScheme.light(
                                                        primary:
                                                            ConstColor.darkGold,
                                                        onSurface: Colors
                                                            .grey
                                                            .shade800,
                                                      ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (time != null) {
                                            // Validate time is within business hours and after start
                                            if (time.hour < 10 ||
                                                time.hour > 18) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .warning_amber_rounded,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'End time must be between\n 10:00 AM - 6:00 PM',
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Colors.orange,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            final sMin =
                                                _start!.hour * 60 +
                                                _start!.minute;
                                            final eMin =
                                                time.hour * 60 + time.minute;
                                            if (eMin <= sMin) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .warning_amber_rounded,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'End time must be after start time',
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Colors.orange,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            setState(() => _end = time);
                                          }
                                        },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _end != null
                                          ? ConstColor.gold.withOpacity(0.1)
                                          : Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _end != null
                                            ? ConstColor.gold
                                            : Colors.grey.shade300,
                                        width: _end != null ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.schedule_outlined,
                                          color: _end != null
                                              ? ConstColor.darkGold
                                              : (_start != null
                                                    ? Colors.grey.shade400
                                                    : Colors.grey.shade300),
                                          size: 24,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'End Time',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _end != null
                                              ? _format(_end!)
                                              : (_start != null
                                                    ? 'Select'
                                                    : 'Start first'),
                                          style: TextStyle(
                                            color: _end != null
                                                ? ConstColor.darkGold
                                                : (_start != null
                                                      ? Colors.grey.shade500
                                                      : Colors.grey.shade400),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Business hours note
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.business_center_outlined,
                                  color: Colors.blue.shade600,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Business hours: 9:00 AM - 6:00 PM',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Project Details Section
                    _buildAnimatedField(
                      index: 4,
                      child: _buildSection(
                        title: 'Project Details',
                        icon: Icons.description_rounded,
                        children: [
                          TextFormField(
                            controller: _desc,
                            focusNode: _descFocus,
                            maxLines: 5,
                            textInputAction: TextInputAction.newline,
                            decoration: _dec(
                              'Project Description',
                              icon: Icons.description_outlined,
                              hint:
                                  'Tell us about your project requirements, timeline, and any specific needs...',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Project description is required'
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // Submit Button
                    _buildAnimatedField(
                      index: 5,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor: ConstColor.gold,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shadowColor: ConstColor.gold.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ).copyWith(
                                elevation:
                                    WidgetStateProperty.resolveWith<double>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(WidgetState.pressed))
                                        return 8;
                                      if (states.contains(WidgetState.hovered))
                                        return 4;
                                      return 2;
                                    }),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.pressed,
                                      )) {
                                        return ConstColor.darkGold;
                                      }
                                      if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return ConstColor.gold.withOpacity(0.9);
                                      }
                                      if (states.contains(
                                        WidgetState.disabled,
                                      )) {
                                        return Colors.grey.shade300;
                                      }
                                      return ConstColor.gold;
                                    }),
                              ),
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Sending Request...',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Send Request',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    // Privacy note
                    _buildAnimatedField(
                      index: 6,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ConstColor.gold.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ConstColor.gold.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Icon(
                            //   Icons.security_rounded,
                            //   color: ConstColor.darkGold,
                            //   size: 20,
                            // ),
                            Row(
                              mainAxisSize: MainAxisSize
                                  .min, // 🔹 يخلي Row يتناسب مع محتواه
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Image.asset(
                                    'assets/logo/new_logo.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    'Your information is secure and only \n  used to contact you about this service.',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        22,
                                        22,
                                        22,
                                      ).withOpacity(0.9),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
