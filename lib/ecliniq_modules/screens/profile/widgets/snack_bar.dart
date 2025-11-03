import 'package:flutter/material.dart';

import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';

class EcliniqCustomSnackBar extends StatelessWidget {
  const EcliniqCustomSnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green,
                    ),

                    child: Center(child: Icon(Icons.check_rounded, color: Colors.black, size: 20,)),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dependents details saved successfully !',
                      style: EcliniqTextStyles.bodyMedium.copyWith(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Your changes have been saved successfully.',
                      style: EcliniqTextStyles.bodyXSmall.copyWith(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
