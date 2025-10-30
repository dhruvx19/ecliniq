import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContainerShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const ContainerShimmer({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

