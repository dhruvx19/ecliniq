import 'package:flutter/material.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({super.key});

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
                      'Clinic Address',
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
                  maxLines: 8,
                  'Survey No 111/11/1, Veerbhadra Nagar Road, Mhalunge Main Road, Baner, Pune, Maharashtra - 411045.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff626060),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            height: 70,
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.map_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Tap to get the clinic direction',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
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
