import 'package:flutter/material.dart';

class AboutHospital extends StatelessWidget {
  const AboutHospital({super.key});

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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'About',
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

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  maxLines: 18,
                  'Sunrise Family Clinic is a premier healthcare facility located in the heart of Wakad, Pune. With a dedicated team led by Dr. Milind Chauhan, a highly experienced general physician, the clinic offers personalized medical care tailored to each patient\'s needs. The clinic features state-of-the-art equipment and a warm, welcoming environment, ensuring that patients receive the best possible treatment. Services include routine check-ups, preventive care, and management of chronic conditions, all aimed at promoting overall health and well-being.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff626060),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
