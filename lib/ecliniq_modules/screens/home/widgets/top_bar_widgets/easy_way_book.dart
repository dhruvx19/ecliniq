import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:flutter/material.dart';

class EasyWayToBookWidget extends StatefulWidget {
  const EasyWayToBookWidget({super.key});

  @override
  State<EasyWayToBookWidget> createState() => _EasyWayToBookWidgetState();
}

class _EasyWayToBookWidgetState extends State<EasyWayToBookWidget> {
  bool _isWhatsAppEnabled = true;

  void _callUs() {

    print('Call us tapped');
  }

  void _toggleWhatsAppUpdates(bool value) {
    setState(() {
      _isWhatsAppEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            SizedBox(width: 16),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Easy Way to book',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),


        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset(
                    EcliniqIcons.call.assetPath,
                    width: 36,
                    height: 36,
                  ),
                  const SizedBox(width: 12),


                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Request a Callback',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Assisted booking with expert',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  OutlinedButton(
                    onPressed: _callUs,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      side: const BorderSide(
                        color: Color(0xFF2196F3),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Call Us',
                      style: TextStyle(
                        color: Color(0xFF2196F3),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: Colors.grey.shade200),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleWhatsAppUpdates(!_isWhatsAppEnabled),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _isWhatsAppEnabled
                            ? const Color(0xFF2196F3)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _isWhatsAppEnabled
                              ? const Color(0xFF2196F3)
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: _isWhatsAppEnabled
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),


                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleWhatsAppUpdates(!_isWhatsAppEnabled),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        'Get updates/information on WhatsApp/SMS',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
