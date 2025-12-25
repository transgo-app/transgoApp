import 'package:flutter/material.dart';
import '../controllers/detailitems_controller.dart';

class DetailitemsImageSection extends StatelessWidget {
  final DetailitemsController controller;

  const DetailitemsImageSection({super.key, required this.controller});
  String extractPhoto(Map? data) {
    if (data == null) return "";
    if (data['photo'] is String && (data['photo'] as String).isNotEmpty) {
      return data['photo'];
    }
    if (data['photo'] is Map &&
        data['photo']['photo'] is String &&
        (data['photo']['photo'] as String).isNotEmpty) {
      return data['photo']['photo'];
    }
    if (data['photos'] is List &&
        data['photos'].isNotEmpty &&
        data['photos'][0] is Map &&
        data['photos'][0]['photo'] is String &&
        (data['photos'][0]['photo'] as String).isNotEmpty) {
      return data['photos'][0]['photo'];
    }

    return "";
  }
  String getImageUrl(Map detailData) {
    final fleet = detailData['fleet'];
    final product = detailData['product'];

    final fleetPhoto = extractPhoto(fleet);
    if (fleetPhoto.isNotEmpty) return fleetPhoto;

    final productPhoto = extractPhoto(product);
    if (productPhoto.isNotEmpty) return productPhoto;

    return "https://via.placeholder.com/300x200?text=No+Image";
  }

  @override
  Widget build(BuildContext context) {
    final imgUrl = getImageUrl(controller.detailData);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imgUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 60),
        ),
      ),
    );
  }
}
