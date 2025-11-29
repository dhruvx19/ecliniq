import 'package:ecliniq/ecliniq_api/appointment_service.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:ecliniq/ecliniq_modules/screens/auth/provider/auth_provider.dart';
import 'package:ecliniq/ecliniq_ui/lib/widgets/snackbar/success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RatingBottomSheet extends StatefulWidget {
  final int initialRating;
  final String doctorName;
  final String appointmentId;
  final Function(int rating)? onRatingSubmitted;

  const RatingBottomSheet({
    super.key,
    this.initialRating = 0,
    required this.doctorName,
    required this.appointmentId,
    this.onRatingSubmitted,
  });

  /// Static method to show the bottom sheet
  static Future<int?> show({
    required BuildContext context,
    int initialRating = 0,
    required String doctorName,
    required String appointmentId,
    Function(int rating)? onRatingSubmitted,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => RatingBottomSheet(
        initialRating: initialRating,
        doctorName: doctorName,
        appointmentId: appointmentId,
        onRatingSubmitted: onRatingSubmitted,
      ),
    );
  }

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  late int _tempRating;
  bool _isSubmitting = false;
  final _appointmentService = AppointmentService();

  @override
  void initState() {
    super.initState();
    _tempRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          const SizedBox(height: 16),
          Text(
            'How was your Experience with ${widget.doctorName}?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
          ),

          const SizedBox(height: 16),
          _buildRatingStars(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildRatingStars() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rate your Experience :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2372EC),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(5, (index) {
                  final filled = index < _tempRating;
                  return GestureDetector(
                    onTap: () {
                      setModalState(() {
                        _tempRating = index + 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: SvgPicture.asset(
                        filled
                            ? EcliniqIcons.starRateExp.assetPath
                            : EcliniqIcons.starRateExpUnfilled.assetPath,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitRating() async {
    if (_tempRating == 0) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authToken = authProvider.authToken;

      if (authToken == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication required. Please login again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        Navigator.of(context).pop();
        return;
      }

      final res = await _appointmentService.rateAppointment(
        appointmentId: widget.appointmentId,
        rating: _tempRating,
        authToken: authToken,
      );

      if (!mounted) return;

      if (res['success'] == true) {
        // Call the callback if provided
        if (widget.onRatingSubmitted != null) {
          widget.onRatingSubmitted!(_tempRating);
        }

        // Close bottom sheet first
        Navigator.of(context).pop(_tempRating);

        // Show success snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSuccessSnackBar(
            context: context,
            title: 'Rating Submitted',
            subtitle: res['message']?.toString() ?? 'Thank you for your feedback!',
            duration: const Duration(seconds: 3),
          ),
        );

        // Show thank you snackbar after a short delay
        await Future.delayed(const Duration(milliseconds: 3500));
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSuccessSnackBar(
              context: context,
              title: 'Thank You!',
              subtitle: 'Your feedback helps us improve our services',
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res['message']?.toString() ?? 'Failed to submit rating',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit rating: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRating,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2372EC),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit Feedback',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
