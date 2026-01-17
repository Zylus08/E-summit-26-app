import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/form_widgets.dart';
import '../../core/services/if_service.dart';

class InternshipFairPage extends StatefulWidget {
  const InternshipFairPage({super.key});

  @override
  State<InternshipFairPage> createState() => _InternshipFairPageState();
}

class _InternshipFairPageState extends State<InternshipFairPage> {
  final _nameController = TextEditingController();
  final _branchController = TextEditingController();
  final _instituteController = TextEditingController();
  final _cgpaController = TextEditingController();
  final _skillsController = TextEditingController();

  String? _resumeFileName;
  List<String> _selectedOrganisations = [];

  final List<String> _organisations = [
    'Google',
    'Microsoft',
    'Amazon',
    'Tesla',
    'SpaceX',
    'OpenAI',
    'Meta',
    'Netflix',
  ];

  final _ifService = InternshipFairService();
  bool _loading = false;

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _resumeFileName = result.files.single.name;
      });
    }
  }

  void _toggleOrganisation(String org) {
    setState(() {
      if (_selectedOrganisations.contains(org)) {
        _selectedOrganisations.remove(org);
      } else {
        _selectedOrganisations.add(org);
      }
    });
  }

  Future<void> _submitApplication() async {
    if (_nameController.text.isEmpty ||
        _branchController.text.isEmpty ||
        _instituteController.text.isEmpty ||
        _cgpaController.text.isEmpty ||
        _skillsController.text.isEmpty ||
        _resumeFileName == null ||
        _selectedOrganisations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and upload resume'),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await _ifService.submitApplication(
        fullName: _nameController.text.trim(),
        branch: _branchController.text.trim(),
        institute: _instituteController.text.trim(),
        cgpa: double.parse(_cgpaController.text.trim()),
        skills: _skillsController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        organisations: _selectedOrganisations,
        resumeFileName: _resumeFileName!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application Submitted Successfully!'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Internship Fair Application')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Details', style: AppTypography.heading3),
            const SizedBox(height: 16),

            CustomTextField(label: 'Full Name', controller: _nameController),
            const SizedBox(height: 16),
            CustomTextField(label: 'Branch Name', controller: _branchController),
            const SizedBox(height: 16),
            CustomTextField(label: 'Institute Name', controller: _instituteController),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'CGPA',
              controller: _cgpaController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),
            Text('Professional Profile', style: AppTypography.heading3),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Skills (comma separated)',
              controller: _skillsController,
              maxLines: 3,
            ),

            const SizedBox(height: 16),
            Text('Resume/CV (PDF)', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),

            InkWell(
              onTap: _pickResume,
              child: DottedBorder(
                color: AppColors.brandBlue,
                strokeWidth: 2,
                dashPattern: const [8, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    _resumeFileName ?? 'Tap to upload PDF',
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            Text('Select Organisations', style: AppTypography.heading3),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _organisations.map((org) {
                final selected = _selectedOrganisations.contains(org);
                return FilterChip(
                  label: Text(org),
                  selected: selected,
                  onSelected: (_) => _toggleOrganisation(org),
                );
              }).toList(),
            ),

            const SizedBox(height: 48),
            PrimaryButton(
              text: _loading ? 'Submitting...' : 'SUBMIT APPLICATION',
              onPressed: () {
                if (_loading) return;
                _submitApplication();
              },
            ),
          ],
        ),
      ),
    );
  }
}
