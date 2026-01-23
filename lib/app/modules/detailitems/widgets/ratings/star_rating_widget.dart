import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color filledColor;
  final Color emptyColor;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.starSize = 16,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          // Full star
          return Icon(
            Icons.star,
            size: starSize,
            color: filledColor,
          );
        } else if (rating > index && rating < index + 1) {
          // Half star
          return Icon(
            Icons.star_half,
            size: starSize,
            color: filledColor,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            size: starSize,
            color: emptyColor,
          );
        }
      }),
    );
  }
}
