import 'package:ecliniq/ecliniq_core/router/route.dart';
import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ClinicalDetailsWidget extends StatelessWidget {
  const ClinicalDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Clinical Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff424242),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(
                  label: 'Clinic Name:',
                  value: 'Sunrise Family Clinic',
                ),
                const SizedBox(height: 12),
                _buildDetailItem(
                  label: 'Establishment Year:',
                  value: 'Aug, 2015',
                ),
                const SizedBox(height: 12),
                _buildDetailItem(
                  label: 'Clinic Contact Email:',
                  value: 'contact@sunrisefamilyclinic.com',
                ),
                const SizedBox(height: 12),
                _buildDetailItemWithIcon(
                  label: 'Clinic Contact Number:',
                  value: '9876543210',
                  icon: Icons.phone_outlined,
                  onIconTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildDetailItemWithIcon({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onIconTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: EcliniqRouter.pop,
              icon: SvgPicture.asset(
                EcliniqIcons.phone.assetPath,
                width: 32,
                height: 32,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class ProfessionalInformationWidget extends StatelessWidget {
  const ProfessionalInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Professional Information',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff424242),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(
                  label: 'MRN Number:',
                  value: '29AACCC2943F1ZS',
                  hasVerification: true,
                ),
                const SizedBox(height: 12),
                _buildDetailItem(
                  label: 'Registration Council:',
                  value: 'Maharashtra State Council',
                ),
                const SizedBox(height: 12),
                _buildDetailItem(label: 'Registration Year:', value: '2008'),
                const SizedBox(height: 12),
                _buildDetailItem(
                  label: 'Specialization:',
                  value: 'General Medicine (Exp: 19years)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    bool hasVerification = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xff626060),
              ),
            ),
            if (hasVerification) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified, size: 16, color: Colors.green),
            ],
          ],
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }
}


class DoctorContactDetailsWidget extends StatelessWidget {
  const DoctorContactDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildContactItem(
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFF5B9FFF),
                  title: 'Dr. MilindC@gmail.com',
                  subtitle: 'Doctor Contact Email',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.phone_outlined,
                  iconColor: const Color(0xFF5B9FFF),
                  title: '+91 98765 43210',
                  subtitle: 'Doctor Contact Number',
                  showCallButton: true,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.language_outlined,
                  iconColor: const Color(0xFF5B9FFF),
                  title: 'Hindi, Marathi & English',
                  subtitle: 'Speaks',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool showCallButton = false,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (showCallButton)
              IconButton(
                onPressed: EcliniqRouter.pop,
                icon: SvgPicture.asset(
                  EcliniqIcons.phone.assetPath,
                  width: 32,
                  height: 32,
                ),
              ),
          ],
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }
}


class EducationalInformationWidget extends StatelessWidget {
  const EducationalInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Educational Information',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildEducationItem(
                  degree: 'MBBS in General Medicine',
                  institution: 'Government Medical College, Nagpur',
                  type: 'Graduation Degree',
                  year: 'Completed in 2008',
                ),
                const SizedBox(height: 16),
                _buildEducationItem(
                  degree: 'MD in General Medicine',
                  institution: 'Government Medical College, Nagpur',
                  type: 'Post Graduation Degree',
                  year: 'Completed in 2011',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem({
    required String degree,
    required String institution,
    required String type,
    required String year,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF5B9FFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.school_outlined,
            color: Color(0xFF5B9FFF),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                degree,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                institution,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$type - $year',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class DoctorCertificatesWidget extends StatelessWidget {
  const DoctorCertificatesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final certificates = [
      {'icon': Icons.verified_outlined, 'name': 'NABH'},
      {'icon': Icons.verified_outlined, 'name': 'ISO Certifications'},
      {'icon': Icons.verified_outlined, 'name': 'JCI'},
    ];

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
              const Text(
                'Certificates & Accreditations',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              children: certificates.map((cert) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cert['icon'] as IconData,
                      size: 20,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cert['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class ClinicPhotosWidget extends StatelessWidget {
  const ClinicPhotosWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Clinic Photos',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPhotoItem(imageUrl: 'assets/clinic1.jpg'),
                  const SizedBox(width: 12),
                  _buildPhotoItem(imageUrl: 'assets/clinic2.jpg'),
                  const SizedBox(width: 12),
                  _buildPhotoItem(imageUrl: 'assets/clinic1.jpg'),
                  const SizedBox(width: 12),
                  _buildPhotoItem(imageUrl: 'assets/clinic3.jpg', label: null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoItem({required String imageUrl, String? label}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [

            Container(
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: Colors.grey[500],
                ),
              ),
            ),
            if (label != null)
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
