import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/snackbar/custom_snackbar.dart';
import 'package:flutter/material.dart';

class EditDocumentDetailsPage extends StatefulWidget {
  const EditDocumentDetailsPage({super.key});

  @override
  State<EditDocumentDetailsPage> createState() =>
      _EditDocumentDetailsPageState();
}

class _EditDocumentDetailsPageState extends State<EditDocumentDetailsPage> {
  late TextEditingController _fileNameController;
  String _selectedFileType = 'Prescription';
  String _selectedRecordFor = 'Ketan Patni';
  DateTime? _selectedDate;

  final List<String> _fileTypes = [
    'Prescription',
    'Lab Report',
    'Scan/Imaging',
    'Medical Certificate',
    'Invoice',
  ];

  final List<String> _recordForOptions = [
    'Ketan Patni',
    'Jane Doe',
    'John Smith',
  ];

  @override
  void initState() {
    super.initState();
    _fileNameController = TextEditingController(text: 'Prescription');
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Document Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                label: 'File Name',
                isRequired: true,
                child: TextField(
                  controller: _fileNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter file name',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),

              _buildInputField(
                label: 'File Type',
                isRequired: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFileType,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    items: _fileTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedFileType = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),

              _buildInputField(
                label: 'Record For',
                isRequired: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRecordFor,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    items: _recordForOptions.map((String person) {
                      return DropdownMenuItem<String>(
                        value: person,
                        child: Text(person),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedRecordFor = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),

              _buildInputField(
                label: 'File Date',
                isRequired: false,
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}'
                            : 'Select Date',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate != null
                              ? Colors.black87
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                height: 380,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.asset(
                        EcliniqIcons.prescription.assetPath,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      Positioned(
                        bottom: 12,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x99FFFFFF),
                            borderRadius: BorderRadius.circular(45),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 10.4,
                                spreadRadius: 0,
                                color: const Color(0x1F000000),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.blue.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Preview',
                                style: TextStyle(
                                  color: Color(0xff424242),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
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
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _saveDetails();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2372EC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required bool isRequired,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isRequired)
                  const Text(
                    ' •',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2B7FFF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveDetails() {
    if (_fileNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a file name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      CustomSuccessSnackBar(
        title: 'Details saved successfully',
        subtitle: 'Your changes have been saved successfully',
      ),
    );

    Navigator.pop(context);
  }
}
