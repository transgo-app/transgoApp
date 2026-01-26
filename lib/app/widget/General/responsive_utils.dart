import 'package:flutter/material.dart';

/// Responsive utility class for consistent responsive design patterns
class ResponsiveUtils {
  /// Get responsive font size based on screen width
  /// Returns a scaled font size that adapts to screen size
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Scale factor based on screen width
    // For screens smaller than 360px, scale down
    // For screens larger than 414px, scale up slightly
    if (screenWidth < 360) {
      return baseFontSize * 0.9;
    } else if (screenWidth < 375) {
      return baseFontSize * 0.95;
    } else if (screenWidth > 414) {
      return baseFontSize * 1.05;
    }
    
    return baseFontSize;
  }

  /// Get responsive padding based on screen width
  static EdgeInsets getResponsivePadding(BuildContext context, {
    double? horizontal,
    double? vertical,
    double? all,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth < 360 ? 0.85 : (screenWidth < 375 ? 0.9 : 1.0);
    
    if (all != null) {
      return EdgeInsets.all(all * scaleFactor);
    }
    
    return EdgeInsets.symmetric(
      horizontal: (horizontal ?? 0) * scaleFactor,
      vertical: (vertical ?? 0) * scaleFactor,
    );
  }

  /// Get responsive margin based on screen width
  static EdgeInsets getResponsiveMargin(BuildContext context, {
    double? horizontal,
    double? vertical,
    double? all,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth < 360 ? 0.85 : (screenWidth < 375 ? 0.9 : 1.0);
    
    if (all != null) {
      return EdgeInsets.all(all * scaleFactor);
    }
    
    return EdgeInsets.symmetric(
      horizontal: (horizontal ?? 0) * scaleFactor,
      vertical: (vertical ?? 0) * scaleFactor,
    );
  }

  /// Check if screen is small (less than 360px)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  /// Check if screen is medium (360px - 414px)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 360 && width <= 414;
  }

  /// Check if screen is large (greater than 414px)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 414;
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 360) {
      return baseSize * 0.9;
    } else if (screenWidth > 414) {
      return baseSize * 1.1;
    }
    
    return baseSize;
  }
}

/// Responsive text widget that automatically scales based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  const ResponsiveText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = ResponsiveUtils.getResponsiveFontSize(context, fontSize);
    
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: (style ?? TextStyle()).copyWith(
        fontSize: responsiveFontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? horizontal;
  final double? vertical;
  final double? all;

  const ResponsivePadding({
    Key? key,
    required this.child,
    this.horizontal,
    this.vertical,
    this.all,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(
        context,
        horizontal: horizontal,
        vertical: vertical,
        all: all,
      ),
      child: child,
    );
  }
}

/// Responsive margin widget
class ResponsiveMargin extends StatelessWidget {
  final Widget child;
  final double? horizontal;
  final double? vertical;
  final double? all;

  const ResponsiveMargin({
    Key? key,
    required this.child,
    this.horizontal,
    this.vertical,
    this.all,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveUtils.getResponsiveMargin(
        context,
        horizontal: horizontal,
        vertical: vertical,
        all: all,
      ),
      child: child,
    );
  }
}
