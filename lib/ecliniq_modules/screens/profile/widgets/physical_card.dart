import 'package:flutter/material.dart';

class PhysicalHealthCard extends StatelessWidget {
  final String status;
  final double bmi;
  final String height;
  final String weight;
  
  const PhysicalHealthCard({
    Key? key,
    required this.status,
    required this.bmi,
    required this.height,
    required this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Physical Health Info",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          _HealthStatusBadge(status: status),
          const SizedBox(height: 15),
          _BMIIndicator(bmi: bmi),
          const SizedBox(height: 20),
          _HeightWeightInfo(height: height, weight: weight),
        ],
      ),
    );
  }
}

class _HealthStatusBadge extends StatelessWidget {
  final String status;
  
  const _HealthStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isHealthy = status.toLowerCase() == 'healthy';
    final color = isHealthy ? Colors.green : Colors.orange;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _BMIIndicator extends StatelessWidget {
  final double bmi;
  
  const _BMIIndicator({required this.bmi});

  @override
  Widget build(BuildContext context) {

    double position = ((bmi - 15) / 25).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                  ],
                ),
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width - 80) * position,
              top: -5,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getBMIColor(bmi),
            ),
          ),
        ),
      ],
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.yellow;
    if (bmi < 35) return Colors.orange;
    return Colors.red;
  }
}

class _HeightWeightInfo extends StatelessWidget {
  final String height;
  final String weight;
  
  const _HeightWeightInfo({
    required this.height,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              "Height",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              height,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          height: 40,
          width: 1,
          color: Colors.grey[300],
        ),
        Column(
          children: [
            Text(
              "Weight",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              weight,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
