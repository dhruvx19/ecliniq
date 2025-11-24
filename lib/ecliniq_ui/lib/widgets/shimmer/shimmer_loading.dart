import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable shimmer loading widget for API calls and content loading
class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Shimmer loading for list items
class ShimmerListLoading extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  const ShimmerListLoading({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 100,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ShimmerLoading(
            height: itemHeight,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}

/// Shimmer loading for card items
class ShimmerCardLoading extends StatelessWidget {
  final int itemCount;
  final double? cardHeight;
  final EdgeInsets? padding;

  const ShimmerCardLoading({
    super.key,
    this.itemCount = 2,
    this.cardHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ShimmerLoading(
            width: 200,
            height: cardHeight ?? 150,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}

/// Shimmer loading for full screen loading states
class ShimmerFullScreenLoading extends StatelessWidget {
  final String? message;

  const ShimmerFullScreenLoading({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShimmerLoading(
            width: 200,
            height: 200,
            borderRadius: BorderRadius.circular(100),
          ),
          if (message != null) ...[
            const SizedBox(height: 24),
            ShimmerLoading(
              width: 150,
              height: 20,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            ShimmerLoading(
              width: 100,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shimmer loading for button states
class ShimmerButtonLoading extends StatelessWidget {
  final double? width;
  final double? height;

  const ShimmerButtonLoading({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      width: width ?? double.infinity,
      height: height ?? 48,
      borderRadius: BorderRadius.circular(8),
    );
  }
}

