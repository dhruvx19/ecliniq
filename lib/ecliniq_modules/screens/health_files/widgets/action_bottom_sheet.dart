import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_modules/screens/health_files/recently_uploaded.dart';
import 'package:flutter/material.dart';

class ActionBottomSheet extends StatefulWidget {
  final VoidCallback? onEditDocument;
  final VoidCallback? onDownloadDocument;
  final VoidCallback? onDeleteDocument;

  const ActionBottomSheet({
    super.key,
    this.onEditDocument,
    this.onDownloadDocument,
    this.onDeleteDocument,
  });

  @override
  State<ActionBottomSheet> createState() => _ActionBottomSheetState();
}

class _ActionBottomSheetState extends State<ActionBottomSheet> {
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
            'Choose Action',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 24),

          _ActionOption(
            icon: Icons.edit,
            iconColor: const Color(0xFF2B7FFF),
            backgroundColor: const Color(0xFFE3F2FD),
            title: 'Edit Document Details',
            onTap: () {
              EcliniqRouter.push(EditDocumentDetailsPage());
            },
          ),

          const SizedBox(height: 16),

          _ActionOption(
            icon: Icons.download,
            iconColor: const Color(0xFF2B7FFF),
            backgroundColor: const Color(0xFFE3F2FD),
            title: 'Download Document',
            onTap: () {
              Navigator.pop(context);
              widget.onDownloadDocument?.call();
            },
          ),

          const SizedBox(height: 16),

          _ActionOption(
            icon: Icons.delete,
            iconColor: const Color(0xFFEF5350),
            backgroundColor: const Color(0xFFFFEBEE),
            title: 'Delete Document',
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
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionOption({
    required this.icon,
    required this.iconColor,
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
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDestructive
                        ? const Color(0xFFEF5350)
                        : const Color(0xFF2D2D2D),
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
