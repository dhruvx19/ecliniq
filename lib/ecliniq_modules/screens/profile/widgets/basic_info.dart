import 'package:ecliniq/ecliniq_icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BasicInfoCards extends StatelessWidget {
  final String age;
  final String gender;
  final String bloodGroup;

  const BasicInfoCards({
    super.key,
    required this.age,
    required this.gender,
    required this.bloodGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _InfoCard(
          path: EcliniqIcons.userHeartRounded.assetPath,
          label: "Age",
          value: age,
        ),
        Container(
          width: 1,
          height: 60,
          color: Colors.grey[300],
        ),
        _InfoCard(
          path: EcliniqIcons.gender.assetPath,
          label: "Gender",
          value: gender,
        ),
        Container(
          width: 1,
          height: 60,
          color: Colors.grey[300],
        ),
        _InfoCard(
          path: EcliniqIcons.dropperMinimalistic.assetPath,
          label: "Blood Group",
          value: bloodGroup,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String path;
  final String label;
  final String value;

  const _InfoCard({
    required this.path,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(path, height: 24, width: 24,),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final VoidCallback? onSettingsPressed;
  final String? profileImageUrl;

  const ProfileHeader({
    super.key,
    this.onSettingsPressed,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child:Column(
        children: [

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: IconButton(
                icon: const Icon(
                  Icons.my_location_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: onSettingsPressed,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(1.0),
                    Colors.white.withOpacity(0.0),
                  ],
                ).createShader(bounds);
              },
              child: const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 74,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),




        ],
      ),
    );
  }
}
