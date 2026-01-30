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

    
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    
    final appleMapsUrl = Uri.parse('https://maps.apple.com/?daddr=$lat,$lng');

    try {
      bool canLaunchGoogle = false;
      bool canLaunchApple = false;

      
      try {
        canLaunchGoogle = await canLaunchUrl(googleMapsUrl);
      } catch (e) {
        
        canLaunchGoogle = false;
      }

      try {
        canLaunchApple = await canLaunchUrl(appleMapsUrl);
      } catch (e) {
        
        canLaunchApple = false;
      }

      
      if (canLaunchGoogle) {
        try {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
          return; 
        } catch (e) {
          
        }
      }

      
      if (canLaunchApple) {
        try {
          await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
          return; 
        } catch (e) {
          
        }
      }

      
      final webMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      try {
        await launchUrl(webMapsUrl, mode: LaunchMode.externalApplication);
      } catch (e) {
        
        
        try {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        } catch (finalLaunchError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Unable to open maps app. Please try again or search for the location manually.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final address =
        widget.hospital?.address.fullAddress ?? 'Address not available';

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
                     Text(
                      'Address',
                      style: EcliniqTextStyles.responsiveHeadlineLarge(context).copyWith(
                   
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
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  maxLines: 8,
                  style:  EcliniqTextStyles.responsiveHeadlineBMedium(context).copyWith(
         
                    fontWeight: FontWeight.w400,
                    color: Color(0xff626060),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: widget.hospital != null ? _openMapsDirections : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      border: Border.all(color: Color(0xffF9F9F9)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12,left: 12,right: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 70,
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
                                        
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.hospital!.name,
                                                style: EcliniqTextStyles.responsiveBodyXSmall(context).copyWith(
                                                
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
                          onTap: widget.hospital != null
                              ? _openMapsDirections
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              
                                Text(
                                  'Tap to get the clinic directions',
                                  style: EcliniqTextStyles.responsiveBodySmall(context).copyWith(
                                    color: widget.hospital != null
                                        ? Color(0xff2372EC)
                                        : Colors.grey,
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
