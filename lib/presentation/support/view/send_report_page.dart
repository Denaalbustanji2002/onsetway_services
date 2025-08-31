import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/core/network/http_client.dart';

import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/services/report_api.dart';

class SendProblemReportPage extends StatefulWidget {
  const SendProblemReportPage({super.key});

  @override
  State<SendProblemReportPage> createState() => _SendProblemReportPageState();
}

class _SendProblemReportPageState extends State<SendProblemReportPage>
    with SingleTickerProviderStateMixin {
  final _f = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _description = TextEditingController();
  final _picker = ImagePicker();

  File? _image;
  bool _submitting = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _subject.dispose();
    _description.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _image = File(x.path));
  }

  Future<void> _removeImage() async {
    setState(() => _image = null);
  }

  Future<void> _submit() async {
    if (!(_f.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);

    try {
      final http = context.read<HttpClient>();
      final api = ReportApi(http);
      final res = await api.create(
        subject: _subject.text.trim(),
        description: _description.text.trim(),
        image: _image,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${res.message} (ID: ${res.reportId})',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: ConstColor.darkGold,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(e.message)),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Unexpected error occurred'),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OWPScaffold(
      title: 'Report a Problem',
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 7, 7, 7),
                ConstColor.gold.withOpacity(0.05),
              ],
            ),
          ),
          child: Form(
            key: _f,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: ConstColor.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ConstColor.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ConstColor.gold.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.bug_report_rounded,
                              color: ConstColor.darkGold,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Help us improve',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ConstColor.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Describe the issue you\'re experiencing',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ConstColor.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Form Fields Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ConstColor.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ConstColor.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Field
                      _buildFieldLabel('Subject', Icons.subject_rounded),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _subject,
                        decoration: _enhancedDecoration(
                          'Enter a brief subject',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Subject is required'
                            : null,
                      ),

                      const SizedBox(height: 20),

                      // Description Field
                      _buildFieldLabel(
                        'Description',
                        Icons.description_rounded,
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _description,
                        maxLines: 6,
                        decoration: _enhancedDecoration(
                          'Describe the problem in detail',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Description is required'
                            : null,
                      ),

                      const SizedBox(height: 20),

                      // Attachment Section
                      _buildFieldLabel('Attachment', Icons.attach_file_rounded),
                      const SizedBox(height: 8),
                      _buildAttachmentSection(),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ConstColor.darkGold),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ConstColor.black,
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      children: [
        // Attachment Button
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: _image != null
                    ? ConstColor.darkGold
                    : ConstColor.black.withOpacity(0.2),
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: _image != null
                  ? ConstColor.gold.withOpacity(0.1)
                  : ConstColor.white,
            ),
            child: Column(
              children: [
                Icon(
                  _image != null
                      ? Icons.check_circle
                      : Icons.cloud_upload_rounded,
                  color: _image != null
                      ? ConstColor.darkGold
                      : ConstColor.black.withOpacity(0.5),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  _image != null ? 'Image attached' : 'Tap to attach an image',
                  style: TextStyle(
                    color: _image != null
                        ? ConstColor.darkGold
                        : ConstColor.black.withOpacity(0.7),
                    fontWeight: _image != null
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
                if (_image == null)
                  Text(
                    'Optional - helps us understand the issue',
                    style: TextStyle(
                      fontSize: 12,
                      color: ConstColor.black.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Selected Image Display
        if (_image != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ConstColor.gold.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ConstColor.gold.withOpacity(0.2)),
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
                    Icons.image_rounded,
                    color: ConstColor.darkGold,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _image!.path.split('/').last,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ConstColor.black.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _removeImage,
                  icon: Icon(
                    Icons.close_rounded,
                    color: ConstColor.black.withOpacity(0.6),
                    size: 20,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: 220, // بدل infinity
      height: 44, // أصغر
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ConstColor.darkGold.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: ConstColor.gold,
          foregroundColor: ConstColor.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        ),
        child: _submitting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ConstColor.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Submitting...',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Submit Report',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  InputDecoration _enhancedDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: ConstColor.black.withOpacity(0.4),
      fontSize: 14,
    ),
    filled: true,
    fillColor: ConstColor.white,
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ConstColor.black.withOpacity(0.1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ConstColor.black.withOpacity(0.1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ConstColor.darkGold, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade400, width: 2),
    ),
  );
}
