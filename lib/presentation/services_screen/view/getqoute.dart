// lib/presentation/support/create_quote_page.dart
// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:onsetway_services/constitem/const_colors.dart';

import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/presentation/services_screen/widget/contact_info_helper.dart';
import 'package:onsetway_services/presentation/services_screen/widget/contact_thanks_page.dart';
import 'package:onsetway_services/services/support_api.dart';
import 'package:onsetway_services/core/network/http_client.dart';

class CreateQuotePage extends StatefulWidget {
  final String serviceName;
  const CreateQuotePage({super.key, required this.serviceName});

  @override
  State<CreateQuotePage> createState() => _CreateQuotePageState();
}

class _CreateQuotePageState extends State<CreateQuotePage>
    with TickerProviderStateMixin {
  final _f = GlobalKey<FormState>();
  final _service = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _desc = TextEditingController();
  File? _file;
  bool _loading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _fileAnimationController;
  late Animation<double> _fileAnimation;

  // Focus nodes for better UX
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _descFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _service.text = widget.serviceName;

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fileAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fileAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();

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
    _fileAnimationController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _descFocus.dispose();
    _service.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final res = await FilePicker.platform.pickFiles(
        withData: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg', 'jpeg'],
      );
      if (res != null && res.files.single.path != null) {
        setState(() => _file = File(res.files.single.path!));
        _fileAnimationController.forward();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Error picking file'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _removeFile() {
    setState(() => _file = null);
    _fileAnimationController.reverse();
  }

  Future<void> _submit() async {
    if (!(_f.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final http = context.read<HttpClient>();
      final api = SupportApi(http);
      await api.createQuote(
        serviceName: _service.text.trim(),
        name: _name.text.trim(),
        email: _email.text.trim(),
        phoneNumber: _phone.text.trim(),
        description: _desc.text.trim(),
        file: _file,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ContactThanksPage(
            title: 'Quote request sent',
            message: 'We\'ll contact you with a proposal shortly.',
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

  InputDecoration _dec(String label, {IconData? icon, String? hint}) =>
      InputDecoration(
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
      );

  Widget _buildAnimatedField({required Widget child, required int index}) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
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
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ConstColor.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: ConstColor.darkGold, size: 20),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFileAttachment() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _file != null ? ConstColor.gold : Colors.grey.shade300,
          width: _file != null ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (_file == null) ...[
            // Upload area
            InkWell(
              onTap: _pickFile,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: ConstColor.gold.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ConstColor.gold.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 32,
                        color: ConstColor.darkGold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Attach Project Files',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PDF, DOC, TXT, or Images (Optional)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // File selected
            ScaleTransition(
              scale: _fileAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ConstColor.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ConstColor.gold, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getFileIcon(_file!.path),
                        color: ConstColor.darkGold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _file!.path.split('/').last,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'File attached successfully',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _removeFile,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Change file button
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Change File'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ConstColor.darkGold,
                side: BorderSide(color: ConstColor.darkGold.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getFileIcon(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'txt':
        return Icons.text_snippet_rounded;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image_rounded;
      default:
        return Icons.attach_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OWPScaffold(
      title: 'Get a Quote',
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
                                Icons.request_quote_rounded,
                                size: 32,
                                color: ConstColor.darkGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Request a Quote',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: const Color.fromARGB(255, 241, 240, 240),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Get a detailed proposal for ${widget.serviceName} tailored to your needs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 231, 224, 224),
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
                              hint: 'The service you need a quote for',
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
                              return ok
                                  ? null
                                  : 'Please enter a valid email address';
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
                              hint: '+1 (555) 123-4567',
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

                    // Project Details Section
                    _buildAnimatedField(
                      index: 3,
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
                                  'Describe your project requirements, budget range, timeline, and any specific features you need...',
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

                    // File Attachment Section
                    _buildAnimatedField(
                      index: 4,
                      child: _buildSection(
                        title: 'Supporting Documents',
                        icon: Icons.attach_file_rounded,
                        children: [_buildFileAttachment()],
                      ),
                    ),

                    // Submit Button Section
                    _buildAnimatedField(
                      index: 5,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        margin: const EdgeInsets.only(top: 8),
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
                                      'Submitting Quote...',
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
                                    Icon(
                                      Icons.send_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Submit Quote Request',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    // Footer note
                    _buildAnimatedField(
                      index: 6,
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 15, 15, 15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 8, 8, 8),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: const Color.fromARGB(255, 231, 167, 28),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'We typically respond with detailed quotes within 24-48 hours.',
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    231,
                                    167,
                                    28,
                                  ),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
