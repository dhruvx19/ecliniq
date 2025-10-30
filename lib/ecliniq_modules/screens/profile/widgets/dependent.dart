import 'package:flutter/material.dart';

class DependentsSection extends StatelessWidget {
  final List<Dependent> dependents;
  final VoidCallback? onAddDependent;
  final Function(Dependent)? onDependentTap;
  
  const DependentsSection({
    Key? key,
    required this.dependents,
    this.onAddDependent,
    this.onDependentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            "Add Dependents",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            ...dependents.map((dep) => Padding(
              padding: const EdgeInsets.only(right: 15),
              child: _DependentCard(
                label: dep.relation,
                isAdded: true,
                onTap: () => onDependentTap?.call(dep),
              ),
            )),
            _DependentCard(
              label: "Add",
              isAdded: false,
              onTap: onAddDependent,
            ),
          ],
        ),
      ],
    );
  }
}

class Dependent {
  final String id;
  final String name;
  final String relation;
  
  Dependent({
    required this.id,
    required this.name,
    required this.relation,
  });
}

class _DependentCard extends StatelessWidget {
  final String label;
  final bool isAdded;
  final VoidCallback? onTap;
  
  const _DependentCard({
    required this.label,
    required this.isAdded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isAdded ? Colors.orange[100] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: isAdded
                ? Icon(Icons.person, size: 35, color: Colors.orange[700])
                : Icon(Icons.add, size: 30, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isAdded ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}


class AppUpdateBanner extends StatelessWidget {
  final String currentVersion;
  final String? newVersion;
  final VoidCallback? onUpdate;
  
  const AppUpdateBanner({
    Key? key,
    required this.currentVersion,
    this.newVersion,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpdate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2372EC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            const Text(
              "App Update Available",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                newVersion ?? currentVersion,
                style: const TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}