import 'package:flutter/material.dart';
import 'package:user_app/core/widgets/network_image_placeolder.dart';

class ImagePreviewRow extends StatelessWidget {
  final List<String> imageUrls;

  const ImagePreviewRow({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ShimmerNetworkImage(
            imageUrl: imageUrls[index],
            width: 46,
            height: 46,
            borderRadius: BorderRadius.circular(10),
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
