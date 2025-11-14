import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final Widget? errorWidget;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;

  const ShimmerNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.shimmerBaseColor = const Color(0xFF2B2F38), // dark-ish
    this.shimmerHighlightColor = const Color(0xFF3D4450), // light-ish
  });

  @override
  _ShimmerNetworkImageState createState() => _ShimmerNetworkImageState();
}

class _ShimmerNetworkImageState extends State<ShimmerNetworkImage> {
  bool _isLoaded = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(8);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!_isLoaded && !_hasError)
              Shimmer.fromColors(
                baseColor: widget.shimmerBaseColor,
                highlightColor: widget.shimmerHighlightColor,
                period: const Duration(milliseconds: 900),
                child: Container(color: widget.shimmerBaseColor),
              ),

            // Actual network image using loadingBuilder
            Image.network(
              widget.imageUrl,
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  // Image fully loaded
                  if (!_isLoaded) {
                    // mark loaded and trigger fade-in
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _isLoaded = true);
                    });
                  }
                  // Fade in the child once loaded
                  return AnimatedOpacity(
                    opacity: _isLoaded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    child: child,
                  );
                } else {
                  // Still loading -> keep placeholder visible
                  return const SizedBox.shrink();
                }
              },
              errorBuilder: (context, error, stackTrace) {
                // Mark error and show fallback
                if (!_hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _hasError = true);
                  });
                }
                return widget.errorWidget ??
                    Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white70),
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
