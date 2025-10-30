import 'package:flutter/material.dart';

class UploadBottomSheet extends StatefulWidget {
  final VoidCallback? onEditDocument;
  final VoidCallback? onDownloadDocument;
  final VoidCallback? onDeleteDocument;

  const UploadBottomSheet({
    super.key,
    this.onEditDocument,
    this.onDownloadDocument,
    this.onDeleteDocument,
  });

  @override
  State<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload From',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 24),

          _ActionOption(
            icon: Icons.edit,
            backgroundColor: const Color(0xFFE3F2FD),
            title: 'Take a Photo',
            onTap: () {
              Navigator.pop(context);
              widget.onEditDocument?.call();
            },
          ),

          const SizedBox(height: 16),

          _ActionOption(
            icon: Icons.download,
            backgroundColor: const Color(0xFFE3F2FD),
            title: 'Gallery',
            onTap: () {
              Navigator.pop(context);
              widget.onDownloadDocument?.call();
            },
          ),

          const SizedBox(height: 16),

          _ActionOption(
            icon: Icons.delete,
            backgroundColor: const Color(0xFFFFEBEE),
            title: 'Files',
            isDestructive: true,
            onTap: () {
              Navigator.pop(context);
              widget.onDeleteDocument?.call();
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ActionOption extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final String title;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionOption({
    required this.icon,
    required this.backgroundColor,
    required this.title,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF424242),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
