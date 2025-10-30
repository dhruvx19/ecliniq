
import 'package:ecliniq/ecliniq_modules/screens/hospital/model/model.dart';
import 'package:flutter/material.dart';

class TabNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final List<String> tabs;

  const TabNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}



class AboutSectionWidget extends StatelessWidget {
  final String about;

  const AboutSectionWidget({
    super.key,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            about,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}


class SpecialtiesWidget extends StatelessWidget {
  final List<String> specialties;

  const SpecialtiesWidget({
    super.key,
    required this.specialties,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical Specialties',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: specialties.map((specialty) {
              return Chip(
                label: Text(specialty),
                backgroundColor: Colors.grey[200],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}


class ServicesWidget extends StatelessWidget {
  final List<String> services;

  const ServicesWidget({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hospital Services & Facilities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: services.map((service) {
              return Chip(
                label: Text(service),
                backgroundColor: Colors.grey[200],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}


class CertificatesWidget extends StatelessWidget {
  final List<String> certificates;

  const CertificatesWidget({
    super.key,
    required this.certificates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Certificates & Accreditations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: certificates.map((cert) {
              return Chip(
                avatar: const Icon(Icons.verified, size: 18, color: Color(0xFF0E4395)),
                label: Text(cert),
                backgroundColor: Colors.blue[50],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}



class ContactDetailsWidget extends StatelessWidget {
  final String email;
  final String emailLabel;
  final List<ContactNumber> contactNumbers;

  const ContactDetailsWidget({
    super.key,
    required this.email,
    required this.emailLabel,
    required this.contactNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.email,
            title: email,
            subtitle: emailLabel,
            iconColor: const Color(0xFF0E4395),
          ),
          const SizedBox(height: 16),
          ...contactNumbers.map((contact) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildContactItem(
                icon: _getIconData(contact.icon),
                title: contact.number,
                subtitle: contact.label,
                iconColor: const Color(0xFF0E4395),
                showCallButton: true,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    bool showCallButton = false,
  }) {
    return Row(
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
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (showCallButton)
          IconButton(
            icon: const Icon(Icons.phone, color: Color(0xFF0E4395)),
            onPressed: () {},
          ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'phone':
        return Icons.phone;
      case 'call':
        return Icons.call;
      case 'home':
        return Icons.home;
      case 'water_drop':
        return Icons.water_drop;
      default:
        return Icons.phone;
    }
  }
}



class EasyBookingWidget extends StatelessWidget {
  final VoidCallback? onRequestCallback;
  final VoidCallback? onGetUpdates;

  const EasyBookingWidget({
    super.key,
    this.onRequestCallback,
    this.onGetUpdates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Easy Way to book',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.phone_callback, color: Color(0xFF0E4395)),
            title: const Text('Request a Callback'),
            subtitle: const Text('Assisted booking with expert'),
            trailing: TextButton(
              onPressed: onRequestCallback,
              child: const Text('Call Us'),
            ),
          ),
          CheckboxListTile(
            value: true,
            onChanged: (val) {},
            title: const Text('Get updates/information on WhatsApp/SMS'),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: const Color(0xFF0E4395),
          ),
        ],
      ),
    );
  }
}



class BookAppointmentButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BookAppointmentButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E4395),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}