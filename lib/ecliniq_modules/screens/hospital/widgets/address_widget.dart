import 'package:ecliniq/ecliniq_api/models/hospital.dart';
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressWidget extends StatefulWidget {
  final HospitalDetail? hospital;

  const AddressWidget({super.key, this.hospital});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  Future<void> _openMapsDirections() async {
    if (widget.hospital == null) return;

    final lat = widget.hospital!.latitude;
    final lng = widget.hospital!.longitude;

    // Try Google Maps first
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    // Try Apple Maps (will fall back to web on Android)
    final appleMapsUrl = Uri.parse(
      'https://maps.apple.com/?daddr=$lat,$lng',
    );

    try {
      bool canLaunchGoogle = false;
      bool canLaunchApple = false;

      // Safely check if URLs can be launched
      try {
        canLaunchGoogle = await canLaunchUrl(googleMapsUrl);
      } catch (e) {
        // If canLaunchUrl fails, try to launch directly anyway
        canLaunchGoogle = false;
      }

      try {
        canLaunchApple = await canLaunchUrl(appleMapsUrl);
      } catch (e) {
        // If canLaunchUrl fails, try to launch directly anyway
        canLaunchApple = false;
      }

      // Try to launch Google Maps
      if (canLaunchGoogle) {
        try {
          await launchUrl(
            googleMapsUrl,
            mode: LaunchMode.externalApplication,
          );
          return; // Successfully launched, exit
        } catch (e) {
          // Continue to next option if Google Maps fails
        }
      }

      // Try to launch Apple Maps
      if (canLaunchApple) {
        try {
          await launchUrl(
            appleMapsUrl,
            mode: LaunchMode.externalApplication,
          );
          return; // Successfully launched, exit
        } catch (e) {
          // Continue to web fallback if Apple Maps fails
        }
      }

      // Fall back to web browser with Google Maps
      final webMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      try {
        await launchUrl(
          webMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        // If all methods fail, try launching without checking first
        // This works around iOS platform channel issues
        try {
          await launchUrl(
            googleMapsUrl,
            mode: LaunchMode.externalApplication,
          );
        } catch (finalLaunchError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unable to open maps app. Please try again or search for the location manually.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Silent fail - don't show error to user unless all methods fail
      // The error handling above already shows a user-friendly message
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = widget.hospital?.address.fullAddress ?? 'Address not available';
    
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(0xFF96BFFF),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff424242),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  maxLines: 8,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff8E8E8E),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: widget.hospital != null ? _openMapsDirections : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.shade50,
                                    Colors.blue.shade100,
                                  ],
                                ),
                              ),
                              child: widget.hospital != null
                                  ? Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Map preview - using gradient background
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 48,
                                                color: Colors.red,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                widget.hospital!.name,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Optional: Add a small map icon overlay
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.map,
                                              size: 16,
                                              color: Color(0xff2372EC),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.map_outlined,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: widget.hospital != null ? _openMapsDirections : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.directions,
                                  size: 18,
                                  color: widget.hospital != null
                                      ? Color(0xff2372EC)
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Tap to get directions',
                                  style: EcliniqTextStyles.bodySmall.copyWith(
                                    color: widget.hospital != null
                                        ? Color(0xff2372EC)
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
