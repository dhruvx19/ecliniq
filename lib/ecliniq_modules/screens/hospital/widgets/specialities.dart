import 'package:ecliniq/ecliniq_api/models/hospital.dart';
import 'package:flutter/material.dart';

class MedicalSpecialtiesWidget extends StatelessWidget {
  final List<HospitalSpecialty>? specialties;

  const MedicalSpecialtiesWidget({super.key, this.specialties});

  @override
  Widget build(BuildContext context) {
    final specialtyNames = specialties?.map((s) => s.name).toList() ?? [];

    if (specialtyNames.isEmpty) {
      return const SizedBox.shrink();
    }

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
                'Medical Specialties',
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
              spacing: 8,
              runSpacing: 12,
              children: specialtyNames.map((specialty) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class HospitalServicesWidget extends StatelessWidget {
  final List<String>? services;

  const HospitalServicesWidget({super.key, this.services});

  @override
  Widget build(BuildContext context) {
    final serviceList = services ?? [];

    if (serviceList.isEmpty) {
      return const SizedBox.shrink();
    }

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
                'Hospital Services & Facilities',
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
              spacing: 8,
              runSpacing: 12,
              children: serviceList.map((service) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    service,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class CertificatesWidget extends StatelessWidget {
  final List<String>? accreditation;

  const CertificatesWidget({super.key, this.accreditation});

  @override
  Widget build(BuildContext context) {
    final certificates = accreditation?.map((acc) => {
          'icon': Icons.verified_outlined,
          'name': acc,
        }).toList() ?? [];

    if (certificates.isEmpty) {
      return const SizedBox.shrink();
    }

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


class ContactDetailsWidget extends StatelessWidget {
  const ContactDetailsWidget({super.key});

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
                  iconColor: Color(0xFF5B9FFF),
                  title: 'contact@manipalbaner.com',
                  subtitle: 'Hospital Contact Email',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.business_outlined,
                  iconColor: Color(0xFF5B9FFF),
                  title: '9876543210',
                  subtitle: 'Hospital Contact Number',
                  showCallButton: true,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.phone_outlined,
                  iconColor: Color(0xFF5B9FFF),
                  title: '02068138888',
                  subtitle: 'Emergency Contact Number',
                  showCallButton: true,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.home_outlined,
                  iconColor: Color(0xFFFFB74D),
                  title: '02068138888',
                  subtitle: 'Ambulance Contact Number',
                  showCallButton: true,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.water_drop_outlined,
                  iconColor: Color(0xFF5B9FFF),
                  title: '02068138888',
                  subtitle: 'Blood Bank Contact Number',
                  showCallButton: true,
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (showCallButton)
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            color: Colors.black54,
            onPressed: onTap,
          ),
      ],
    );
  }
}

