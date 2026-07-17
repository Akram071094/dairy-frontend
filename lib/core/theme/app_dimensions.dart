import 'package:flutter/material.dart';

class AppDimensions {
  // Standard padding
  static const EdgeInsets screenPadding = EdgeInsets.all(24);
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 32, vertical: 16);

  // Border radius
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(24));

  // Card elevation
  static const double cardElevation = 1;
  static const double cardElevationHover = 4;
  static const double actionCardElevation = 2;
}
